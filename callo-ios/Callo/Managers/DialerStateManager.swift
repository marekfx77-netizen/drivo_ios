import SwiftUI
import Combine

// MARK: - Call Status Enum
public enum CallStateStatus: String {
    case idle
    case connecting = "Łączenie..."
    case ringing = "Sygnał wywoławczy..."
    case connected = "Połączono"
    case ended = "Połączenie zakończone"
}

// MARK: - Audio Route Enum
public enum AudioRoute: String, CaseIterable {
    case iphone = "Głośnik telefonu"
    case speaker = "Głośnomówiący"
    case bluetooth = "AirPods Pro"
    
    public var iconName: String {
        switch self {
        case .iphone: return "iphone"
        case .speaker: return "speaker.wave.3.fill"
        case .bluetooth: return "airpodspro"
        }
    }
}

// MARK: - Active Call Session
public struct ActiveCallSession {
    public var contactName: String?
    public var phoneNumber: String
    public var status: CallStateStatus
    public var durationSeconds: Int = 0
    public var isMuted: Bool = false
    public var audioRoute: AudioRoute = .iphone
    public var isOnHold: Bool = false
    public var isVideoEnabled: Bool = false
    public var isEncrypted: Bool = true
    
    public var formattedDuration: String {
        let minutes = durationSeconds / 60
        let seconds = durationSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Dialer State Manager
public final class DialerStateManager: ObservableObject {
    // MARK: - Published Properties
    @Published public var rawDigits: String = ""
    @Published public var activeCall: ActiveCallSession?
    @Published public var isCallScreenPresented: Bool = false
    @Published public var recents: [CallRecord] = []
    @Published public var contacts: [Contact] = Contact.samples
    @Published public var voicemails: [VoicemailItem] = VoicemailItem.samples
    
    // In-Call Soundwave Manager
    public let soundwave = SoundwaveManager()
    
    // Call duration timer & auto-connect timer
    private var callTimer: AnyCancellable?
    private var connectionTimer: AnyCancellable?
    
    public init() {
        loadMockRecents()
    }
    
    // MARK: - Keypad Operations
    public func appendDigit(_ digit: String) {
        HapticsManager.shared.keyPress()
        if rawDigits.count < 15 {
            rawDigits.append(digit)
        }
    }
    
    public func deleteDigit() {
        guard !rawDigits.isEmpty else { return }
        HapticsManager.shared.deleteKey()
        rawDigits.removeLast()
    }
    
    public func clearDigits() {
        guard !rawDigits.isEmpty else { return }
        HapticsManager.shared.deleteKey()
        rawDigits.removeAll()
    }
    
    // MARK: - Dynamic Formatting (Live Phone Formatter)
    public var formattedDigits: String {
        guard !rawDigits.isEmpty else { return "" }
        
        let digits = rawDigits
        if digits.hasPrefix("+") {
            // E.g. +48 501 234 567
            var result = ""
            for (idx, char) in digits.enumerated() {
                if idx == 3 || idx == 6 || idx == 9 || idx == 12 {
                    result.append(" ")
                }
                result.append(char)
            }
            return result
        } else {
            // E.g. 501 234 567
            var result = ""
            for (idx, char) in digits.enumerated() {
                if idx > 0 && idx % 3 == 0 && idx < 10 {
                    result.append(" ")
                }
                result.append(char)
            }
            return result
        }
    }
    
    // MARK: - Call Flow Management
    public func startCall(number: String? = nil, contactName: String? = nil) {
        let targetNumber = number ?? (rawDigits.isEmpty ? "Nieznany numer" : formattedDigits)
        guard !targetNumber.isEmpty else { return }
        
        HapticsManager.shared.callStart()
        
        // Lookup contact name if not passed
        var matchedName = contactName
        if matchedName == nil {
            let cleanTarget = targetNumber.replacingOccurrences(of: " ", with: "")
            if let matched = contacts.first(where: { $0.phoneNumber.replacingOccurrences(of: " ", with: "") == cleanTarget }) {
                matchedName = matched.name
            }
        }
        
        // Initialize call session
        let session = ActiveCallSession(
            contactName: matchedName,
            phoneNumber: targetNumber,
            status: .connecting
        )
        
        self.activeCall = session
        self.isCallScreenPresented = true
        
        // Symulacja sygnału łączenia i odebrania połączenia
        connectionTimer?.cancel()
        connectionTimer = Timer.publish(every: 1.2, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                guard let self = self, self.activeCall != nil else { return }
                self.activeCall?.status = .connected
                self.startCallTimer()
                self.soundwave.startVisualizer()
            }
    }
    
    public func endCall() {
        HapticsManager.shared.callEnd()
        soundwave.stopVisualizer()
        callTimer?.cancel()
        callTimer = nil
        connectionTimer?.cancel()
        connectionTimer = nil
        
        if let current = activeCall {
            // Zapis do historii ostatnich połączeń
            let record = CallRecord(
                contactName: current.contactName,
                phoneNumber: current.phoneNumber,
                direction: .outgoing,
                date: Date(),
                durationSeconds: current.durationSeconds,
                isEncrypted: current.isEncrypted
            )
            recents.insert(record, at: 0)
        }
        
        activeCall?.status = .ended
        
        // Zamknięcie ekranu z lekkim opóźnieniem dla płynności
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                self?.isCallScreenPresented = false
                self?.activeCall = nil
            }
        }
    }
    
    private func startCallTimer() {
        callTimer?.cancel()
        callTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, self.activeCall != nil else { return }
                self.activeCall?.durationSeconds += 1
            }
    }
    
    // MARK: - In-Call Controls
    public func toggleMute() {
        HapticsManager.shared.toggleControl()
        activeCall?.isMuted.toggle()
    }
    
    public func cycleAudioRoute() {
        HapticsManager.shared.toggleControl()
        guard let current = activeCall?.audioRoute else { return }
        switch current {
        case .iphone:
            activeCall?.audioRoute = .speaker
        case .speaker:
            activeCall?.audioRoute = .bluetooth
        case .bluetooth:
            activeCall?.audioRoute = .iphone
        }
    }
    
    public func setAudioRoute(_ route: AudioRoute) {
        HapticsManager.shared.toggleControl()
        activeCall?.audioRoute = route
    }
    
    public func toggleHold() {
        HapticsManager.shared.toggleControl()
        activeCall?.isOnHold.toggle()
        if activeCall?.isOnHold == true {
            soundwave.stopVisualizer()
        } else {
            soundwave.startVisualizer()
        }
    }
    
    public func toggleVideo() {
        HapticsManager.shared.toggleControl()
        activeCall?.isVideoEnabled.toggle()
    }
    
    // MARK: - Contact Operations
    public func addContact(name: String, phoneNumber: String) {
        let newContact = Contact(
            name: name,
            phoneNumber: phoneNumber,
            gradientColors: [AppTheme.neonPurple, AppTheme.callGreen]
        )
        contacts.append(newContact)
        HapticsManager.shared.success()
    }
    
    // MARK: - Mock History Data
    private func loadMockRecents() {
        recents = [
            CallRecord(
                contactName: "Aleksandra Wiśniewska",
                phoneNumber: "+48 501 234 567",
                direction: .incoming,
                date: Date().addingTimeInterval(-1800),
                durationSeconds: 245
            ),
            CallRecord(
                contactName: "Tomasz Zieliński",
                phoneNumber: "+48 512 888 999",
                direction: .missed,
                date: Date().addingTimeInterval(-3600 * 3),
                durationSeconds: 0
            ),
            CallRecord(
                contactName: "Michał Lewandowski",
                phoneNumber: "+48 602 987 654",
                direction: .outgoing,
                date: Date().addingTimeInterval(-3600 * 5),
                durationSeconds: 112
            ),
            CallRecord(
                contactName: "Karolina Dąbrowska",
                phoneNumber: "+48 793 456 789",
                direction: .missed,
                date: Date().addingTimeInterval(-3600 * 22),
                durationSeconds: 0
            ),
            CallRecord(
                contactName: "Kurier DHL",
                phoneNumber: "+48 22 555 44 33",
                direction: .incoming,
                date: Date().addingTimeInterval(-3600 * 48),
                durationSeconds: 45
            )
        ]
    }
}
