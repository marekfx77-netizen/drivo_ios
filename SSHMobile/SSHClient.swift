import Foundation
import Citadel
import NIOSSH
import NIOCore
import NIOPosix

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
            // Try parsing as Ed25519 OpenSSH private key (most common modern format)
            let privateKey = try NIOSSHPrivateKey(ed25519Key: pem)
            client = try await Citadel.SSHClient.connect(
                host: host,
                port: server.port,
                authenticationMethod: .privateKey(username: server.username, privateKey: privateKey),
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
        // Run multiple commands to get stats
        async let cpuResult = try executeCommand("top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1 | tr -d ' ' 2>/dev/null || echo '0'")
        async let memResult = try executeCommand("free -m 2>/dev/null | awk 'NR==2{print $2\" \"$3}' || echo '0 0'")
        async let diskResult = try executeCommand("df -BG / 2>/dev/null | awk 'NR==2{gsub(/G/,\"\",$2); gsub(/G/,\"\",$3); print $2\" \"$3}' || echo '0 0'")
        async let uptimeResult = try executeCommand("cat /proc/uptime 2>/dev/null | awk '{print int($1)}' || echo '0'")

        let (cpuStr, memStr, diskStr, uptimeStr) = try await (cpuResult, memResult, diskResult, uptimeResult)

        let cpu = Double(cpuStr.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        let memParts = memStr.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")
        let memTotal = Int(memParts.first ?? "0") ?? 0
        let memUsed = Int(memParts.dropFirst().first ?? "0") ?? 0
        let diskParts = diskStr.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")
        let diskTotal = Double(diskParts.first ?? "0") ?? 0
        let diskUsed = Double(diskParts.dropFirst().first ?? "0") ?? 0
        let uptime = Int(uptimeStr.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0

        return ServerResourceStats(
            cpuPercent: min(max(cpu, 0), 100),
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
            let components = try await sftp.listDirectory(atPath: path)
            return components.compactMap { component -> SFTPItem? in
                guard component.filename != "." && component.filename != ".." else { return nil }
                let attrs = component.attributes
                let isDir = attrs.isDirectory
                let isLink = attrs.isSymlink
                let size = Int64(attrs.size ?? 0)
                let modifiedAt: Date? = attrs.modifyTime.map { Date(timeIntervalSince1970: TimeInterval($0)) }
                let perm: String
                if let permissions = attrs.permissions {
                    perm = String(permissions.rawValue, radix: 8)
                } else {
                    perm = isDir ? "755" : "644"
                }
                let fullPath = path == "/" ? "/\(component.filename)" : "\(path)/\(component.filename)"
                return SFTPItem(
                    path: fullPath,
                    name: component.filename,
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
            var file = try await sftp.openFile(filePath: path, flags: .read)
            let buffer = try await file.readAll()
            try await file.close()
            return Data(buffer.readableBytesView)
        } catch {
            throw SSHClientError.sftpFailed(error.localizedDescription)
        }
    }

    func writeFile(data: Data, atPath path: String) async throws {
        do {
            var buffer = ByteBuffer(bytes: data)
            var file = try await sftp.openFile(filePath: path, flags: [.write, .create, .truncate])
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

    func remove(atPath path: String) async throws {
        do {
            try await sftp.removeFile(atPath: path)
        } catch {
            throw SSHClientError.sftpFailed(error.localizedDescription)
        }
    }

    func removeDirectory(atPath path: String) async throws {
        do {
            try await sftp.removeDirectory(atPath: path)
        } catch {
            throw SSHClientError.sftpFailed(error.localizedDescription)
        }
    }
}
