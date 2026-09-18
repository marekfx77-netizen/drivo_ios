import SwiftUI
import Combine

// MARK: - Soundwave Manager (Voice Equalizer Simulation)
public final class SoundwaveManager: ObservableObject {
    @Published public var amplitudes: [CGFloat] = Array(repeating: 0.15, count: 9)
    @Published public var isSpeaking: Bool = false
    
    private var timer: AnyCancellable?
    private var step: Double = 0
    
    public init() {
        // Inicjalnie zbalansowane słupki
        self.amplitudes = [0.2, 0.35, 0.6, 0.85, 1.0, 0.85, 0.6, 0.35, 0.2]
    }
    
    public func startVisualizer() {
        stopVisualizer()
        isSpeaking = true
        
        // 30 FPS odświeżanie fali imitujące mowę ludzką z harmonicznymi
        timer = Timer.publish(every: 0.04, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.step += 0.2
                
                // Generowanie płynnej, organicznej fali głosu
                let baseAmplitudes: [CGFloat] = (0..<9).map { index in
                    let offset = Double(index) * 0.45
                    let primarySine = sin(self.step + offset)
                    let secondarySine = sin(self.step * 1.7 - offset)
                    let randomNoise = Double.random(in: -0.15...0.15)
                    
                    // Środkowe słupki mają wyższą dynamikę niż skrajne
                    let centerWeight = 1.0 - (abs(Double(index) - 4.0) / 5.0)
                    let rawVal = (primarySine * 0.4 + secondarySine * 0.3 + 0.5 + randomNoise) * centerWeight
                    
                    // Ograniczenie i normalizacja w zakresie 0.15 - 1.0
                    return CGFloat(max(0.12, min(1.0, rawVal)))
                }
                
                withAnimation(.spring(response: 0.15, dampingFraction: 0.65)) {
                    self.amplitudes = baseAmplitudes
                }
            }
    }
    
    public func stopVisualizer() {
        timer?.cancel()
        timer = nil
        isSpeaking = false
        withAnimation(.easeOut(duration: 0.3)) {
            self.amplitudes = Array(repeating: 0.08, count: 9)
        }
    }
}
