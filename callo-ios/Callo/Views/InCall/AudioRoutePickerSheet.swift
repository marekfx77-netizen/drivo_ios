import SwiftUI

public struct AudioRoutePickerSheet: View {
    @ObservedObject var state: DialerStateManager
    @Environment(\.dismiss) private var dismiss
    
    public init(state: DialerStateManager) {
        self.state = state
    }
    
    public var body: some View {
        ZStack {
            AppTheme.bgSurface.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Źródło dźwięku")
                        .font(.headline)
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Button("Gotowe") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.neonPurple)
                    .font(.subheadline.bold())
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)
                
                // Audio routes list
                VStack(spacing: 12) {
                    ForEach(AudioRoute.allCases, id: \.self) { route in
                        Button(action: {
                            state.setAudioRoute(route)
                            dismiss()
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: route.iconName)
                                    .font(.system(size: 20))
                                    .frame(width: 28)
                                    .foregroundColor(state.activeCall?.audioRoute == route ? AppTheme.callGreen : AppTheme.textSecondary)
                                
                                Text(route.rawValue)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppTheme.textPrimary)
                                
                                Spacer()
                                
                                if state.activeCall?.audioRoute == route {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(AppTheme.callGreen)
                                }
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 58)
                            .background(Color.white.opacity(state.activeCall?.audioRoute == route ? 0.08 : 0.03))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(state.activeCall?.audioRoute == route ? AppTheme.callGreen.opacity(0.3) : Color.white.opacity(0.06), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .presentationDetents([.height(280)])
        .presentationDragIndicator(.visible)
    }
}
