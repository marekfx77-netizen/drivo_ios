import SwiftUI

enum ProfileActiveSheet: Identifiable {
    case payments
    case homeAddress
    case workAddress
    case activity
    case safety
    case notifications
    case help

    var id: Int { hashValue }
}

struct ProfileView: View {
    @EnvironmentObject var state: AppState

    @State private var activeSheet: ProfileActiveSheet? = nil
    @State private var showLogoutAlert = false

    var body: some View {
        VStack(spacing: 0) {
            // PROFILE HERO HEADER
            HStack(spacing: 16) {
                ZStack {
                    LinearGradient(
                        colors: [DrivoTheme.gradientA, DrivoTheme.gradientB],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    Text("MS")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.white)
                }
                .frame(width: 68, height: 68)
                .clipShape(Circle())
                .overlay(Circle().stroke(DrivoTheme.accent, lineWidth: 2))
                .shadow(color: DrivoTheme.accent.opacity(0.35), radius: 10, y: 4)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Mikołaj Stankowski")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.white)

                    Text("m.stankowski@email.com")
                        .font(.system(size: 12))
                        .foregroundColor(DrivoTheme.muted)

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundColor(DrivoTheme.amber)
                        Text("4.95")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                        Text("• Ocena pasażera")
                            .font(.system(size: 11))
                            .foregroundColor(DrivoTheme.muted)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 56)
            .padding(.bottom, 16)
            .background(DrivoTheme.card)

            // SCROLLABLE SETTINGS CONTENT
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Quick Stats Row
                    HStack(spacing: 10) {
                        ProfileStatCard(number: "47", label: "Przejazdy")
                        ProfileStatCard(number: "312", label: "Kilometry")
                        ProfileStatCard(number: "248 zł", label: "Wydano")
                    }

                    // GROUP 1: PLACES & PAYMENTS
                    VStack(spacing: 0) {
                        SettingsNavRow(
                            icon: "creditcard.fill",
                            color: DrivoTheme.accent,
                            title: "Metody płatności",
                            subtitle: state.paymentMethod
                        ) {
                            HapticsManager.shared.impact(.light)
                            activeSheet = .payments
                        }

                        Divider().background(DrivoTheme.border).padding(.leading, 60)

                        SettingsNavRow(
                            icon: "house.fill",
                            color: DrivoTheme.green,
                            title: "Adres domowy",
                            subtitle: state.homeAddress
                        ) {
                            HapticsManager.shared.impact(.light)
                            activeSheet = .homeAddress
                        }

                        Divider().background(DrivoTheme.border).padding(.leading, 60)

                        SettingsNavRow(
                            icon: "briefcase.fill",
                            color: Color(hex: "4F75FF"),
                            title: "Adres pracy",
                            subtitle: state.workAddress
                        ) {
                            HapticsManager.shared.impact(.light)
                            activeSheet = .workAddress
                        }
                    }
                    .background(DrivoTheme.card2)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(DrivoTheme.border, lineWidth: 1))

                    // GROUP 2: PREFERENCES & SECURITY
                    VStack(spacing: 0) {
                        SettingsNavRow(
                            icon: "chart.bar.fill",
                            color: DrivoTheme.amber,
                            title: "Podsumowanie aktywności",
                            subtitle: "Wgląd w historię i statystyki"
                        ) {
                            HapticsManager.shared.impact(.light)
                            activeSheet = .activity
                        }

                        Divider().background(DrivoTheme.border).padding(.leading, 60)

                        SettingsNavRow(
                            icon: "shield.checkerboard",
                            color: DrivoTheme.red,
                            title: "Bezpieczeństwo konta",
                            subtitle: "PIN przejazdu, zaufane kontakty"
                        ) {
                            HapticsManager.shared.impact(.light)
                            activeSheet = .safety
                        }

                        Divider().background(DrivoTheme.border).padding(.leading, 60)

                        SettingsNavRow(
                            icon: "bell.fill",
                            color: DrivoTheme.accent2,
                            title: "Powiadomienia",
                            subtitle: "Zarządzaj powiadomieniami SMS i push"
                        ) {
                            HapticsManager.shared.impact(.light)
                            activeSheet = .notifications
                        }
                    }
                    .background(DrivoTheme.card2)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(DrivoTheme.border, lineWidth: 1))

                    // GROUP 3: SUPPORT & LOGOUT
                    VStack(spacing: 0) {
                        SettingsNavRow(
                            icon: "questionmark.circle.fill",
                            color: Color.white.opacity(0.8),
                            title: "Pomoc i wsparcie",
                            subtitle: "Centrum pomocy i kontakt 24/7"
                        ) {
                            HapticsManager.shared.impact(.light)
                            activeSheet = .help
                        }

                        Divider().background(DrivoTheme.border).padding(.leading, 60)

                        Button {
                            HapticsManager.shared.impact(.medium)
                            showLogoutAlert = true
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    DrivoTheme.red.opacity(0.15)
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(DrivoTheme.red)
                                }
                                .frame(width: 36, height: 36)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                                Text("Wyloguj się")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(DrivoTheme.red)

                                Spacer()
                            }
                            .padding(14)
                        }
                    }
                    .background(DrivoTheme.card2)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(DrivoTheme.border, lineWidth: 1))
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .padding(.bottom, 90)
            }
            .background(DrivoTheme.bg)

            BottomNavView(selectedTab: .constant(3))
                .environmentObject(state)
        }
        .background(DrivoTheme.bg)
        .ignoresSafeArea(edges: .top)
        // LOGOUT ALERT
        .alert("Wylogowanie", isPresented: $showLogoutAlert) {
            Button("Wyloguj", role: .destructive) {
                HapticsManager.shared.notification(.warning)
                state.screen = .splash
            }
            Button("Anuluj", role: .cancel) {}
        } message: {
            Text("Czy na pewno chcesz się wylogować z konta Drivo?")
        }
        // SETTINGS SHEETS
        .sheet(item: $activeSheet) { item in
            switch item {
            case .payments:
                PaymentSheetView()
                    .environmentObject(state)
            case .homeAddress:
                AddressEditModal(title: "Edycja adresu domowego", address: $state.homeAddress)
            case .workAddress:
                AddressEditModal(title: "Edycja adresu pracy", address: $state.workAddress)
            case .activity:
                ActivityStatsModal()
            case .safety:
                SafetyModalView()
            case .notifications:
                NotificationSettingsModal()
                    .environmentObject(state)
            case .help:
                HelpModalView()
            }
        }
    }
}

// MARK: - Navigation Row Component
struct SettingsNavRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    color.opacity(0.15)
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(color)
                }
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    if let sub = subtitle {
                        Text(sub)
                            .font(.system(size: 12))
                            .foregroundColor(DrivoTheme.muted)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.white.opacity(0.3))
            }
            .padding(14)
        }
    }
}

// MARK: - Profile Stat Card
struct ProfileStatCard: View {
    let number: String
    let label: String

    var body: some View {
        VStack(spacing: 3) {
            Text(number)
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(DrivoTheme.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(DrivoTheme.card2)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.border, lineWidth: 1))
    }
}

// MARK: - Address Edit Modal
struct AddressEditModal: View {
    let title: String
    @Binding var address: String
    @Environment(\.dismiss) var dismiss
    @State private var input = ""

    var body: some View {
        VStack(spacing: 20) {
            Capsule().fill(Color.white.opacity(0.3)).frame(width: 36, height: 4).padding(.top, 12)
            Text(title).font(.system(size: 18, weight: .bold)).foregroundColor(.white)

            TextField("Wpisz nowy adres", text: $input)
                .font(.system(size: 15))
                .padding(14)
                .background(DrivoTheme.card2)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(DrivoTheme.border, lineWidth: 1))
                .foregroundColor(.white)
                .padding(.horizontal, 20)

            Button {
                HapticsManager.shared.notification(.success)
                if !input.trimmingCharacters(in: .whitespaces).isEmpty {
                    address = input
                }
                dismiss()
            } label: {
                Text("Zapisz adres")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(DrivoTheme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .onAppear { input = address }
        .background(DrivoTheme.bg.ignoresSafeArea())
    }
}

// MARK: - Notification Settings Modal
struct NotificationSettingsModal: View {
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Capsule().fill(Color.white.opacity(0.3)).frame(width: 36, height: 4).padding(.top, 12)
            Text("Ustawienia Powiadomień").font(.system(size: 18, weight: .bold)).foregroundColor(.white)

            VStack(spacing: 12) {
                Toggle(isOn: $state.notifRideStatus) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Status przejazdu").font(.system(size: 15, weight: .bold)).foregroundColor(.white)
                        Text("Powiadomienia o przyjeździe kierowcy").font(.system(size: 12)).foregroundColor(DrivoTheme.muted)
                    }
                }
                .tint(DrivoTheme.accent)
                .padding(14)
                .background(DrivoTheme.card2)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                Toggle(isOn: $state.notifPromos) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Promocje i zniżki").font(.system(size: 15, weight: .bold)).foregroundColor(.white)
                        Text("Informacje o kodach rabatowych").font(.system(size: 12)).foregroundColor(DrivoTheme.muted)
                    }
                }
                .tint(DrivoTheme.accent)
                .padding(14)
                .background(DrivoTheme.card2)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                Toggle(isOn: $state.notifSounds) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Dźwięki w aplikacji").font(.system(size: 15, weight: .bold)).foregroundColor(.white)
                        Text("Dźwięki powiadomień i potwierdzeń").font(.system(size: 12)).foregroundColor(DrivoTheme.muted)
                    }
                }
                .tint(DrivoTheme.accent)
                .padding(14)
                .background(DrivoTheme.card2)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .background(DrivoTheme.bg.ignoresSafeArea())
    }
}

// MARK: - Activity Stats Modal
struct ActivityStatsModal: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Capsule().fill(Color.white.opacity(0.3)).frame(width: 36, height: 4).padding(.top, 12)
            Text("Twoja Aktywność").font(.system(size: 18, weight: .bold)).foregroundColor(.white)

            VStack(spacing: 12) {
                ActivityDetailRow(label: "Łączna liczba kursów", value: "47")
                ActivityDetailRow(label: "Przejechany dystans", value: "312.4 km")
                ActivityDetailRow(label: "Średni czas przejazdu", value: "12 minut")
                ActivityDetailRow(label: "Zaoszczędzono z kodami", value: "62.00 zł")
                ActivityDetailRow(label: "Ocena pasażera", value: "⭐ 4.95 / 5.0")
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .background(DrivoTheme.bg.ignoresSafeArea())
    }
}

struct ActivityDetailRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack {
            Text(label).font(.system(size: 14)).foregroundColor(DrivoTheme.muted)
            Spacer()
            Text(value).font(.system(size: 15, weight: .bold)).foregroundColor(.white)
        }
        .padding(14)
        .background(DrivoTheme.card2)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}