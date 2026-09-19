import Foundation
import SwiftUI

@MainActor
final class SSHAppSession: ObservableObject {
    // MARK: - Published state
    @Published var servers: [SSHServer] = []
    @Published var groups: [SSHServerGroup] = []
    @Published var snippets: [SSHSnippet] = []
    @Published var activeSessions: [SSHActiveSession] = []
    @Published var selectedSessionId: UUID?
    @Published var errorMessage: String?
    @Published var isGuestMode: Bool = false
    @Published var isWorking: Bool = false

    // MARK: - Persistence keys
    private let serversKey = "ssh_servers"
    private let groupsKey = "ssh_groups"
    private let snippetsKey = "ssh_snippets"

    init() {
        load()
        if servers.isEmpty && groups.isEmpty {
            // Seed demo data for first launch
            let demoGroup = SSHServerGroup(name: "Przykładowe", colorHex: "34C759")
            groups.append(demoGroup)
            servers.append(SSHServer(
                name: "Mój serwer",
                host: "192.168.1.1",
                port: 22,
                username: "root",
                authMethod: .password,
                groupId: demoGroup.id,
                sfxIconName: "server.rack",
                colorHex: "007AFF"
            ))
            save()
        }
    }

    // MARK: - Server management

    func addServer(_ server: SSHServer) {
        servers.append(server)
        save()
    }

    func updateServer(_ server: SSHServer) {
        if let idx = servers.firstIndex(where: { $0.id == server.id }) {
            servers[idx] = server
            save()
        }
    }

    func deleteServer(_ server: SSHServer) {
        servers.removeAll { $0.id == server.id }
        SSHKeychain.deletePassword(for: server.id)
        activeSessions.removeAll { $0.server.id == server.id }
        save()
    }

    func moveServers(from offsets: IndexSet, to destination: Int, in groupId: UUID?) {
        var list = servers(inGroup: groupId)
        list.move(fromOffsets: offsets, toOffset: destination)
        // Reorder in main array based on updated list
        for server in list {
            if let idx = servers.firstIndex(where: { $0.id == server.id }),
               let newIdx = list.firstIndex(where: { $0.id == server.id }) {
                servers.remove(at: idx)
                servers.insert(server, at: min(newIdx, servers.count))
            }
        }
        save()
    }

    // MARK: - Group management

    func addGroup(_ group: SSHServerGroup) {
        groups.append(group)
        save()
    }

    func updateGroup(_ group: SSHServerGroup) {
        if let idx = groups.firstIndex(where: { $0.id == group.id }) {
            groups[idx] = group
            save()
        }
    }

    func deleteGroup(_ group: SSHServerGroup) {
        // Move servers to ungrouped
        for idx in servers.indices where servers[idx].groupId == group.id {
            servers[idx].groupId = nil
        }
        groups.removeAll { $0.id == group.id }
        save()
    }

    func toggleGroupExpanded(_ group: SSHServerGroup) {
        if let idx = groups.firstIndex(where: { $0.id == group.id }) {
            groups[idx].isExpanded.toggle()
            save()
        }
    }

    // MARK: - Snippet management

    func addSnippet(_ snippet: SSHSnippet) {
        snippets.append(snippet)
        save()
    }

    func updateSnippet(_ snippet: SSHSnippet) {
        if let idx = snippets.firstIndex(where: { $0.id == snippet.id }) {
            snippets[idx] = snippet
            save()
        }
    }

    func deleteSnippet(_ snippet: SSHSnippet) {
        snippets.removeAll { $0.id == snippet.id }
        save()
    }

    // MARK: - Session management

    func openSession(for server: SSHServer) {
        if let existing = activeSessions.first(where: { $0.server.id == server.id }) {
            selectedSessionId = existing.id
            return
        }
        let session = SSHActiveSession(server: server)
        activeSessions.append(session)
        selectedSessionId = session.id
    }

    func closeSession(_ session: SSHActiveSession) {
        activeSessions.removeAll { $0.id == session.id }
        if selectedSessionId == session.id {
            selectedSessionId = activeSessions.last?.id
        }
    }

    // MARK: - Helpers

    func servers(inGroup groupId: UUID?) -> [SSHServer] {
        servers.filter { $0.groupId == groupId }
    }

    func ungroupedServers() -> [SSHServer] {
        servers.filter { $0.groupId == nil }
    }

    func markConnected(serverId: UUID) {
        if let idx = servers.firstIndex(where: { $0.id == serverId }) {
            servers[idx].lastConnectedAt = Date()
            save()
        }
    }

    func clearError() { errorMessage = nil }

    func enterGuestMode() { isGuestMode = true }

    func exitGuestMode() { isGuestMode = false }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(servers) { UserDefaults.standard.set(data, forKey: serversKey) }
        if let data = try? JSONEncoder().encode(groups) { UserDefaults.standard.set(data, forKey: groupsKey) }
        if let data = try? JSONEncoder().encode(snippets) { UserDefaults.standard.set(data, forKey: snippetsKey) }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: serversKey),
           let decoded = try? JSONDecoder().decode([SSHServer].self, from: data) { servers = decoded }
        if let data = UserDefaults.standard.data(forKey: groupsKey),
           let decoded = try? JSONDecoder().decode([SSHServerGroup].self, from: data) { groups = decoded }
        if let data = UserDefaults.standard.data(forKey: snippetsKey),
           let decoded = try? JSONDecoder().decode([SSHSnippet].self, from: data) { snippets = decoded }
    }
}
