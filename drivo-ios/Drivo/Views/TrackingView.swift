import SwiftUI
import MapKit

struct TrackingView: View {
    @EnvironmentObject var state: AppState

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.2312, longitude: 21.0135),
        span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
    )
    @State private var mapType: MKMapType = .standard
    @State private var etaSeconds = 167
    @State private var timer: Timer? = nil

    // Alerts and Sheet States
    @State private var showCallAlert = false
    @State private var showSmsAlert = false
    @State private var showSafetySheet = false
    @State private var showHelpSheet = false
    @State private var showCancelConfirm = false

    var formattedEta: String {
        if etaSeconds <= 0 { return "Kierowca czeka!" }
        let min = etaSeconds / 60
        let sec = etaSeconds % 60
        return String(format: "%d:%02d", min, sec)
    }

    var body: some View {
        VStack(spacing: 0) {
            // TOP LIVE MAP
            ZStack(alignment: .bottom) {
                TrackingMapView(region: $region, mapType: $mapType)
                    .frame(height: 280)
                    .ignoresSafeArea(edges: .top)

                // Back to home button
                HStack {
                    Button {
                        HapticsManager.shared.impact(.light)
                        state.screen = .home
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 42, height: 42)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(DrivoTheme.border, lineWidth: 1))
                            .shadow(color: Color.black.opacity(0.3), radius: 8, y: 4)
                    }
                    .padding(.leading, 18)

                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 56)

                // Driver Status Pill
                HStack(spacing: 8) {
                    Circle()
                        .fill(DrivoTheme.green)
                        .frame(width: 8, height: 8)
                    Text("Kierowca jedzie do Ciebie")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(DrivoTheme.green.opacity(0.18))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(DrivoTheme.green.opacity(0.4), lineWidth: 1))
                .padding(.bottom, 14)
            }

            // BOTTOM TRIP & DRIVER DETAILS SHEET
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 38, height: 4)
                        .padding(.top, 10)

                    // Driver Card
                    HStack(spacing: 14) {
                        ZStack {
                            LinearGradient(
                                colors: [Color(hex: "4F75FF"), DrivoTheme.gradientA],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                            Text("JK")
                                .font(.system(size: 22, weight: .heavy))
                                .foregroundColor(.white)
                        }
                        .frame(width: 58, height: 58)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(DrivoTheme.accent, lineWidth: 2))

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Jakub Kowalski")
                                .font(.system(size: 18, weight: .heavy))
                                .foregroundColor(.white)

                            HStack(spacing: 4) {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 11))
                                        .foregroundColor(DrivoTheme.amber)
                                }
                                Text("4.97")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                Text("(1 204 kursy)")
                                    .font(.system(size: 11))
                                    .foregroundColor(DrivoTheme.muted)
                            }

                            Text("Toyota Camry • Srebrny Metalik")
                                .font(.system(size: 12))
                                .foregroundColor(DrivoTheme.muted)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 18)

                    // Action Buttons (Call, SMS, Safety, Help)
                    HStack(spacing: 10) {
                        DriverActionButton(icon: "phone.fill", label: "Zadzwoń", color: DrivoTheme.green) {
                            HapticsManager.shared.impact(.medium)
                            showCallAlert = true
                        }

                        DriverActionButton(icon: "message.fill", label: "Wiadomość", color: DrivoTheme.accent2) {
                            HapticsManager.shared.impact(.medium)
                            showSmsAlert = true
                        }

                        DriverActionButton(icon: "shield.fill", label: "Bezpieczeństwo", color: Color(hex: "4F75FF")) {
                            HapticsManager.shared.impact(.medium)
                            showSafetySheet = true
                        }

                        DriverActionButton(icon: "questionmark.circle.fill", label: "Pomoc", color: DrivoTheme.muted) {
                            HapticsManager.shared.impact(.medium)
                            showHelpSheet = true
                        }
                    }
                    .padding(.horizontal, 18)

                    // Trip Stats Strip
                    HStack(spacing: 0) {
                        TrackingStatBlock(title: "Dystans", value: String(format: "%.1f km", state.tripDistanceKm))
                        Divider().frame(height: 38).background(DrivoTheme.border)
                        TrackingStatBlock(title: "Czas trasy", value: "\(state.tripDurationMinutes) min")
                        Divider().frame(height: 38).background(DrivoTheme.border)
                        TrackingStatBlock(title: "Płatność", value: state.paymentMethod)
                    }
                    .background(DrivoTheme.card2)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.border, lineWidth: 1))
                    .padding(.horizontal, 18)

                    // ETA & License Plate Card
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Przyjazd za")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(DrivoTheme.muted)

                            Text(formattedEta)
                                .font(.system(size: 34, weight: .heavy, design: .monospaced))
                                .foregroundColor(.white)

                            Text("Śledzenie trasy na żywo")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(DrivoTheme.accent2)
                        }

                        Spacer()

                        // License plate badge
                        VStack(spacing: 2) {
                            HStack(spacing: 4) {
                                Image(systemName: "flag.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(.blue)
                                Text("PL")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            Text("WA 5DRV")
                                .font(.system(size: 16, weight: .heavy, design: .monospaced))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1.5))
                        .shadow(color: Color.black.opacity(0.3), radius: 6, y: 3)
                    }
                    .padding(16)
                    .background(
                        LinearGradient(
                            colors: [DrivoTheme.accent.opacity(0.2), Color(hex: "4F75FF").opacity(0.2)],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(DrivoTheme.accent.opacity(0.35), lineWidth: 1))
                    .padding(.horizontal, 18)

                    // Cancel Ride Button
                    Button {
                        HapticsManager.shared.impact(.medium)
                        showCancelConfirm = true
                    } label: {
                        Text("Anuluj przejazd")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(DrivoTheme.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(DrivoTheme.red.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.red.opacity(0.35), lineWidth: 1))
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 36)
                }
            }
            .background(DrivoTheme.card)
        }
        .background(DrivoTheme.bg)
        .ignoresSafeArea(edges: .top)
        .onAppear {
            startEtaTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
        // CALL ALERT
        .alert("Połączenie z kierowcą", isPresented: $showCallAlert) {
            Button("Zadzwoń: +48 500 123 456") {
                if let url = URL(string: "tel://500123456") {
                    UIApplication.shared.open(url)
                }
            }
            Button("Anuluj", role: .cancel) {}
        } message: {
            Text("Twój numer pozostaje anonimowy i chroniony.")
        }
        // SMS ALERT
        .alert("Wiadomość do kierowcy", isPresented: $showSmsAlert) {
            Button("Czekam przy wejściu głównym") {}
            Button("Będę za minutę") {}
            Button("Napisz własną...", role: .none) {
                if let url = URL(string: "sms://500123456") {
                    UIApplication.shared.open(url)
                }
            }
            Button("Anuluj", role: .cancel) {}
        }
        // CANCEL CONFIRMATION
        .alert("Czy na pewno chcesz anulować kurs?", isPresented: $showCancelConfirm) {
            Button("Tak, anuluj", role: .destructive) {
                HapticsManager.shared.notification(.warning)
                state.screen = .home
            }
            Button("Nie, czekam na kierowcę", role: .cancel) {}
        } message: {
            Text("Kierowca jest już w drodze do Ciebie.")
        }
        // SAFETY SHEET
        .sheet(isPresented: $showSafetySheet) {
            SafetyModalView()
        }
        // HELP SHEET
        .sheet(isPresented: $showHelpSheet) {
            HelpModalView()
        }
    }

    private func startEtaTimer() {
        etaSeconds = 167
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if etaSeconds > 0 {
                etaSeconds -= 1
            }
        }
    }
}

// MARK: - Tracking MapView
struct TrackingMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var mapType: MKMapType

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.region = region
        map.mapType = mapType
        map.showsCompass = false

        // User pin
        let userPin = MKPointAnnotation()
        userPin.coordinate = CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122)
        userPin.title = "Ty"

        // Driver pin
        let driverPin = MKPointAnnotation()
        driverPin.coordinate = CLLocationCoordinate2D(latitude: 52.2325, longitude: 21.0145)
        driverPin.title = "Kierowca"

        map.addAnnotations([userPin, driverPin])
        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.mapType = mapType
    }
}

// MARK: - Action Button
struct DriverActionButton: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                ZStack {
                    color.opacity(0.15)
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(color)
                }
                .frame(width: 44, height: 44)
                .clipShape(Circle())
                .overlay(Circle().stroke(DrivoTheme.border, lineWidth: 1))

                Text(label)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(DrivoTheme.muted)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Stat Block
struct TrackingStatBlock: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(DrivoTheme.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}

// MARK: - Safety Modal
struct SafetyModalView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Capsule().fill(Color.white.opacity(0.3)).frame(width: 36, height: 4).padding(.top, 12)
            Text("Centrum Bezpieczeństwa").font(.system(size: 18, weight: .bold)).foregroundColor(.white)

            VStack(spacing: 12) {
                SafetyOptionRow(icon: "square.and.arrow.up.fill", color: DrivoTheme.accent2, title: "Udostępnij trasę na żywo", subtitle: "Wyślij link bliskiej osobie") {
                    // share action
                }
                SafetyOptionRow(icon: "phone.circle.fill", color: DrivoTheme.red, title: "Numer alarmowy 112", subtitle: "Szybkie wezwanie pomocy") {
                    if let url = URL(string: "tel://112") {
                        UIApplication.shared.open(url)
                    }
                }
                SafetyOptionRow(icon: "lock.shield.fill", color: DrivoTheme.green, title: "Kod PIN przejazdu", subtitle: "Podaj kod kierowcy przed rozpoczęciem") {}
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .background(DrivoTheme.bg.ignoresSafeArea())
    }
}

struct SafetyOptionRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.15))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 15, weight: .bold)).foregroundColor(.white)
                    Text(subtitle).font(.system(size: 11)).foregroundColor(DrivoTheme.muted)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(DrivoTheme.muted).font(.system(size: 13))
            }
            .padding(14)
            .background(DrivoTheme.card2)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

// MARK: - Help Modal
struct HelpModalView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Capsule().fill(Color.white.opacity(0.3)).frame(width: 36, height: 4).padding(.top, 12)
            Text("Pomoc z przejazdem").font(.system(size: 18, weight: .bold)).foregroundColor(.white)

            VStack(spacing: 10) {
                HelpItem(question: "Zgubiłem rzecz w pojeździe", desc: "Skontaktuj się z kierowcą lub supportem Drivo.")
                HelpItem(question: "Kierowca nie pojawia się", desc: "Zadzwoń do kierowcy lub anuluj bez opłat do 3 minut.")
                HelpItem(question: "Problem z płatnością", desc: "Twoje konto zostanie obciążone dopiero po zakończeniu kursu.")
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .background(DrivoTheme.bg.ignoresSafeArea())
    }
}

struct HelpItem: View {
    let question: String
    let desc: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(question).font(.system(size: 14, weight: .bold)).foregroundColor(.white)
            Text(desc).font(.system(size: 12)).foregroundColor(DrivoTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(DrivoTheme.card2)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}