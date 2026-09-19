import Foundation
import Citadel
import NIOCore
import CryptoKit


actor SSHClient {
    private var client: Citadel.SSHClient?
    private let server: SSHServer

    init(server: SSHServer) {
        self.server = server
    }

    // MARK: - Connect

    func connect(password: String) async throws {
        let host = server.host.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !host.isEmpty else { throw SSHClientError.invalidAddress }
        do {
            client = try await Citadel.SSHClient.connect(
                host: host,
                port: server.port,
                authenticationMethod: .passwordBased(username: server.username, password: password),
                hostKeyValidator: .acceptAnything(),
                reconnect: .never
            )
        } catch {
            let msg = error.localizedDescription
            if msg.lowercased().contains("auth") || msg.lowercased().contains("password") {
                throw SSHClientError.authenticationFailed
            }
            throw SSHClientError.connectionFailed(msg)
        }
    }

    func connectWithKey(keyName: String) async throws {
        let host = server.host.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !host.isEmpty else { throw SSHClientError.invalidAddress }
        guard let pem = SSHKeychain.loadPrivateKey(name: keyName) else {
            throw SSHClientError.keyImportFailed
        }
        do {
            // Strip header/footer lines and whitespace
            let lines = pem.components(separatedBy: .newlines)
                .filter { !$0.hasPrefix("-----") && !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            guard let b64Data = Data(base64Encoded: lines.joined()),
                  b64Data.count >= 32 else {
                throw SSHClientError.keyImportFailed
            }
            // Use last 32 bytes as Ed25519 private key seed
            let seed = b64Data.suffix(32)
            let ed25519Key = try Curve25519.Signing.PrivateKey(rawRepresentation: seed)
            
            client = try await Citadel.SSHClient.connect(
                host: host,
                port: server.port,
                authenticationMethod: .ed25519(username: server.username, privateKey: ed25519Key),
                hostKeyValidator: .acceptAnything(),
                reconnect: .never
            )
        } catch let e as SSHClientError {
            throw e
        } catch {
            throw SSHClientError.connectionFailed(error.localizedDescription)
        }
    }

    var isConnected: Bool { client != nil }

    // MARK: - Execute Command

    func executeCommand(_ command: String) async throws -> String {
        guard let client else { throw SSHClientError.notConnected }
        do {
            var buffer = try await client.executeCommand(command)
            let output = buffer.readString(length: buffer.readableBytes) ?? ""
            return output
        } catch let e as SSHClientError {
            throw e
        } catch {
            throw SSHClientError.commandFailed(error.localizedDescription)
        }
    }

    // MARK: - Resource Stats

    func fetchResourceStats() async throws -> ServerResourceStats {
        async let cpuStr = try executeCommand("top -bn1 2>/dev/null | grep -i 'cpu' | head -1 | grep -oP '[0-9.]+(?=.*id)' || echo '0'")
        async let memStr = try executeCommand("free -m 2>/dev/null | awk 'NR==2{print $2\" \"$3}' || echo '0 0'")
        async let diskStr = try executeCommand("df -BG / 2>/dev/null | awk 'NR==2{gsub(/G/,\"\",$2); gsub(/G/,\"\",$3); print $2\" \"$3}' || echo '0 0'")
        async let uptimeStr = try executeCommand("cat /proc/uptime 2>/dev/null | awk '{print int($1)}' || echo '0'")

        let (cpuRaw, memRaw, diskRaw, uptimeRaw) = try await (cpuStr, memStr, diskStr, uptimeStr)

        let idlePercent = Double(cpuRaw.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        let cpu = max(0, min(100, 100 - idlePercent))
        let memParts = memRaw.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")
        let memTotal = Int(memParts.first ?? "0") ?? 0
        let memUsed = Int(memParts.dropFirst().first ?? "0") ?? 0
        let diskParts = diskRaw.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")
        let diskTotal = Double(diskParts.first ?? "0") ?? 0
        let diskUsed = Double(diskParts.dropFirst().first ?? "0") ?? 0
        let uptime = Int(uptimeRaw.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0

        return ServerResourceStats(
            cpuPercent: cpu,
            memUsedMiB: memUsed,
            memTotalMiB: memTotal,
            diskUsedGB: diskUsed,
            diskTotalGB: diskTotal,
            uptimeSeconds: uptime
        )
    }

    // MARK: - SFTP

    func openSFTP() async throws -> SFTPSession {
        guard let client else { throw SSHClientError.notConnected }
        do {
            let sftp = try await client.openSFTP()
            return SFTPSession(sftp: sftp)
        } catch {
            throw SSHClientError.sftpFailed(error.localizedDescription)
        }
    }

    // MARK: - Disconnect

    func disconnect() async {
        try? await client?.close()
        client = nil
    }
}

// MARK: - SFTP Session wrapper

actor SFTPSession {
    private let sftp: Citadel.SFTPClient

    init(sftp: Citadel.SFTPClient) {
        self.sftp = sftp
    }

    func listDirectory(atPath path: String) async throws -> [SFTPItem] {
        do {
            let nameMessages = try await sftp.listDirectory(atPath: path)
            let components = nameMessages.flatMap(\.components)
            return components.compactMap { component -> SFTPItem? in
                let name = component.filename
                guard name != "." && name != ".." else { return nil }
                let attrs = component.attributes
                let rawPerm = attrs.permissions ?? 0
                let typeOctal = rawPerm >> 12
                let isDir = typeOctal == 0o4
                let isLink = typeOctal == 0o12
                let size = Int64(attrs.size ?? 0)
                let modifiedAt = attrs.accessModificationTime?.modificationTime
                let perm: String
                if attrs.permissions != nil {
                    perm = String(rawPerm & 0o7777, radix: 8)
                } else {
                    perm = isDir ? "755" : "644"
                }
                let fullPath = path == "/" ? "/\(name)" : "\(path)/\(name)"
                return SFTPItem(
                    path: fullPath,
                    name: name,
                    isDirectory: isDir,
                    isSymlink: isLink,
                    size: size,
                    modifiedAt: modifiedAt,
                    permissions: perm
                )
            }.sorted { a, b in
                if a.isDirectory != b.isDirectory { return a.isDirectory }
                return a.name.localizedCaseInsensitiveCompare(b.name) == .orderedAscending
            }
        } catch {
            throw SSHClientError.sftpFailed(error.localizedDescription)
        }
    }

    func readFile(atPath path: String) async throws -> Data {
        do {
            let file = try await sftp.openFile(filePath: path, flags: [.read])
            var buffer = try await file.readAll()
            try await file.close()
            let bytes = buffer.readBytes(length: buffer.readableBytes) ?? []
            return Data(bytes)
        } catch {
            throw SSHClientError.sftpFailed(error.localizedDescription)
        }
    }

    func writeFile(data: Data, atPath path: String) async throws {
        do {
            let file = try await sftp.openFile(filePath: path, flags: [.write, .create, .truncate])
            let buffer = ByteBuffer(bytes: data)
            try await file.write(buffer)
            try await file.close()
        } catch {
            throw SSHClientError.sftpFailed(error.localizedDescription)
        }
    }

    func createDirectory(atPath path: String) async throws {
        do {
            try await sftp.createDirectory(atPath: path)
        } catch {
            throw SSHClientError.sftpFailed(error.localizedDescription)
        }
    }

    func remove(atPath path: String, isDirectory: Bool) async throws {
        do {
            if isDirectory {
                try await sftp.rmdir(at: path)
            } else {
                try await sftp.remove(at: path)
            }
        } catch {
            throw SSHClientError.sftpFailed(error.localizedDescription)
        }
    }
}
