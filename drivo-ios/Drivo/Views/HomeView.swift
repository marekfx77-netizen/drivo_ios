import SwiftUI
import MapKit

// MARK: - Sheet Snap Position
enum SheetPosition {
    case minimized
    case medium
    case expanded

    var height: CGFloat {
        switch self {
        case .minimized: return 120
        case .medium:    return 365
        case .expanded:  return 660
        }
    }
}

// MARK: - Home View
struct HomeView: View {
    @EnvironmentObject var state: AppState
    @ObservedObject var locationManager = LocationManager.shared

    // Map state
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122),
        span: MKCoordinateSpan(latitudeDelta: 0.018, longitudeDelta: 0.018)
    )
    @State private var mapType: MKMapType = .standard
    @State private var is3D = true

    // Draggable Sheet State
    @State private var sheetPosition: SheetPosition = .medium
    @State private var dragOffset: CGFloat = 0
    @State private var showPromo = true
    @State private var showNotificationAlert = false

    var currentSheetHeight: CGFloat {
        let base = sheetPosition.height - dragOffset
        return max(SheetPosition.minimized.height, min(SheetPosition.expanded.height, base))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // 1. FULLSCREEN MAP
            DrivoInteractiveMapView(
                region: $region,
                mapType: $mapType,
                is3D: is3D,
                userLocation: locationManager.userLocation
            )
            .ignoresSafeArea()

            // 2. TOP FLOATING CONTROLS
            VStack {
                HStack {
                    // Profile greeting pill
                    Button {
                        HapticsManager.shared.impact(.light)
                        state.screen = .profile
                    } label: {
                        HStack(spacing: 10) {
                            ZStack {
                                LinearGradient(
                                    colors: [DrivoTheme.gradientA, DrivoTheme.gradientB],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                                Text("MS")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Witaj, Mikołaj")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(DrivoTheme.green)
                                        .frame(width: 6, height: 6)
                                    Text(locationManager.fullAddress.isEmpty ? "Lokalizowanie..." : locationManager.fullAddress)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(DrivoTheme.muted)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(DrivoTheme.border, lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.25), radius: 10, y: 4)
                    }

                    Spacer()

                    // Notifications button
                    Button {
                        HapticsManager.shared.impact(.light)
                        showNotificationAlert = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(DrivoTheme.border, lineWidth: 1))
                                .shadow(color: Color.black.opacity(0.25), radius: 10, y: 4)

                            Circle()
                                .fill(DrivoTheme.accent)
                                .frame(width: 10, height: 10)
                                .offset(x: 2, y: -2)
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 56)

                Spacer()

                // Floating Map Controls (Right Side)
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        // Recenter on GPS location button
                        Button {
                            HapticsManager.shared.impact(.medium)
                            if let loc = locationManager.userLocation {
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                                    region.center = loc
                                    region.span = MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
                                }
                            }
                        } label: {
                            Image(systemName: "location.fill")
                                .font(.system(size: 18))
                                .foregroundColor(DrivoTheme.accent2)
                                .frame(width: 46, height: 46)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(DrivoTheme.border, lineWidth: 1))
                                .shadow(color: Color.black.opacity(0.3), radius: 12, y: 6)
                        }

                        // Map Style Toggle
                        HStack(spacing: 0) {
                            Button {
                                HapticsManager.shared.impact(.light)
                                mapType = .satellite
                                state.mapMode = "satellite"
                            } label: {
                                Text("Satelita")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(state.mapMode == "satellite" ? .white : DrivoTheme.muted)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .background(state.mapMode == "satellite" ? DrivoTheme.accent : Color.clear)
                            }

                            Button {
                                HapticsManager.shared.impact(.light)
                                mapType = .standard
                                state.mapMode = "classic"
                            } label: {
                                Text("Mapa")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(state.mapMode == "classic" ? .white : DrivoTheme.muted)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .background(state.mapMode == "classic" ? DrivoTheme.accent : Color.clear)
                            }
                        }
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(DrivoTheme.border, lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.3), radius: 12, y: 6)
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, currentSheetHeight + 16)
                }
            }
            .ignoresSafeArea(edges: .top)

            // 3. DRAGGABLE BOTTOM SHEET
            VStack(spacing: 0) {
                // Drag Handle Bar
                ZStack {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 40, height: 5)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 24)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.height
                        }
                        .onEnded { value in
                            let velocity = value.predictedEndTranslation.height
                            let targetHeight = sheetPosition.height - value.translation.height
                            
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                                dragOffset = 0
                                if velocity < -200 || targetHeight > 450 {
                                    sheetPosition = .expanded
                                } else if velocity > 200 || targetHeight < 220 {
                                    sheetPosition = .minimized
                                } else {
                                    sheetPosition = .medium
                                }
                            }
                            HapticsManager.shared.impact(.light)
                        }
                )

                // Sheet Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        // "Dokąd jedziesz?" Search Bar
                        Button {
                            HapticsManager.shared.impact(.medium)
                            state.screen = .search
                        } label: {
                            HStack(spacing: 12) {
                                ZStack {
                                    DrivoTheme.accent.opacity(0.18)
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(DrivoTheme.accent2)
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .frame(width: 42, height: 42)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Dokąd jedziesz?")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("Wpisz adres, restaurację lub miejsce")
                                        .font(.system(size: 12))
                                        .foregroundColor(DrivoTheme.muted)
                                }
                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.white.opacity(0.3))
                            }
                            .padding(14)
                            .background(DrivoTheme.card2)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(DrivoTheme.border, lineWidth: 1))
                        }

                        // Quick Destination Tiles
                        HStack(spacing: 10) {
                            QuickTileView(
                                icon: "house.fill",
                                title: "Dom",
                                subtitle: state.homeAddress,
                                color: DrivoTheme.green
                            ) {
                                HapticsManager.shared.impact(.medium)
                                state.destinationName = "Dom"
                                state.destinationAddress = state.homeAddress
                                state.screen = .ride
                            }

                            QuickTileView(
                                icon: "briefcase.fill",
                                title: "Praca",
                                subtitle: state.workAddress,
                                color: Color(hex: "4F75FF")
                            ) {
                                HapticsManager.shared.impact(.medium)
                                state.destinationName = "Praca"
                                state.destinationAddress = state.workAddress
                                state.screen = .ride
                            }

                            QuickTileView(
                                icon: "star.fill",
                                title: "Ulubione",
                                subtitle: "Złote Tarasy",
                                color: DrivoTheme.amber
                            ) {
                                HapticsManager.shared.impact(.medium)
                                state.destinationName = "Złote Tarasy"
                                state.destinationAddress = "ul. Złota 59, Warszawa"
                                state.screen = .ride
                            }
                        }

                        // Promo Banner
                        if showPromo {
                            HStack(spacing: 12) {
                                ZStack {
                                    DrivoTheme.accent.opacity(0.2)
                                    Image(systemName: "gift.fill")
                                        .foregroundColor(DrivoTheme.accent2)
                                        .font(.system(size: 18))
                                }
                                .frame(width: 42, height: 42)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Zniżka -25% z kodem DRIVO25")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("Dotknij, aby aktywować na kolejny przejazd")
                                        .font(.system(size: 11))
                                        .foregroundColor(DrivoTheme.accent2)
                                }

                                Spacer()

                                Button {
                                    HapticsManager.shared.impact(.light)
                                    _ = state.applyPromo(code: "DRIVO25")
                                    showPromo = false
                                } label: {
                                    Text("Aktywuj")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(DrivoTheme.accent)
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(12)
                            .background(
                                LinearGradient(
                                    colors: [DrivoTheme.accent.opacity(0.18), Color(hex: "4F75FF").opacity(0.18)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.accent.opacity(0.35), lineWidth: 1))
                        }

                        // Recent Places Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Ostatnie miejsca")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 4)

                            VStack(spacing: 0) {
                                RecentTripRow(
                                    name: "Złote Tarasy",
                                    address: "ul. Złota 59, Warszawa",
                                    distance: "2.1 km",
                                    time: "8 min"
                                ) {
                                    HapticsManager.shared.impact(.light)
                                    state.destinationName = "Złote Tarasy"
                                    state.destinationAddress = "ul. Złota 59, Warszawa"
                                    state.screen = .ride
                                }

                                Divider().background(DrivoTheme.border)

                                RecentTripRow(
                                    name: "Lotnisko Chopina",
                                    address: "ul. Żwirki i Wigury 1, Warszawa",
                                    distance: "12.4 km",
                                    time: "24 min"
                                ) {
                                    HapticsManager.shared.impact(.light)
                                    state.destinationName = "Lotnisko Chopina"
                                    state.destinationAddress = "ul. Żwirki i Wigury 1, Warszawa"
                                    state.screen = .ride
                                }

                                Divider().background(DrivoTheme.border)

                                RecentTripRow(
                                    name: "Centrum Nauki Kopernik",
                                    address: "ul. Wybrzeże Kościuszkowskie 20",
                                    distance: "3.7 km",
                                    time: "11 min"
                                ) {
                                    HapticsManager.shared.impact(.light)
                                    state.destinationName = "Centrum Nauki Kopernik"
                                    state.destinationAddress = "ul. Wybrzeże Kościuszkowskie 20, Warszawa"
                                    state.screen = .ride
                                }
                            }
                            .background(DrivoTheme.card2)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(DrivoTheme.border, lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 90)
                }
            }
            .frame(height: currentSheetHeight)
            .background(
                DrivoTheme.card
                    .clipShape(CustomRoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
                    .shadow(color: Color.black.opacity(0.55), radius: 24, y: -6)
            )

            // 4. BOTTOM NAVIGATION
            BottomNavView(selectedTab: .constant(0))
                .environmentObject(state)
        }
        .alert("Powiadomienia Drivo", isPresented: $showNotificationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Wszystkie usługi działają optymalnie. Kierowcy w Twojej okolicy: 6 dostępnych aut.")
        }
    }
}

// MARK: - Interactive MapView with Cars & 3D
struct DrivoInteractiveMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var mapType: MKMapType
    var is3D: Bool
    var userLocation: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.region = region
        mapView.mapType = mapType

        // Add simulated nearby drivers around user or center
        addSimulatedCars(to: mapView)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if uiView.mapType != mapType {
            uiView.mapType = mapType
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func addSimulatedCars(to mapView: MKMapView) {
        let offsets: [(Double, Double, String)] = [
            (0.002, 0.003, "Toyota Camry"),
            (-0.003, 0.002, "Skoda Octavia"),
            (0.004, -0.002, "Hyundai Ioniq"),
            (-0.002, -0.004, "Mercedes E-Class")
        ]
        for (dLat, dLon, title) in offsets {
            let anno = MKPointAnnotation()
            anno.coordinate = CLLocationCoordinate2D(
                latitude: 52.2297 + dLat,
                longitude: 21.0122 + dLon
            )
            anno.title = title
            mapView.addAnnotation(anno)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: DrivoInteractiveMapView
        private var hasCenteredOnUser = false

        init(_ parent: DrivoInteractiveMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            guard let location = userLocation.location else { return }
            if !hasCenteredOnUser {
                hasCenteredOnUser = true
                let span = MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.setRegion(region, animated: true)
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }

            let identifier = "DriverCarAnnotation"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if view == nil {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
                
                // Custom Car Pin
                let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
                iconView.image = UIImage(systemName: "car.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                iconView.contentMode = .center
                iconView.backgroundColor = UIColor(red: 124/255, green: 92/255, blue: 252/255, alpha: 1.0)
                iconView.layer.cornerRadius = 16
                iconView.layer.borderWidth = 2
                iconView.layer.borderColor = UIColor.white.cgColor
                iconView.layer.shadowColor = UIColor.black.cgColor
                iconView.layer.shadowOpacity = 0.35
                iconView.layer.shadowOffset = CGSize(width: 0, height: 3)
                iconView.layer.shadowRadius = 6
                view?.addSubview(iconView)
                view?.frame = iconView.frame
            } else {
                view?.annotation = annotation
            }
            return view
        }
    }
}

// MARK: - Quick Tile View
struct QuickTileView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                ZStack {
                    color.opacity(0.18)
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 15, weight: .semibold))
                }
                .frame(width: 32, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(DrivoTheme.muted)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(DrivoTheme.card2)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(DrivoTheme.border, lineWidth: 1))
        }
    }
}

// MARK: - Recent Trip Row
struct RecentTripRow: View {
    let name: String
    let address: String
    let distance: String
    let time: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Color.white.opacity(0.06)
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(DrivoTheme.muted)
                        .font(.system(size: 16))
                }
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Text(address)
                        .font(.system(size: 11))
                        .foregroundColor(DrivoTheme.muted)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(distance)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(DrivoTheme.accent2)
                    Text(time)
                        .font(.system(size: 10))
                        .foregroundColor(DrivoTheme.muted)
                }
            }
            .padding(12)
        }
    }
}

// MARK: - Custom Rounded Corner Shape
struct CustomRoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
