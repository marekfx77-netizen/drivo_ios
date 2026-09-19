import Foundation
import SwiftUI

@MainActor
final class SFTPManager: ObservableObject {
    @Published private(set) var items: [SFTPItem] = []
    @Published private(set) var currentPath: String = "/"
    @Published private(set) var pathHistory: [String] = ["/"]
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isConnected: Bool = false
    @Published var errorMessage: String?
    @Published private(set) var statusMessage: String = "Rozłączono"

    let server: SSHServer
    private var sshClient: SSHClient?
    private var sftpSession: SFTPSession?

    init(server: SSHServer) {
        self.server = server
    }

    // MARK: - Connect

    func connect(password: String) async {
        guard !isConnected else { return }
        isLoading = true
        statusMessage = "Łączenie…"
        let client = SSHClient(server: server)
        do {
            try await client.connect(password: password)
            let session = try await client.openSFTP()
            sshClient = client
            sftpSession = session
            isConnected = true
            statusMessage = "Połączono z \(server.name)"
            await loadDirectory(path: "/")
        } catch {
            errorMessage = error.localizedDescription
            statusMessage = "Błąd połączenia"
        }
        isLoading = false
    }

    // MARK: - Navigation

    func navigateTo(path: String) async {
        if path != currentPath {
            pathHistory.append(path)
        }
        await loadDirectory(path: path)
    }

    func navigateBack() async {
        guard pathHistory.count > 1 else { return }
        pathHistory.removeLast()
        let prev = pathHistory.last ?? "/"
        await loadDirectory(path: prev)
    }

    func navigateToParent() async {
        let parent = (currentPath as NSString).deletingLastPathComponent
        let target = parent.isEmpty ? "/" : parent
        await navigateTo(path: target)
    }

    func refresh() async {
        await loadDirectory(path: currentPath)
    }

    private func loadDirectory(path: String) async {
        guard let session = sftpSession else {
            errorMessage = "Brak połączenia SFTP."
            return
        }
        isLoading = true
        currentPath = path
        do {
            let newItems = try await session.listDirectory(atPath: path)
            items = newItems
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - File operations

    func readFile(_ item: SFTPItem) async throws -> Data {
        guard let session = sftpSession else { throw SSHClientError.notConnected }
        return try await session.readFile(atPath: item.path)
    }

    func writeFile(data: Data, atPath path: String) async throws {
        guard let session = sftpSession else { throw SSHClientError.notConnected }
        try await session.writeFile(data: data, atPath: path)
    }

    func createFolder(name: String) async {
        guard let session = sftpSession else { errorMessage = "Brak połączenia SFTP."; return }
        let newPath = currentPath == "/" ? "/\(name)" : "\(currentPath)/\(name)"
        do {
            try await session.createDirectory(atPath: newPath)
            await refresh()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteItem(_ item: SFTPItem) async {
        guard let session = sftpSession else { errorMessage = "Brak połączenia SFTP."; return }
        do {
            if item.isDirectory {
                try await session.removeDirectory(atPath: item.path)
            } else {
                try await session.remove(atPath: item.path)
            }
            items.removeAll { $0.path == item.path }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Breadcrumbs

    struct Breadcrumb: Identifiable {
        let id: String
        let name: String
        let path: String
    }

    var breadcrumbs: [Breadcrumb] {
        var crumbs: [Breadcrumb] = [Breadcrumb(id: "/", name: "/", path: "/")]
        let parts = currentPath.split(separator: "/").filter { !$0.isEmpty }
        var accumulated = ""
        for part in parts {
            accumulated += "/\(part)"
            crumbs.append(Breadcrumb(id: accumulated, name: String(part), path: accumulated))
        }
        return crumbs
    }

    // MARK: - Disconnect

    func disconnect() {
        Task { await sshClient?.disconnect() }
        sshClient = nil
        sftpSession = nil
        isConnected = false
        items = []
        statusMessage = "Rozłączono"
    }
}
