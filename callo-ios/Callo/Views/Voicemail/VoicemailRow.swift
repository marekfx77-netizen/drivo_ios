import SwiftUI

public struct VoicemailRow: View {
    public let item: VoicemailItem
    public let onCall: () -> Void
    public let onDelete: () -> Void
    
    @State private var isExpanded: Bool = false
    @State private var isPlaying: Bool = false
    @State private var playbackProgress: Double = 0.0
    @State private var playbackTimer: Timer?
    
    public init(item: VoicemailItem, onCall: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self.item = item
        self.onCall = onCall
        self.onDelete = onDelete
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Header
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(item.isRead ? Color.clear : AppTheme.neonPurple)
                        .frame(width: 8, height: 8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.displayName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppTheme.textPrimary)
                        
                        Text(item.phoneNumber)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(item.formattedDuration)
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppTheme.textTertiary)
                    }
                }
            }
            .buttonStyle(.plain)
            
            // MARK: - Expanded Content (Audio Player & AI Transcript)
            if isExpanded {
                VStack(alignment: .leading, spacing: 14) {
                    Divider().background(Color.white.opacity(0.08))
                    
                    // AI Transcript Box
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(AppTheme.neonPurple)
                            Text("TRANSKRYPCJA AI")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .tracking(1)
                                .foregroundColor(AppTheme.neonPurple)
                        }
                        
                        Text(item.transcript)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(AppTheme.textPrimary.opacity(0.9))
                            .lineSpacing(3)
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.neonPurple.opacity(0.2), lineWidth: 1))
                    
                    // Audio Playback Bar
                    HStack(spacing: 14) {
                        Button(action: togglePlay) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.neonPurple)
                                    .frame(width: 40, height: 40)
                                    .shadow(color: AppTheme.neonPurple.opacity(0.4), radius: 6, y: 2)
                                
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Waveform progress
                        VStack(spacing: 4) {
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.12))
                                        .frame(height: 6)
                                    
                                    Capsule()
                                        .fill(AppTheme.primaryGradient)
                                        .frame(width: geo.size.width * playbackProgress, height: 6)
                                }
                            }
                            .frame(height: 6)
                            
                            HStack {
                                Text(String(format: "00:%02d", Int(Double(item.durationSeconds) * playbackProgress)))
                                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                                    .foregroundColor(AppTheme.textTertiary)
                                Spacer()
                                Text(item.formattedDuration)
                                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                                    .foregroundColor(AppTheme.textTertiary)
                            }
                        }
                    }
                    
                    // Actions (Call & Delete)
                    HStack(spacing: 12) {
                        Button(action: onCall) {
                            HStack(spacing: 6) {
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 12, weight: .semibold))
                                Text("Oddzwoń")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(AppTheme.callGreen)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(AppTheme.callGreen.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.endCallRed.opacity(0.8))
                                .padding(8)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(AppTheme.bgSurface)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppTheme.borderGlass, lineWidth: 1))
    }
    
    private func togglePlay() {
        HapticsManager.shared.toggleControl()
        isPlaying.toggle()
        if isPlaying {
            playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if playbackProgress < 1.0 {
                    playbackProgress += 0.1 / Double(item.durationSeconds)
                } else {
                    isPlaying = false
                    playbackProgress = 0.0
                    playbackTimer?.invalidate()
                }
            }
        } else {
            playbackTimer?.invalidate()
        }
    }
}
