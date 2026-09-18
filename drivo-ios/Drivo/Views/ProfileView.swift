import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var state: AppState
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack { LinearGradient(colors: [DrivoTheme.accent, Color(hex: "5B8DEF")], startPoint: .topLeading, endPoint: .bottomTrailing); Text("MS").font(.system(size: 26, weight: .heavy)).foregroundColor(.white) }
                .frame(width: 68, height: 68).clipShape(Circle()).overlay(Circle().stroke(DrivoTheme.accent, lineWidth: 2))
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mikolaj Stankowski").font(.system(size: 22, weight: .heavy)).foregroundColor(.white)
                    Text("m.stankowski@email.com").font(.system(size: 13)).foregroundColor(DrivoTheme.muted)
                    HStack(spacing: 3) { Image(systemName: "star.fill").font(.system(size: 11)).foregroundColor(Color(hex: "FFD700")); Text("4.95").font(.system(size: 13, weight: .bold)).foregroundColor(.white); Text("Twoja ocena").font(.system(size: 11)).foregroundColor(DrivoTheme.muted) }
                }
                Spacer()
            }.padding(.horizontal, 18).padding(.top, 64).padding(.bottom, 20).background(DrivoTheme.card)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    HStack(spacing: 10) { PStatC(value: "47", label: "Przejazdy"); PStatC(value: "312 km", label: "Dystans"); PStatC(value: "248 zl", label: "Wydano") }
                    VStack(spacing: 0) {
                        PRow(icon: "creditcard.fill", color: "7C5CFC", title: "Metody platnosci", sub: "Gotowka, Apple Pay")
                        Divider().background(DrivoTheme.border).padding(.leading, 62)
                        PRow(icon: "house.fill", color: "00D68F", title: "Adres domowy", sub: "Dodaj adres")
                        Divider().background(DrivoTheme.border).padding(.leading, 62)
                        PRow(icon: "briefcase.fill", color: "5B8DEF", title: "Adres pracy", sub: "Dodaj adres")
                    }.background(DrivoTheme.card2).overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.border, lineWidth: 1)).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    VStack(spacing: 0) {
                        PRow(icon: "chart.bar.fill", color: "FFB020", title: "Aktywnosc", sub: nil)
                        Divider().background(DrivoTheme.border).padding(.leading, 62)
                        PRow(icon: "heart.fill", color: "FF4757", title: "Bezpieczenstwo", sub: nil)
                        Divider().background(DrivoTheme.border).padding(.leading, 62)
                        PRow(icon: "bell.fill", color: "7C5CFC", title: "Powiadomienia", sub: nil)
                    }.background(DrivoTheme.card2).overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.border, lineWidth: 1)).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    VStack(spacing: 0) {
                        PRow(icon: "questionmark.circle.fill", color: "AAAAAA", title: "Pomoc", sub: nil)
                        Divider().background(DrivoTheme.border).padding(.leading, 62)
                        Button { state.screen = .splash } label: {
                            HStack(spacing: 12) {
                                ZStack { Color(hex: "FF4757").opacity(0.1); Image(systemName: "rectangle.portrait.and.arrow.right").font(.system(size: 16)).foregroundColor(Color(hex: "FF4757")) }
                                .frame(width: 36, height: 36).clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                Text("Wyloguj").font(.system(size: 15, weight: .medium)).foregroundColor(Color(hex: "FF4757"))
                                Spacer()
                            }.padding(14)
                        }.buttonStyle(.plain)
                    }.background(DrivoTheme.card2).overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.border, lineWidth: 1)).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }.padding(.horizontal, 18).padding(.vertical, 14).padding(.bottom, 80)
            }.background(DrivoTheme.bg)
            BottomNavView(selectedTab: .constant(3)).environmentObject(state)
        }.background(DrivoTheme.bg).ignoresSafeArea(edges: .top)
    }
}
struct PStatC: View {
    let value: String; let label: String
    var body: some View {
        VStack(spacing: 2) { Text(value).font(.system(size: 20, weight: .heavy)).foregroundColor(.white); Text(label).font(.system(size: 11)).foregroundColor(DrivoTheme.muted) }
        .frame(maxWidth: .infinity).padding(.vertical, 14).background(DrivoTheme.card2)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.border, lineWidth: 1)).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
struct PRow: View {
    let icon: String; let color: String; let title: String; let sub: String?
    var body: some View {
        HStack(spacing: 12) {
            ZStack { Color(hex: color).opacity(0.12); Image(systemName: icon).font(.system(size: 16)).foregroundColor(Color(hex: color)) }
            .frame(width: 36, height: 36).clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                if let s = sub { Text(s).font(.system(size: 11)).foregroundColor(DrivoTheme.muted) }
            }
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold)).foregroundColor(Color.white.opacity(0.3))
        }.padding(14)
    }
}