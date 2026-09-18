import SwiftUI

public enum AppTab: Int, CaseIterable {
    case keypad = 0
    case recents = 1
    case contacts = 2
    case voicemail = 3
    
    public var title: String {
        switch self {
        case .keypad: return "Klawiatura"
        case .recents: return "Ostatnie"
        case .contacts: return "Kontakty"
        case .voicemail: return "Poczta"
        }
    }
    
    public var icon: String {
        switch self {
        case .keypad: return "circle.grid.3x3.fill"
        case .recents: return "clock.fill"
        case .contacts: return "person.2.fill"
        case .voicemail: return "recordingtape"
        }
    }
}

public struct ContentView: View {
    @StateObject private var state = DialerStateManager()
    @State private var currentTab: AppTab = .keypad
    @State private var isSettingsPresented: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: - Main Tab Content
            Group {
                switch currentTab {
                case .keypad:
                    KeypadView(state: state)
                case .recents:
                    RecentsView(state: state)
                case .contacts:
                    ContactsView(state: state)
                case .voicemail:
                    VoicemailView(state: state)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // MARK: - Top Floating Settings Button (when on keypad)
            if currentTab == .keypad {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            HapticsManager.shared.selectionChanged()
                            isSettingsPresented = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.06))
                                    .frame(width: 40, height: 40)
                                    .overlay(Circle().stroke(AppTheme.borderGlass, lineWidth: 1))
                                
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 17))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 8)
                    }
                    Spacer()
                }
            }
            
            // MARK: - Floating Glass Tab Bar Dock
            floatingTabBar
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
        }
        .preferredColorScheme(.dark)
        // Ekran aktywnego połączenia w trybie pełnoekranowym
        .fullScreenCover(isPresented: $state.isCallScreenPresented) {
            InCallView(state: state)
        }
        .sheet(isPresented: $isSettingsPresented) {
            SettingsSheet()
        }
    }
    
    // MARK: - Floating Dock Tab Bar View
    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                let isSelected = currentTab == tab
                
                Button(action: {
                    HapticsManager.shared.selectionChanged()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        currentTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            if isSelected {
                                Circle()
                                    .fill(AppTheme.neonPurple.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            Image(systemName: tab.icon)
                                .font(.system(size: 19, weight: isSelected ? .bold : .medium))
                                .foregroundColor(isSelected ? AppTheme.neonPurple : AppTheme.textSecondary)
                        }
                        .frame(height: 32)
                        
                        Text(tab.title)
                            .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                            .foregroundColor(isSelected ? .white : AppTheme.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color(hex: 0x12121C).opacity(0.85))
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.04)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
    }
}
