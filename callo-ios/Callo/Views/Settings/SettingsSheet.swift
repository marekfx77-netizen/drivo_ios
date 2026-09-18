import SwiftUI

public struct SettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("realGSMCalling") private var realGSMCalling: Bool = true
    @AppStorage("silenceUnknownCallers") private var silenceUnknown: Bool = true
    @AppStorage("hdVoiceEnabled") private var hdVoice: Bool = true
    @AppStorage("hapticFeedback") private var hapticFeedback: Bool = true
    @AppStorage("selectedRingtone") private var selectedRingtone: String = "Neon Pulse"
    
    @State private var blockedNumbers: [String] = ["+48 22 123 99 00", "+48 71 888 00 11"]
    
    let ringtones = ["Neon Pulse", "Cosmic Bell", "Minimal Glass", "Obsidian Glow", "Classic iPhone"]
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bgDeep.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - Połączenia i Prywatność
                        VStack(alignment: .leading, spacing: 10) {
                            sectionHeader("POŁĄCZENIA I BEZPIECZEŃSTWO")
                            
                            VStack(spacing: 14) {
                                Toggle(isOn: $realGSMCalling) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Rzeczywiste połączenia GSM")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(AppTheme.textPrimary)
                                        Text("Wybiera prawdziwy numer przez sieć komórkową iPhone'a")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppTheme.callGreen)
                                    }
                                }
                                .tint(AppTheme.callGreen)
                                
                                Divider().background(Color.white.opacity(0.08))
                                
                                Toggle(isOn: $silenceUnknown) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Wyciszaj nieznane numery")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(AppTheme.textPrimary)
                                        Text("Połączenia od nieznanych numerów trafią bezpośrednio do poczty")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                }
                                .tint(AppTheme.neonPurple)
                                
                                Divider().background(Color.white.opacity(0.08))
                                
                                Toggle(isOn: $hdVoice) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Jakość dźwięku HD Voice+")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(AppTheme.textPrimary)
                                        Text("Adaptacyjny kodek Opus z 256-bitowym szyfrowaniem")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                }
                                .tint(AppTheme.callGreen)
                                
                                Divider().background(Color.white.opacity(0.08))
                                
                                Toggle(isOn: $hapticFeedback) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Haptyka Taptic Engine")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(AppTheme.textPrimary)
                                        Text("Wibracje klawiszy przy wpisywaniu numeru")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                }
                                .tint(AppTheme.neonPurple)
                            }
                            .padding(16)
                            .background(AppTheme.bgSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppTheme.borderGlass, lineWidth: 1))
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Dzwonek
                        VStack(alignment: .leading, spacing: 10) {
                            sectionHeader("DŹWIĘK DZWONKA")
                            
                            VStack(spacing: 8) {
                                ForEach(ringtones, id: \.self) { ringtone in
                                    Button(action: {
                                        HapticsManager.shared.selectionChanged()
                                        selectedRingtone = ringtone
                                    }) {
                                        HStack {
                                            Text(ringtone)
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(AppTheme.textPrimary)
                                            
                                            Spacer()
                                            
                                            if selectedRingtone == ringtone {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(AppTheme.neonPurple)
                                            }
                                        }
                                        .padding(.vertical, 8)
                                    }
                                    
                                    if ringtone != ringtones.last {
                                        Divider().background(Color.white.opacity(0.06))
                                    }
                                }
                            }
                            .padding(16)
                            .background(AppTheme.bgSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppTheme.borderGlass, lineWidth: 1))
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Zablokowane kontakty
                        VStack(alignment: .leading, spacing: 10) {
                            sectionHeader("ZABLOKOWANE NUMERY (\(blockedNumbers.count))")
                            
                            VStack(spacing: 12) {
                                ForEach(blockedNumbers, id: \.self) { num in
                                    HStack {
                                        Text(num)
                                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                                            .foregroundColor(AppTheme.textSecondary)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            HapticsManager.shared.deleteKey()
                                            blockedNumbers.removeAll { $0 == num }
                                        }) {
                                            Text("Odblokuj")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(AppTheme.endCallRed)
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 10)
                                                .background(AppTheme.endCallRed.opacity(0.12))
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            .background(AppTheme.bgSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppTheme.borderGlass, lineWidth: 1))
                        }
                        .padding(.horizontal, 20)
                        
                        // Footer
                        VStack(spacing: 4) {
                            Text("Callo Dialer v1.0 (Build 1)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppTheme.textTertiary)
                            Text("Szyfrowanie end-to-end aktywne")
                                .font(.system(size: 11))
                                .foregroundColor(AppTheme.callGreen)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Ustawienia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gotowe") { dismiss() }
                        .foregroundColor(AppTheme.neonPurple)
                }
            }
        }
    }
    
    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 11, weight: .bold))
            .tracking(1.2)
            .foregroundColor(AppTheme.textSecondary)
            .padding(.leading, 4)
    }
}
