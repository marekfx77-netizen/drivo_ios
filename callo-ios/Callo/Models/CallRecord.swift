import Foundation
import SwiftUI

public enum CallDirection: String, Codable {
    case outgoing
    case incoming
    case missed
}

public struct CallRecord: Identifiable, Codable {
    public let id: UUID
    public let contactName: String?
    public let phoneNumber: String
    public let direction: CallDirection
    public let date: Date
    public let durationSeconds: Int
    public let isEncrypted: Bool
    
    public init(
        id: UUID = UUID(),
        contactName: String? = nil,
        phoneNumber: String,
        direction: CallDirection,
        date: Date = Date(),
        durationSeconds: Int = 0,
        isEncrypted: Bool = true
    ) {
        self.id = id
        self.contactName = contactName
        self.phoneNumber = phoneNumber
        self.direction = direction
        self.date = date
        self.durationSeconds = durationSeconds
        self.isEncrypted = isEncrypted
    }
    
    public var displayName: String {
        if let name = contactName, !name.isEmpty {
            return name
        }
        return phoneNumber
    }
    
    public var formattedDuration: String {
        if direction == .missed {
            return "Nieodebrane"
        }
        let minutes = durationSeconds / 60
        let seconds = durationSeconds % 60
        if minutes > 0 {
            return "\(minutes) min \(seconds) s"
        } else {
            return "\(seconds) s"
        }
    }
    
    public var relativeTimeFormatted: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
