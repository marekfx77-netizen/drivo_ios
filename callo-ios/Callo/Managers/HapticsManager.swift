import UIKit

// MARK: - Haptics Manager (Taptic Engine)
public final class HapticsManager {
    public static let shared = HapticsManager()
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let rigidImpact = UIImpactFeedbackGenerator(style: .rigid)
    private let softImpact = UIImpactFeedbackGenerator(style: .soft)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()

    private init() {
        prepare()
    }

    public func prepare() {
        lightImpact.prepare()
        rigidImpact.prepare()
        mediumImpact.prepare()
    }

    /// Kliknięcie klawisza numerycznego na klawiaturze (sprężysty, precyzyjny taptic)
    public func keyPress() {
        rigidImpact.impactOccurred(intensity: 0.85)
    }

    /// Kliknięcie przycisku nawiązania połączenia (mocniejszy akcent)
    public func callStart() {
        mediumImpact.impactOccurred(intensity: 1.0)
    }

    /// Zakończenie połączenia
    public func callEnd() {
        heavyImpact.impactOccurred(intensity: 0.9)
    }

    /// Powiadomienie o sukcesie (np. dodanie kontaktu)
    public func success() {
        notificationGenerator.notificationOccurred(.success)
    }

    /// Powiadomienie o błędzie / usunięcie cyfry
    public func deleteKey() {
        lightImpact.impactOccurred(intensity: 0.6)
    }

    /// Przełączenie opcji w ustawieniach lub zakładki
    public func selectionChanged() {
        selectionGenerator.selectionChanged()
    }

    /// Zmiana stanu przełącznika (Mute, Głośnik)
    public func toggleControl() {
        softImpact.impactOccurred(intensity: 0.9)
    }
}
