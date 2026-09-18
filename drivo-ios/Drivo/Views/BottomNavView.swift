import SwiftUI

struct BottomNavView: View {
    @EnvironmentObject var state: AppState
    @Binding var selectedTab: Int
    let items: [(icon: String, label: String, screen: AppScreen)] = [
        ("house.fill", "Glowna", .home),
        ("magnifyingglass", "Szukaj", .search),
        ("waveform.path.ecg", "Historia", .history),
        ("person.fill", "Profil", .profile),
    ]
    var body: some View {
        VStack(spacing: 0) {
            Divider().background(Color.white.opacity(0.08))
            HStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { i in
                    let item = items[i]
                    let active = selectedTab == i
                    Button { state.screen = item.screen } label: {
                        VStack(spacing: 4) {
                            Image(systemName: item.icon)
                                .font(.system(size: 22, weight: active ? .semibold : .regular))
                                .foregroundColor(active ? Color(hex: "9B7BFF") : Color.white.opacity(0.4))
                            Text(item.label)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(active ? Color(hex: "9B7BFF") : Color.white.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity).padding(.top, 10).padding(.bottom, 24)
                    }.buttonStyle(.plain)
                }
            }
            .background(Color(hex: "101020").opacity(0.95).ignoresSafeArea(edges: .bottom))
        }
    }
}
