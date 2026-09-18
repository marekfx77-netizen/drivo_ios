import SwiftUI
import MapKit

struct TrackingView: View {
    @EnvironmentObject var state: AppState
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.2310, longitude: 21.0130),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var mapType: MKMapType = .standard
    @State private var etaSec = 167
    @State private var timer: Timer? = nil
    let ridePrices = ["eco":"12.50 zl","comfort":"18.90 zl","xl":"28.00 zl"]
    var etaString: String { etaSec <= 0 ? "Tutaj!" : "\(etaSec/60):\(etaSec%60 < 10 ? "0" : "")\(etaSec%60)" }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                DrivoMapView(region: $region, mapType: $mapType).frame(height: 300)
                HStack {
                    Button { state.screen = .home } label: {
                        Image(systemName: "chevron.left").font(.system(size: 18, weight: .semibold)).foregroundColor(.white)
                            .frame(width: 40, height: 40).background(.ultraThinMaterial).clipShape(Circle())
                    }.padding(.leading, 16)
                    Spacer()
                }.frame(maxHeight: .infinity, alignment: .top).padding(.top, 64)

                HStack(spacing: 8) {
                    Circle().fill(DrivoTheme.green).frame(width: 8, height: 8)
                    Text("Kierowca jedzie do Ciebie").font(.system(size: 13, weight: .bold)).foregroundColor(.white)
                }
                .padding(.horizontal, 18).padding(.vertical, 8)
                .background(DrivoTheme.green.opacity(0.15)).overlay(Capsule().stroke(DrivoTheme.green.opacity(0.3), lineWidth: 1)).clipShape(Capsule())
                .padding(.bottom, 16)
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.2)).frame(width: 36, height: 4).padding(.top, 14)

                    // Driver
                    HStack(spacing: 14) {
                        ZStack {
                            LinearGradient(colors: [Color(hex: "5B8DEF"), DrivoTheme.accent], startPoint: .topLeading, endPoint: .bottomTrailing)
                            Text("JK").font(.system(size: 22, weight: .heavy)).foregroundColor(.white)
                        }
                        .frame(width: 58, height: 58).clipShape(Circle()).overlay(Circle().stroke(DrivoTheme.accent, lineWidth: 2))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Jakub Kowalski").font(.system(size: 18, weight: .heavy)).foregroundColor(.white)
                            HStack(spacing: 3) {
                                ForEach(0..<5, id: \.self) { _ in Image(systemName: "star.fill").font(.system(size: 12)).foregroundColor(Color(hex: "FFD700")) }
                                Text("4.97").font(.system(size: 13, weight: .bold)).foregroundColor(.white)
                                Text("(1 204)").font(.system(size: 11)).foregroundColor(DrivoTheme.muted)
                            }
                            Text("Toyota Camry · Srebrny").font(.system(size: 12)).foregroundColor(DrivoTheme.muted)
                        }
                        Spacer()
                    }

                    // Actions
                    HStack(spacing: 10) {
                        ABBtn(icon: "phone.fill", label: "Dzwon")
                        ABBtn(icon: "message.fill", label: "SMS")
                        ABBtn(icon: "heart.fill", label: "Bezpiecz.")
                        ABBtn(icon: "info.circle.fill", label: "Pomoc")
                    }

                    // Trip stats
                    HStack(spacing: 0) {
                        TStat(value: "2.1 km", label: "Dystans")
                        Divider().frame(height: 40).background(DrivoTheme.border)
                        TStat(value: "8 min", label: "Czas jazdy")
                        Divider().frame(height: 40).background(DrivoTheme.border)
                        TStat(value: ridePrices[state.selectedRide] ?? "12.50 zl", label: "Cena")
                    }
                    .background(DrivoTheme.card2).overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.border, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    // ETA card
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Kierowca dotrze za").font(.system(size: 11)).foregroundColor(DrivoTheme.muted)
                            Text(etaString).font(.system(size: 36, weight: .heavy, design: .monospaced)).foregroundColor(.white).contentTransition(.numericText())
                            Text("Sledz trase w czasie rzeczywistym").font(.system(size: 11)).foregroundColor(DrivoTheme.accent2)
                        }
                        Spacer()
                        ZStack {
                            Color.white
                            Text("WA 5DRV").font(.system(size: 16, weight: .heavy, design: .monospaced)).foregroundColor(Color(hex: "0A0A0F")).kerning(2)
                        }
                        .frame(width: 100, height: 44).clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 2))
                    }
                    .padding(16)
                    .background(LinearGradient(colors: [DrivoTheme.accent.opacity(0.15), Color(hex: "5B8DEF").opacity(0.15)], startPoint: .leading, endPoint: .trailing))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(DrivoTheme.accent.opacity(0.3), lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                    Button { state.screen = .home } label: {
                        Text("Anuluj przejazd").font(.system(size: 15, weight: .semibold)).foregroundColor(DrivoTheme.red)
                            .frame(maxWidth: .infinity).padding(.vertical, 14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(DrivoTheme.red.opacity(0.3), lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }.padding(.horizontal, 18).padding(.bottom, 30)
            }.background(DrivoTheme.card)
        }.background(DrivoTheme.bg).ignoresSafeArea(edges: .top)
        .onAppear {
            etaSec = 167; timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in if etaSec > 0 { etaSec -= 1 } }
        }
        .onDisappear { timer?.invalidate() }
    }
}

struct ABBtn: View {
    let icon: String; let label: String
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 20)).foregroundColor(Color.white.opacity(0.7))
            Text(label).font(.system(size: 10)).foregroundColor(DrivoTheme.muted)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 13).background(DrivoTheme.card2)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.border, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct TStat: View {
    let value: String; let label: String
    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(.system(size: 15, weight: .bold)).foregroundColor(.white)
            Text(label).font(.system(size: 10)).foregroundColor(DrivoTheme.muted)
        }.frame(maxWidth: .infinity).padding(.vertical, 11)
    }
}