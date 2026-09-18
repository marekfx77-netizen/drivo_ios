import SwiftUI

public struct VoicemailView: View {
    @ObservedObject var state: DialerStateManager
    
    public init(state: DialerStateManager) {
        self.state = state
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bgDeep.ignoresSafeArea()
                
                if state.voicemails.isEmpty {
                    VStack(spacing: 14) {
                        Image(systemName: "recordingtape")
                            .font(.system(size: 48, weight: .light))
                            .foregroundColor(AppTheme.textTertiary)
                        
                        Text("Brak wiadomości poczty głosowej")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(state.voicemails) { item in
                                VoicemailRow(
                                    item: item,
                                    onCall: {
                                        state.startCall(number: item.phoneNumber, contactName: item.callerName)
                                    },
                                    onDelete: {
                                        withAnimation {
                                            state.voicemails.removeAll(where: { $0.id == item.id })
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Poczta głosowa")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        HapticsManager.shared.selectionChanged()
                    }) {
                        Text("Powitanie")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppTheme.neonPurple)
                    }
                }
            }
        }
    }
}
