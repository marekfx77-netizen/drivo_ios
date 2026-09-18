import Foundation
import SwiftUI

public struct Contact: Identifiable, Hashable {
    public let id: UUID
    public var name: String
    public var phoneNumber: String
    public var email: String
    public var company: String?
    public var isFavorite: Bool
    public var gradientColors: [Color]
    
    public init(
        id: UUID = UUID(),
        name: String,
        phoneNumber: String,
        email: String = "",
        company: String? = nil,
        isFavorite: Bool = false,
        gradientColors: [Color] = [AppTheme.neonPurple, AppTheme.neonBlue]
    ) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.company = company
        self.isFavorite = isFavorite
        self.gradientColors = gradientColors
    }
    
    public var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            let first = parts[0].prefix(1)
            let second = parts[1].prefix(1)
            return "\(first)\(second)".uppercased()
        } else if let first = parts.first {
            return String(first.prefix(2)).uppercased()
        }
        return "C"
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Sample Contacts
public extension Contact {
    static let samples: [Contact] = [
        Contact(
            name: "Aleksandra Wiśniewska",
            phoneNumber: "+48 501 234 567",
            email: "ola.wisniewska@domain.com",
            company: "Design Director",
            isFavorite: true,
            gradientColors: [Color(hex: 0x7C5CFC), Color(hex: 0x4F75FF)]
        ),
        Contact(
            name: "Michał Lewandowski",
            phoneNumber: "+48 602 987 654",
            email: "michal.lew@startup.io",
            company: "Tech Lead",
            isFavorite: true,
            gradientColors: [Color(hex: 0x00D68F), Color(hex: 0x4F75FF)]
        ),
        Contact(
            name: "Karolina Dąbrowska",
            phoneNumber: "+48 793 456 789",
            email: "karolina.d@agency.pl",
            company: "Product Manager",
            isFavorite: true,
            gradientColors: [Color(hex: 0xFF007A), Color(hex: 0x7C5CFC)]
        ),
        Contact(
            name: "Tomasz Zieliński",
            phoneNumber: "+48 512 888 999",
            email: "tomasz.zielinski@corp.pl",
            company: "VP Operations",
            isFavorite: false,
            gradientColors: [Color(hex: 0xFFB800), Color(hex: 0xFF3B30)]
        ),
        Contact(
            name: "Ewa Kowalczyk",
            phoneNumber: "+48 691 112 233",
            email: "ewa.kowalczyk@cloud.com",
            company: "Security Architect",
            isFavorite: false,
            gradientColors: [Color(hex: 0x4F75FF), Color(hex: 0x00FFAB)]
        ),
        Contact(
            name: "Bartosz Nowak",
            phoneNumber: "+48 504 777 888",
            email: "b.nowak@venture.vc",
            company: "Managing Partner",
            isFavorite: true,
            gradientColors: [Color(hex: 0x7C5CFC), Color(hex: 0xFF0055)]
        )
    ]
}
