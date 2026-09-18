import SwiftUI

public struct InCallView: View {
    @ObservedObject var state: DialerStateManager
    @State private var isAudioRoutePresented: Bool = false
    @State private var isDTMFKeypadPresented: Bool = false
    @State private var pulseRing: Bool = false
    
    public init(state: DialerStateManager) {
        self.state = state
    }
    
    private var session: ActiveCallSession {
        state.activeCall ?? ActiveCallSession(phoneNumber: "Nieznany", status: .connecting)
    }
    
    public var body: some View {
        ZStack {
            // Tło Ultra-Dark z delikatnym ambient glow
            AppTheme.bgDeep.ignoresSafeArea()
            
            RadialGradient(
                colors: [
                    AppTheme.neonPurple.opacity(0.18),
                    Color.clear
                ],
                center: .top,
                startRadius: 40,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // MARK: - Top Security & Quality Badge
                HStack(spacing: 8) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.callGreen)
                    
                    Text("HD VOICE • 256-BIT SZYFROWANIE")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(1.2)
                        .foregroundColor(AppTheme.textSecondary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.06))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.1), lineWidth: 0.8))
                .padding(.top, 24)
                
                Spacer()
                
                // MARK: - Caller Avatar with Pulsing Ring
                ZStack {
                    // Pulsujący ring
                    Circle()
                        .stroke(AppTheme.avatarRingGradient, lineWidth: 3)
                        .frame(width: 140, height: 140)
                        .scaleEffect(pulseRing ? 1.08 : 0.98)
                        .opacity(pulseRing ? 0.85 : 0.4)
                        .animation(
                            .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: pulseRing
                        )
                    
                    // Awatar bazowy
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: 0x1A1A28), Color(hex: 0x0E0E18)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 124, height: 124)
                        .overlay(
                            Text(session.contactName?.prefix(2).uppercased() ?? "HD")
                                .font(.system(size: 42, weight: .light, design: .rounded))
                                .foregroundColor(.white)
                        )
                        .shadow(color: AppTheme.neonPurple.opacity(0.35), radius: 20, x: 0, y: 10)
                }
                .onAppear {
                    pulseRing = true
                }
                
                // MARK: - Caller Info & Status
                VStack(spacing: 8) {
                    Text(session.contactName ?? session.phoneNumber)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.textPrimary)
                        .lineLimit(1)
                    
                    if session.contactName != nil {
                        Text(session.phoneNumber)
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    Text(session.status == .connected ? session.formattedDuration : session.status.rawValue)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(session.status == .connected ? AppTheme.callGreen : AppTheme.textSecondary)
                        .padding(.top, 2)
                }
                
                // MARK: - Animated Soundwave Visualizer
                if session.status == .connected && !session.isOnHold {
                    SoundwaveVisualizer(soundwave: state.soundwave)
                        .padding(.top, 4)
                        .transition(.opacity.combined(with: .scale))
                } else {
                    Color.clear
                        .frame(height: 44)
                }
                
                Spacer()
                
                // MARK: - 6 In-Call Action Buttons Grid
                VStack(spacing: 20) {
                    HStack(spacing: 32) {
                        InCallActionButton(
                            icon: session.isMuted ? "mic.slash.fill" : "mic.fill",
                            label: session.isMuted ? "Wyciszony" : "Wycisz",
                            isActive: session.isMuted,
                            activeColor: AppTheme.endCallRed
                        ) {
                            state.toggleMute()
                        }
                        
                        InCallActionButton(
                            icon: "circle.grid.3x3.fill",
                            label: "Klawiatura",
                            isActive: isDTMFKeypadPresented
                        ) {
                            isDTMFKeypadPresented = true
                        }
                        
                        InCallActionButton(
                            icon: session.audioRoute.iconName,
                            label: session.audioRoute.rawValue,
                            isActive: session.audioRoute != .iphone,
                            activeColor: AppTheme.callGreen
                        ) {
                            isAudioRoutePresented = true
                        }
                    }
                    
                    HStack(spacing: 32) {
                        InCallActionButton(
                            icon: "person.badge.plus",
                            label: "Dodaj",
                            isActive: false
                        ) {
                            HapticsManager.shared.selectionChanged()
                        }
                        
                        InCallActionButton(
                            icon: session.isVideoEnabled ? "video.fill" : "video.slash.fill",
                            label: "Wideo",
                            isActive: session.isVideoEnabled,
                            activeColor: AppTheme.neonPurple
                        ) {
                            state.toggleVideo()
                        }
                        
                        InCallActionButton(
                            icon: session.isOnHold ? "play.fill" : "pause.fill",
                            label: session.isOnHold ? "Wznów" : "Wstrzymaj",
                            isActive: session.isOnHold,
                            activeColor: AppTheme.warningYellow
                        ) {
                            state.toggleHold()
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // MARK: - End Call Button
                Button(action: {
                    state.endCall()
                }) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.endCallGradient)
                            .shadow(color: AppTheme.endCallRed.opacity(0.55), radius: 20, x: 0, y: 8)
                        
                        Image(systemName: "phone.down.fill")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 78, height: 78)
                }
                .padding(.bottom, 48)
            }
        }
        .sheet(isPresented: $isAudioRoutePresented) {
            AudioRoutePickerSheet(state: state)
        }
        .sheet(isPresented: $isDTMFKeypadPresented) {
            DTMFKeypadSheet()
        }
    }
}

// MARK: - Przycisk funkcyjny w trakcie rozmowy
public struct InCallActionButton: View {
    let icon: String
    let label: String
    let isActive: Bool
    var activeColor: Color = AppTheme.textPrimary
    let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isActive ? activeColor.opacity(0.25) : Color.white.opacity(0.08))
                        .overlay(
                            Circle()
                                .stroke(isActive ? activeColor.opacity(0.6) : Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(isActive ? activeColor : AppTheme.textPrimary)
                }
                .frame(width: 68, height: 68)
                
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isActive ? activeColor : AppTheme.textSecondary)
                    .lineLimit(1)
            }
            .frame(width: 80)
        }
    }
}

// MARK: - Arkusz klawiatury tonowej DTMF w trakcie rozmowy
private struct DTMFKeypadSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var pressedDigits: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bgDeep.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text(pressedDigits.isEmpty ? "Wybierz cyfry tonowe" : pressedDigits)
                        .font(.system(size: 26, weight: .medium, design: .monospaced))
                        .foregroundColor(AppTheme.textPrimary)
                        .frame(height: 40)
                        .padding(.top, 10)
                    
                    VStack(spacing: 12) {
                        ForEach([["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"], ["*", "0", "#"]], id: \.self) { row in
                            HStack(spacing: 20) {
                                ForEach(row, id: \.self) { key in
                                    Button(action: {
                                        HapticsManager.shared.keyPress()
                                        pressedDigits.append(key)
                                    }) {
                                        Text(key)
                                            .font(.system(size: 26, weight: .light, design: .rounded))
                                            .foregroundColor(.white)
                                            .frame(width: 72, height: 72)
                                            .background(Color.white.opacity(0.08))
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("Klawiatura numeryczna")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gotowe") { dismiss() }
                        .foregroundColor(AppTheme.neonPurple)
                }
            }
        }
    }
}
