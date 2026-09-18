import SwiftUI
import Combine
import UIKit

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
    
    // Ustawienie: czy uruchamiać rzeczywiste połączenie GSM przez system iOS
    @AppStorage("realGSMCalling") public var realGSMCalling: Bool = true
    
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
        if rawDigits.count < 16 {
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
            var result = ""
            for (idx, char) in digits.enumerated() {
                if idx == 3 || idx == 6 || idx == 9 || idx == 12 {
                    result.append(" ")
                }
                result.append(char)
            }
            return result
        } else {
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
    
    // MARK: - Rzeczywiste połączenie telefoniczne iOS (Real GSM Dial)
    public func dialRealGSMNumber(_ numberString: String) {
        let cleanNumber = numberString.components(separatedBy: CharacterSet(charactersIn: "+0123456789*#").inverted).joined()
        guard !cleanNumber.isEmpty else { return }
        
        // Wywołanie systemowego wybierania numeru iOS (telprompt:// lub tel://)
        if let url = URL(string: "telprompt://\(cleanNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if let url = URL(string: "tel://\(cleanNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Call Flow Management
    public func startCall(number: String? = nil, contactName: String? = nil) {
        let targetNumber = number ?? (rawDigits.isEmpty ? "+48 501 234 567" : formattedDigits)
        guard !targetNumber.isEmpty else { return }
        
        HapticsManager.shared.callStart()
        
        // Wykonanie PRAWDZIWEGO połączenia telefonicznego przez sieć GSM na iPhone
        if realGSMCalling {
            dialRealGSMNumber(targetNumber)
        }
        
        // Znalezienie nazwy kontaktu
        var matchedName = contactName
        if matchedName == nil {
            let cleanTarget = targetNumber.replacingOccurrences(of: " ", with: "")
            if let matched = contacts.first(where: { $0.phoneNumber.replacingOccurrences(of: " ", with: "") == cleanTarget }) {
                matchedName = matched.name
            }
        }
        
        // Inicjalizacja sesji połączenia
        let session = ActiveCallSession(
            contactName: matchedName,
            phoneNumber: targetNumber,
            status: .connecting
        )
        
        self.activeCall = session
        self.isCallScreenPresented = true
        
        // Zapis rekordu do historii
        let record = CallRecord(
            contactName: session.contactName,
            phoneNumber: session.phoneNumber,
            direction: .outgoing,
            date: Date(),
            durationSeconds: 0,
            isEncrypted: true
        )
        recents.insert(record, at: 0)
        
        // Symulacja aktywacji sesji
        connectionTimer?.cancel()
        connectionTimer = Timer.publish(every: 1.0, on: .main, in: .common)
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
        
        activeCall?.status = .ended
        
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
            )
        ]
    }
}
