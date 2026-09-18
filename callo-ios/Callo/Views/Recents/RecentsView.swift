import SwiftUI

public struct RecentsView: View {
    @ObservedObject var state: DialerStateManager
    @State private var selectedFilter: Int = 0 // 0: Wszystkie, 1: Nieodebrane
    
    public init(state: DialerStateManager) {
        self.state = state
    }
    
    private var filteredRecents: [CallRecord] {
        if selectedFilter == 1 {
            return state.recents.filter { $0.direction == .missed }
        }
        return state.recents
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bgDeep.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // MARK: - Custom Segmented Control
                    HStack(spacing: 6) {
                        filterTabButton(title: "Wszystkie", index: 0)
                        filterTabButton(title: "Nieodebrane", index: 1)
                    }
                    .padding(4)
                    .background(AppTheme.bgSurface)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(AppTheme.borderGlass, lineWidth: 1))
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // MARK: - List of Calls
                    if filteredRecents.isEmpty {
                        VStack(spacing: 14) {
                            Spacer()
                            Image(systemName: selectedFilter == 1 ? "phone.down.circle" : "clock")
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(AppTheme.textTertiary)
                            
                            Text(selectedFilter == 1 ? "Brak nieodebranych połączeń" : "Brak historii połączeń")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(filteredRecents) { record in
                                    RecentCallRow(record: record) {
                                        state.startCall(number: record.phoneNumber, contactName: record.contactName)
                                    }
                                    .contextMenu {
                                        Button {
                                            state.startCall(number: record.phoneNumber, contactName: record.contactName)
                                        } label: {
                                            Label("Zadzwoń", systemImage: "phone.fill")
                                        }
                                        
                                        Button(role: .destructive) {
                                            withAnimation {
                                                state.recents.removeAll(where: { $0.id == record.id })
                                            }
                                        } label: {
                                            Label("Usuń z historii", systemImage: "trash.fill")
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 6)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationTitle("Ostatnie")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !state.recents.isEmpty {
                        Button("Wyczyść") {
                            withAnimation {
                                if selectedFilter == 1 {
                                    state.recents.removeAll(where: { $0.direction == .missed })
                                } else {
                                    state.recents.removeAll()
                                }
                            }
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.endCallRed)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func filterTabButton(title: String, index: Int) -> some View {
        Button(action: {
            HapticsManager.shared.selectionChanged()
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                selectedFilter = index
            }
        }) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(selectedFilter == index ? .white : AppTheme.textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 34)
                .background(
                    selectedFilter == index ?
                        (index == 1 ? AppTheme.endCallRed.opacity(0.85) : AppTheme.neonPurple.opacity(0.85)) :
                        Color.clear
                )
                .clipShape(Capsule())
        }
    }
}
