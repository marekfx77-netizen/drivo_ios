import SwiftUI
import MapKit

struct HomeView: View {
    @EnvironmentObject var state: AppState
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    @State private var mapType: MKMapType = .standard
    @State private var showPromo = true

    var body: some View {
        VStack(spacing: 0) {
            // Map area
            ZStack(alignment: .top) {
                DrivoMapView(region: $region, mapType: $mapType)
                    .ignoresSafeArea(edges: .top)

                // Header overlay
                VStack {
                    HStack {
                        // Greeting pill
                        HStack(spacing: 10) {
                            ZStack {
                                LinearGradient(colors: [DrivoTheme.accent, Color(hex: "5B8DEF")],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                                Text("MS").font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                            }
                            .frame(width: 38, height: 38).clipShape(Circle())

                            VStack(alignment: .leading, spacing: 1) {
                                Text("Dobry wieczor, Mikolaj")
                                    .font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                                HStack(spacing: 3) {
                                    Image(systemName: "location.fill").font(.system(size: 9))
                                    Text("Warszawa, Polska").font(.system(size: 11))
                                }.foregroundColor(DrivoTheme.muted)
                            }
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(.ultraThinMaterial).clipShape(Capsule())
                        .overlay(Capsule().stroke(DrivoTheme.border, lineWidth: 1))

                        Spacer()

                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell").font(.system(size: 18)).foregroundColor(.white)
                                .frame(width: 44, height: 44).background(.ultraThinMaterial).clipShape(Circle())
                                .overlay(Circle().stroke(DrivoTheme.border, lineWidth: 1))
                            Circle().fill(DrivoTheme.accent).frame(width: 10, height: 10).offset(x: 2, y: -2)
                        }
                    }
                    .padding(.horizontal, 16).padding(.top, 64)

                    Spacer()

                    // Map toggle
                    HStack {
                        Spacer()
                        HStack(spacing: 0) {
                            mapToggleBtn("Satelita", mode: "satellite", type: .satellite)
                            mapToggleBtn("Klasyczna", mode: "classic", type: .standard)
                        }
                        .background(.ultraThinMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(DrivoTheme.border, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .padding(.trailing, 14).padding(.bottom, 14)
                }
            }
            .frame(height: 300)

            // Bottom sheet
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.2))
                        .frame(width: 36, height: 4).padding(.top, 14)

                    // Where to
                    Button { state.screen = .search } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                DrivoTheme.accent.opacity(0.15)
                                Image(systemName: "magnifyingglass").foregroundColor(DrivoTheme.accent).font(.system(size: 18))
                            }
                            .frame(width: 42, height: 42).clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Dokad jedziesz?").font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                                Text("Wpisz adres lub miejsce").font(.system(size: 12)).foregroundColor(DrivoTheme.muted)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").font(.system(size: 14, weight: .semibold)).foregroundColor(Color.white.opacity(0.3))
                        }
                        .padding(16).background(DrivoTheme.card2)
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(DrivoTheme.border, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }

                    // Quick tiles
                    HStack(spacing: 10) {
                        QuickTile(icon: "house.fill", label: "Dom", color: DrivoTheme.green) { state.screen = .search }
                        QuickTile(icon: "briefcase.fill", label: "Praca", color: Color(hex: "5B8DEF")) { state.screen = .search }
                        QuickTile(icon: "star.fill", label: "Ulubione", color: DrivoTheme.amber) { state.screen = .search }
                    }

                    // Promo banner
                    if showPromo {
                        HStack(spacing: 12) {
                            ZStack {
                                DrivoTheme.accent.opacity(0.15)
                                Image(systemName: "gift.fill").foregroundColor(DrivoTheme.accent2)
                            }
                            .frame(width: 40, height: 40).clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Rabat -25% na pierwszy przejazd").font(.system(size: 13, weight: .bold)).foregroundColor(.white)
                                Text("Uzyj kodu: DRIVO25").font(.system(size: 11)).foregroundColor(DrivoTheme.accent2)
                            }
                            Spacer()
                            Button { showPromo = false } label: {
                                Image(systemName: "xmark").font(.system(size: 12, weight: .semibold)).foregroundColor(Color.white.opacity(0.4))
                            }
                        }
                        .padding(14)
                        .background(LinearGradient(colors: [DrivoTheme.accent.opacity(0.15), Color(hex: "5B8DEF").opacity(0.15)], startPoint: .leading, endPoint: .trailing))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.accent.opacity(0.3), lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }

                    HStack {
                        Text("Ostatnie miejsca").font(.system(size: 17, weight: .bold)).foregroundColor(.white)
                        Spacer()
                    }

                    VStack(spacing: 0) {
                        RecentRow(name: "Zlote Tarasy", addr: "Al. Jana Pawla II 15, Warszawa", time: "14 min") { state.screen = .ride }
                        Divider().background(DrivoTheme.border).padding(.leading, 54)
                        RecentRow(name: "Lotnisko Chopina", addr: "ul. Zwirki i Wigury 1, Warszawa", time: "32 min") { state.screen = .ride }
                    }
                }
                .padding(.horizontal, 18).padding(.bottom, 100)
            }
            .background(DrivoTheme.card)

            BottomNavView(selectedTab: .constant(0)).environmentObject(state)
        }
        .background(DrivoTheme.bg).ignoresSafeArea(edges: .top)
    }

    @ViewBuilder
    func mapToggleBtn(_ label: String, mode: String, type: MKMapType) -> some View {
        Button(label) {
            mapType = type
            state.mapMode = mode
        }
        .font(.system(size: 12, weight: .semibold))
        .foregroundColor(state.mapMode == mode ? .white : DrivoTheme.muted)
        .padding(.horizontal, 12).padding(.vertical, 8)
        .background(state.mapMode == mode ? DrivoTheme.accent : Color.clear)
    }
}

// MARK: - MapView Wrapper
struct DrivoMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var mapType: MKMapType

    func makeUIView(context: Context) -> MKMapView {
        let m = MKMapView()
        m.showsUserLocation = true
        m.region = region
        m.mapType = mapType
        return m
    }
    func updateUIView(_ v: MKMapView, context: Context) {
        v.mapType = mapType
    }
}

// MARK: - Shared Components
struct QuickTile: View {
    let icon: String; let label: String; let color: Color; let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                ZStack {
                    color.opacity(0.15)
                    Image(systemName: icon).foregroundColor(color).font(.system(size: 16))
                }
                .frame(width: 34, height: 34).clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                Text(label).font(.system(size: 12, weight: .semibold)).foregroundColor(.white)
                Spacer()
            }
            .padding(12).background(DrivoTheme.card2)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.border, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

struct RecentRow: View {
    let name: String; let addr: String; let time: String; let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Color.white.opacity(0.06)
                    Image(systemName: "clock").foregroundColor(DrivoTheme.muted).font(.system(size: 16))
                }
                .frame(width: 42, height: 42).clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                VStack(alignment: .leading, spacing: 2) {
                    Text(name).font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                    Text(addr).font(.system(size: 11)).foregroundColor(DrivoTheme.muted)
                }
                Spacer()
                Text(time).font(.system(size: 12)).foregroundColor(DrivoTheme.muted)
            }.padding(.vertical, 11)
        }
    }
}
