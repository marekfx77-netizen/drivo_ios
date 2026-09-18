import Foundation

public struct VoicemailItem: Identifiable, Codable {
    public let id: UUID
    public let callerName: String?
    public let phoneNumber: String
    public let date: Date
    public let durationSeconds: Int
    public let transcript: String
    public var isRead: Bool
    
    public init(
        id: UUID = UUID(),
        callerName: String? = nil,
        phoneNumber: String,
        date: Date = Date(),
        durationSeconds: Int,
        transcript: String,
        isRead: Bool = false
    ) {
        self.id = id
        self.callerName = callerName
        self.phoneNumber = phoneNumber
        self.date = date
        self.durationSeconds = durationSeconds
        self.transcript = transcript
        self.isRead = isRead
    }
    
    public var displayName: String {
        callerName ?? phoneNumber
    }
    
    public var formattedDuration: String {
        let minutes = durationSeconds / 60
        let seconds = durationSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Sample Voicemails
public extension VoicemailItem {
    static let samples: [VoicemailItem] = [
        VoicemailItem(
            callerName: "Aleksandra Wiśniewska",
            phoneNumber: "+48 501 234 567",
            date: Date().addingTimeInterval(-3600 * 2),
            durationSeconds: 38,
            transcript: "Cześć Mikołaj! Przejrzałam najnowsze makiety interfejsu dialera i wyglądają rewelacyjnie. Daj mi znać kiedy masz chwilę, żeby omówić szczegóły wdrożenia. Pozdrawiam!",
            isRead: false
        ),
        VoicemailItem(
            callerName: "Michał Lewandowski",
            phoneNumber: "+48 602 987 654",
            date: Date().addingTimeInterval(-3600 * 14),
            durationSeconds: 52,
            transcript: "Hej, serwer SIP i bramka WebRTC są już skonfigurowane na środowisku stagingowym z pełnym szyfrowaniem SRTP. Czekam na Twój sygnał do testów.",
            isRead: true
        ),
        VoicemailItem(
            callerName: "Nieznany numer",
            phoneNumber: "+48 22 890 12 34",
            date: Date().addingTimeInterval(-3600 * 48),
            durationSeconds: 19,
            transcript: "Dzień dobry, kontaktuję się w sprawie potwierdzenia rezerwacji sali konferencyjnej na jutrzejszy briefing. Proszę o kontakt zwrotny.",
            isRead: true
        )
    ]
}
