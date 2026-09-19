import Foundation
import SwiftUI

// MARK: - Auth

enum SSHAuthMethod: String, Codable, CaseIterable, Identifiable {
    case password = "password"
    case privateKey = "key"
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .password: return "Hasło"
        case .privateKey: return "Klucz prywatny"
        }
    }
}

// MARK: - Server

struct SSHServer: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var host: String
    var port: Int = 22
    var username: String
    var authMethod: SSHAuthMethod = .password
    var groupId: UUID?
    var sfxIconName: String = "server.rack"
    var colorHex: String = "007AFF"
    var lastConnectedAt: Date?
    var notes: String = ""

    var displayAddress: String { "\(host):\(port)" }
    var color: Color { Color(hex: colorHex) ?? .blue }
}

// MARK: - Server Group

struct SSHServerGroup: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var colorHex: String = "636366"
    var isExpanded: Bool = true
    var color: Color { Color(hex: colorHex) ?? .gray }
}

// MARK: - Snippet

struct SSHSnippet: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var command: String
    var description: String = ""
    var groupName: String = ""
}

// MARK: - SFTP

struct SFTPItem: Identifiable {
    var id: String { path }
    let path: String
    let name: String
    let isDirectory: Bool
    let isSymlink: Bool
    let size: Int64
    let modifiedAt: Date?
    let permissions: String

    var displaySize: String {
        guard !isDirectory else { return "" }
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
    var iconName: String {
        if isSymlink { return "link" }
        if isDirectory { return "folder.fill" }
        let ext = (name as NSString).pathExtension.lowercased()
        switch ext {
        case "txt", "md", "log", "conf", "cfg", "ini", "yaml", "yml", "json", "toml", "sh", "py", "rb", "js", "ts", "swift", "go", "rs", "c", "h", "cpp", "java": return "doc.text.fill"
        case "jpg", "jpeg", "png", "gif", "bmp", "svg", "webp": return "photo.fill"
        case "zip", "gz", "tar", "bz2", "xz", "7z": return "archivebox.fill"
        case "mp4", "mkv", "avi", "mov": return "film.fill"
        case "mp3", "flac", "ogg", "wav", "aac": return "music.note"
        case "pdf": return "doc.richtext.fill"
        default: return "doc.fill"
        }
    }
}

// MARK: - Resource Stats

struct ServerResourceStats {
    let cpuPercent: Double
    let memUsedMiB: Int
    let memTotalMiB: Int
    let diskUsedGB: Double
    let diskTotalGB: Double
    let uptimeSeconds: Int

    var memPercent: Double { memTotalMiB > 0 ? Double(memUsedMiB) / Double(memTotalMiB) : 0 }
    var diskPercent: Double { diskTotalGB > 0 ? diskUsedGB / diskTotalGB : 0 }
    var memText: String { "\(memUsedMiB) MiB / \(memTotalMiB) MiB" }
    var diskText: String { String(format: "%.1f GB / %.1f GB", diskUsedGB, diskTotalGB) }
    var cpuText: String { String(format: "%.1f%%", cpuPercent) }
    var uptimeText: String {
        let s = uptimeSeconds
        let days = s / 86400; let hours = (s % 86400) / 3600; let minutes = (s % 3600) / 60
        if days > 0 { return "\(days)d \(hours)h" }
        if hours > 0 { return "\(hours)h \(minutes)m" }
        return "\(minutes)m"
    }
}

// MARK: - Terminal

struct TerminalLine: Identifiable {
    let id = UUID()
    let content: String
    let isCommand: Bool
    let isError: Bool
    let timestamp: Date
    init(_ content: String, isCommand: Bool = false, isError: Bool = false) {
        self.content = content; self.isCommand = isCommand; self.isError = isError; self.timestamp = Date()
    }
}

// MARK: - Active Session

struct SSHActiveSession: Identifiable {
    let id: UUID = UUID()
    let server: SSHServer
    var title: String { server.name }
}

// MARK: - Theme

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    var id: String { rawValue }
    var colorScheme: ColorScheme? {
        switch self { case .light: return .light; case .dark: return .dark; default: return nil }
    }
}

enum TerminalColorScheme: String, CaseIterable, Identifiable {
    case standard, dracula, nord, solarized, monokai, oneDark
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .dracula: return "Dracula"
        case .nord: return "Nord"
        case .solarized: return "Solarized Dark"
        case .monokai: return "Monokai"
        case .oneDark: return "One Dark"
        }
    }
    var backgroundColor: Color {
        switch self {
        case .standard: return Color(red: 0.07, green: 0.07, blue: 0.07)
        case .dracula: return Color(red: 0.157, green: 0.165, blue: 0.212)
        case .nord: return Color(red: 0.180, green: 0.204, blue: 0.251)
        case .solarized: return Color(red: 0.000, green: 0.169, blue: 0.212)
        case .monokai: return Color(red: 0.153, green: 0.157, blue: 0.133)
        case .oneDark: return Color(red: 0.157, green: 0.173, blue: 0.204)
        }
    }
    var textColor: Color {
        switch self {
        case .standard: return .green
        case .dracula: return Color(red: 0.973, green: 0.973, blue: 0.949)
        case .nord: return Color(red: 0.847, green: 0.871, blue: 0.914)
        case .solarized: return Color(red: 0.514, green: 0.580, blue: 0.588)
        case .monokai: return Color(red: 0.973, green: 0.973, blue: 0.949)
        case .oneDark: return Color(red: 0.671, green: 0.698, blue: 0.749)
        }
    }
    var promptColor: Color {
        switch self {
        case .standard: return .cyan
        case .dracula: return Color(red: 0.741, green: 0.576, blue: 0.976)
        case .nord: return Color(red: 0.533, green: 0.753, blue: 0.816)
        case .solarized: return Color(red: 0.149, green: 0.545, blue: 0.824)
        case .monokai: return Color(red: 0.651, green: 0.886, blue: 0.180)
        case .oneDark: return Color(red: 0.380, green: 0.686, blue: 0.937)
        }
    }
}

// MARK: - Errors

enum SSHClientError: LocalizedError {
    case invalidAddress
    case authenticationFailed
    case connectionFailed(String)
    case commandFailed(String)
    case sftpFailed(String)
    case keyImportFailed
    case notConnected

    var errorDescription: String? {
        switch self {
        case .invalidAddress: return "Podaj prawidłowy adres serwera SSH."
        case .authenticationFailed: return "Uwierzytelnianie nie powiodło się. Sprawdź dane logowania."
        case .connectionFailed(let msg): return "Połączenie nie powiodło się: \(msg)"
        case .commandFailed(let msg): return "Komenda zakończyła się błędem: \(msg)"
        case .sftpFailed(let msg): return "Błąd SFTP: \(msg)"
        case .keyImportFailed: return "Nie udało się zaimportować klucza SSH."
        case .notConnected: return "Brak aktywnego połączenia SSH."
        }
    }
}

// MARK: - Color Extension

extension Color {
    init?(hex: String) {
        var str = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if str.hasPrefix("#") { str.removeFirst() }
        guard str.count == 6, let hex = UInt64(str, radix: 16) else { return nil }
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
    func toHex() -> String {
        let uic = UIColor(self)
        var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0; var a: CGFloat = 0
        uic.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
