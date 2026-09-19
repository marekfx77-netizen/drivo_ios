import Foundation
import SwiftUI

@MainActor
final class SSHTerminal: ObservableObject {
    @Published private(set) var lines: [TerminalLine] = []
    @Published private(set) var statusMessage: String = "Rozłączono"
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var isConnecting: Bool = false
    @Published private(set) var stats: ServerResourceStats?
    @Published private(set) var currentDirectory: String = "~"

    let server: SSHServer
    private var sshClient: SSHClient?
    private var statsTask: Task<Void, Never>?
    private var commandHistory: [String] = []
    private var historyIndex: Int = -1

    init(server: SSHServer) {
        self.server = server
    }

    // MARK: - Connect

    func connect(password: String) async {
        guard !isConnecting, !isConnected else { return }
        isConnecting = true
        statusMessage = "Łączenie z \(server.host)…"
        appendLine("Łączenie z \(server.displayAddress)…")

        let client = SSHClient(server: server)
        do {
            try await client.connect(password: password)
            sshClient = client
            isConnected = true
            isConnecting = false
            statusMessage = "Połączono z \(server.name)"
            appendLine("✓ Połączono pomyślnie.")

            // Get initial directory
            if let pwd = try? await client.executeCommand("pwd") {
                currentDirectory = pwd.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            // Send welcome info
            if let uname = try? await client.executeCommand("uname -r && hostname") {
                appendLine(uname.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            startStatsPolling()
        } catch {
            isConnecting = false
            statusMessage = "Błąd połączenia"
            appendLine("✗ \(error.localizedDescription)", isError: true)
        }
    }

    func connectWithKey(keyName: String) async {
        guard !isConnecting, !isConnected else { return }
        isConnecting = true
        statusMessage = "Łączenie z kluczem SSH…"
        appendLine("Łączenie z \(server.displayAddress) (klucz: \(keyName))…")

        let client = SSHClient(server: server)
        do {
            try await client.connectWithKey(keyName: keyName)
            sshClient = client
            isConnected = true
            isConnecting = false
            statusMessage = "Połączono z \(server.name)"
            appendLine("✓ Połączono pomyślnie.")
            startStatsPolling()
        } catch {
            isConnecting = false
            statusMessage = "Błąd połączenia"
            appendLine("✗ \(error.localizedDescription)", isError: true)
        }
    }

    // MARK: - Command execution

    func sendCommand(_ command: String) async {
        let trimmed = command.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, isConnected, let client = sshClient else { return }

        // Update history
        if commandHistory.last != trimmed {
            commandHistory.append(trimmed)
        }
        historyIndex = -1

        appendLine("\(currentDirectory) $ \(trimmed)", isCommand: true)

        // Handle cd specially — we track directory locally
        if trimmed.hasPrefix("cd ") || trimmed == "cd" {
            let target = trimmed == "cd" ? "~" : String(trimmed.dropFirst(3)).trimmingCharacters(in: .whitespaces)
            let fullCmd = "cd \(target) && pwd"
            if let result = try? await client.executeCommand(fullCmd) {
                let dir = result.trimmingCharacters(in: .whitespacesAndNewlines)
                if !dir.isEmpty { currentDirectory = dir }
            }
            return
        }

        do {
            // Run from current directory
            let fullCmd = "cd \(currentDirectory) 2>/dev/null; \(trimmed)"
            let output = try await client.executeCommand(fullCmd)
            if !output.isEmpty {
                appendLine(output.trimmingCharacters(in: .newlines))
            }
        } catch {
            appendLine("\(error.localizedDescription)", isError: true)
        }
    }

    func previousCommand() -> String? {
        guard !commandHistory.isEmpty else { return nil }
        if historyIndex == -1 { historyIndex = commandHistory.count - 1 }
        else if historyIndex > 0 { historyIndex -= 1 }
        return commandHistory[historyIndex]
    }

    func nextCommand() -> String? {
        guard !commandHistory.isEmpty, historyIndex >= 0 else { return nil }
        historyIndex += 1
        if historyIndex >= commandHistory.count { historyIndex = -1; return "" }
        return commandHistory[historyIndex]
    }

    // MARK: - Stats

    private func startStatsPolling() {
        statsTask?.cancel()
        statsTask = Task { [weak self] in
            while !Task.isCancelled {
                if let self, let client = await self.sshClient {
                    if let newStats = try? await client.fetchResourceStats() {
                        await MainActor.run { self.stats = newStats }
                    }
                }
                try? await Task.sleep(for: .seconds(10))
            }
        }
    }

    // MARK: - Control

    func clearOutput() {
        lines.removeAll()
    }

    func disconnect() {
        statsTask?.cancel()
        statsTask = nil
        Task { await sshClient?.disconnect() }
        sshClient = nil
        isConnected = false
        isConnecting = false
        statusMessage = "Rozłączono"
        appendLine("Sesja zakończona.")
    }

    func reconnect(password: String) async {
        disconnect()
        clearOutput()
        await connect(password: password)
    }

    // MARK: - Private helpers

    private func appendLine(_ text: String, isCommand: Bool = false, isError: Bool = false) {
        let line = TerminalLine(text, isCommand: isCommand, isError: isError)
        lines.append(line)
        // Trim if too long
        if lines.count > 2000 { lines.removeFirst(lines.count - 2000) }
    }
}
