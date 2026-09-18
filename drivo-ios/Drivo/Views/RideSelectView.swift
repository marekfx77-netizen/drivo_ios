import SwiftUI
import MapKit

// MARK: - Ride Type Model
struct DrivoRideTier: Identifiable {
    let id: String
    let name: String
    let subtitle: String
    let basePrice: Double
    let etaMinutes: Int
    let iconName: String
    let capacity: String
    let badgeText: String?
}

struct RideSelectView: View {
    @EnvironmentObject var state: AppState

    // Map & Route
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.2305, longitude: 21.0115),
        span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
    )
    @State private var mapType: MKMapType = .standard

    // Sheet / Modal states
    @State private var showPromoSheet = false
    @State private var promoInput = ""
    @State private var showPaymentSheet = false
    @State private var isOrdering = false

    let rideTiers: [DrivoRideTier] = [
        DrivoRideTier(id: "eco", name: "Drivo Eco", subtitle: "Szybki przejazd w najlepszej cenie", basePrice: 12.50, etaMinutes: 2, iconName: "car.fill", capacity: "3 os.", badgeText: nil),
        DrivoRideTier(id: "comfort", name: "Drivo Comfort", subtitle: "Nowe auta, przestrzeń i klimatyzacja", basePrice: 18.90, etaMinutes: 4, iconName: "car.2.fill", capacity: "4 os.", badgeText: "POLECANY"),
        DrivoRideTier(id: "xl", name: "Drivo XL", subtitle: "Przestronne vany i SUV-y dla grupy", basePrice: 28.00, etaMinutes: 6, iconName: "box.truck.fill", capacity: "6 os.", badgeText: nil)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // TOP MINI-MAP WITH ROUTE
            ZStack(alignment: .topLeading) {
                DrivoRouteMapView(region: $region, mapType: $mapType)
                    .frame(height: 230)
                    .ignoresSafeArea(edges: .top)

                // Back Button
                Button {
                    HapticsManager.shared.impact(.light)
                    state.screen = .search
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 42, height: 42)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(DrivoTheme.border, lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.35), radius: 8, y: 4)
                }
                .padding(.top, 56)
                .padding(.leading, 18)
            }

            // BOTTOM RIDE OPTIONS SHEET
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    // Handle Bar
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 38, height: 4)
                        .padding(.top, 10)

                    // Route Summary Strip
                    HStack(spacing: 14) {
                        VStack(spacing: 4) {
                            Circle().fill(DrivoTheme.green).frame(width: 9, height: 9)
                            Rectangle().fill(DrivoTheme.border).frame(width: 2, height: 26)
                            Circle().fill(DrivoTheme.accent).frame(width: 9, height: 9)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text(state.pickupName)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(DrivoTheme.muted)
                                .lineLimit(1)
                            Text(state.destinationName)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }

                        Spacer()

                        Button {
                            HapticsManager.shared.impact(.light)
                            state.screen = .search
                        } label: {
                            Image(systemName: "pencil")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(DrivoTheme.accent2)
                                .frame(width: 36, height: 36)
                                .background(DrivoTheme.card2)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(DrivoTheme.border, lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)

                    // Route Meta Info
                    HStack(spacing: 8) {
                        MetaBadge(icon: "clock.fill", text: "\(state.tripDurationMinutes) min jazdy")
                        MetaBadge(icon: "arrow.left.and.right", text: String(format: "%.1f km", state.tripDistanceKm))
                        MetaBadge(icon: "bolt.fill", text: "Odbiór za 2 min")
                    }
                    .padding(.horizontal, 18)

                    Divider().background(DrivoTheme.border)

                    // Promo Code Bar
                    Button {
                        HapticsManager.shared.impact(.light)
                        showPromoSheet = true
                    } label: {
                        HStack(spacing: 10) {
                            HStack(spacing: 5) {
                                Image(systemName: "percent")
                                    .font(.system(size: 11, weight: .bold))
                                Text(state.discountPercent > 0 ? state.promoCode : "KOD")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            .foregroundColor(DrivoTheme.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(DrivoTheme.green.opacity(0.16))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                            if state.discountPercent > 0 {
                                Text("Rabat -\(Int(state.discountPercent * 100))% aktywny!")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(DrivoTheme.green)
                            } else {
                                Text("Wpisz kod promocyjny")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(DrivoTheme.muted)
                        }
                        .padding(12)
                        .background(DrivoTheme.card2)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(state.discountPercent > 0 ? DrivoTheme.green.opacity(0.4) : DrivoTheme.border, lineWidth: 1))
                    }
                    .padding(.horizontal, 18)

                    // Ride Tier Cards
                    VStack(spacing: 10) {
                        ForEach(rideTiers) { tier in
                            let isSelected = state.selectedRide == tier.id
                            let finalPrice = tier.basePrice * (1.0 - state.discountPercent)

                            Button {
                                HapticsManager.shared.selection()
                                state.selectedRide = tier.id
                            } label: {
                                HStack(spacing: 12) {
                                    ZStack {
                                        isSelected ? DrivoTheme.accent.opacity(0.2) : DrivoTheme.surface
                                        Image(systemName: tier.iconName)
                                            .font(.system(size: 24))
                                            .foregroundColor(isSelected ? DrivoTheme.accent2 : .white)
                                    }
                                    .frame(width: 58, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(isSelected ? DrivoTheme.accent : DrivoTheme.border, lineWidth: 1))

                                    VStack(alignment: .leading, spacing: 3) {
                                        HStack(spacing: 6) {
                                            Text(tier.name)
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundColor(.white)

                                            if let badge = tier.badgeText {
                                                Text(badge)
                                                    .font(.system(size: 9, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(LinearGradient(colors: [DrivoTheme.gradientA, DrivoTheme.gradientB], startPoint: .leading, endPoint: .trailing))
                                                    .clipShape(Capsule())
                                            }

                                            Text("• \(tier.capacity)")
                                                .font(.system(size: 11))
                                                .foregroundColor(DrivoTheme.muted)
                                        }

                                        Text(tier.subtitle)
                                            .font(.system(size: 11))
                                            .foregroundColor(DrivoTheme.muted)
                                            .lineLimit(1)

                                        HStack(spacing: 4) {
                                            Image(systemName: "clock")
                                                .font(.system(size: 10))
                                            Text("Za \(tier.etaMinutes) min")
                                                .font(.system(size: 11, weight: .bold))
                                        }
                                        .foregroundColor(DrivoTheme.green)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 2) {
                                        if state.discountPercent > 0 {
                                            Text(String(format: "%.2f zł", tier.basePrice))
                                                .font(.system(size: 11))
                                                .foregroundColor(DrivoTheme.muted)
                                                .strikethrough()
                                        }

                                        Text(String(format: "%.2f zł", finalPrice))
                                            .font(.system(size: 17, weight: .heavy))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(12)
                                .background(isSelected ? DrivoTheme.cardLight : DrivoTheme.card2)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(isSelected ? DrivoTheme.accent : DrivoTheme.border, lineWidth: isSelected ? 1.5 : 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 18)

                    // Payment Method Selector
                    Button {
                        HapticsManager.shared.impact(.light)
                        showPaymentSheet = true
                    } label: {
                        HStack(spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: paymentIcon(for: state.paymentMethod))
                                    .font(.system(size: 14))
                                    .foregroundColor(DrivoTheme.accent2)
                                Text(state.paymentMethod)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(DrivoTheme.card2)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(DrivoTheme.border, lineWidth: 1))

                            Text("Zmień")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(DrivoTheme.accent2)

                            Spacer()
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 4)
                    }

                    // Order Button
                    Button {
                        HapticsManager.shared.impact(.heavy)
                        isOrdering = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            isOrdering = false
                            HapticsManager.shared.notification(.success)
                            state.screen = .tracking
                        }
                    } label: {
                        ZStack {
                            LinearGradient(
                                colors: [DrivoTheme.gradientA, DrivoTheme.gradientB],
                                startPoint: .leading, endPoint: .trailing
                            )

                            if isOrdering {
                                HStack(spacing: 10) {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    Text("Łączenie z kierowcą...")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            } else {
                                Text("Zamów przejazd")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: DrivoTheme.accent.opacity(0.4), radius: 18, y: 8)
                    }
                    .disabled(isOrdering)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 36)
                }
            }
            .background(DrivoTheme.card)
        }
        .background(DrivoTheme.bg)
        .ignoresSafeArea(edges: .top)
        // PROMO CODE SHEET
        .sheet(isPresented: $showPromoSheet) {
            PromoSheetView()
                .environmentObject(state)
        }
        // PAYMENT METHOD SHEET
        .sheet(isPresented: $showPaymentSheet) {
            PaymentSheetView()
                .environmentObject(state)
        }
    }

    private func paymentIcon(for method: String) -> String {
        switch method {
        case "Apple Pay": return "applelogo"
        case "BLIK": return "qrcode"
        case "Gotówka": return "banknote.fill"
        default: return "creditcard.fill"
        }
    }
}

// MARK: - Route MapView with Annotations and Curve
struct DrivoRouteMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var mapType: MKMapType

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.region = region
        mapView.mapType = mapType
        mapView.showsCompass = false
        mapView.showsUserLocation = false

        let p1 = MKPointAnnotation()
        p1.coordinate = CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122)
        p1.title = "Odbiór"

        let p2 = MKPointAnnotation()
        p2.coordinate = CLLocationCoordinate2D(latitude: 52.2315, longitude: 21.0108)
        p2.title = "Cel"

        mapView.addAnnotations([p1, p2])
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.mapType = mapType
    }
}

// MARK: - Meta Badge Component
struct MetaBadge: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11))
            Text(text)
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundColor(DrivoTheme.muted)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(DrivoTheme.pill)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

// MARK: - Promo Sheet Modal
struct PromoSheetView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) var dismiss
    @State private var code = ""
    @State private var message = ""

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.white.opacity(0.3))
                .frame(width: 36, height: 4)
                .padding(.top, 12)

            Text("Wprowadź kod zniżkowy")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            Text("Wpisz np. DRIVO25, aby uzyskać 25% rabatu na ten kurs!")
                .font(.system(size: 13))
                .foregroundColor(DrivoTheme.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            HStack {
                TextField("KOD ZNIŻKOWY", text: $code)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .autocapitalization(.allCharacters)
                    .disableAutocorrection(true)
                    .foregroundColor(.white)

                if !code.isEmpty {
                    Button {
                        code = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(DrivoTheme.muted)
                    }
                }
            }
            .padding(14)
            .background(DrivoTheme.card2)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(DrivoTheme.border, lineWidth: 1))
            .padding(.horizontal, 24)

            if !message.isEmpty {
                Text(message)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(state.discountPercent > 0 ? DrivoTheme.green : DrivoTheme.red)
            }

            Button {
                if state.applyPromo(code: code) {
                    message = "Kod zaakceptowany! Zniżka: -\(Int(state.discountPercent * 100))%"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        dismiss()
                    }
                } else {
                    message = state.promoError ?? "Błąd kodu"
                }
            } label: {
                Text("Zastosuj kod")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(DrivoTheme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .background(DrivoTheme.bg.ignoresSafeArea())
    }
}

// MARK: - Payment Sheet Modal
struct PaymentSheetView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) var dismiss

    let methods = [
        ("Apple Pay", "applelogo", "Błyskawiczna autoryzacja Face ID"),
        ("Visa •••• 4242", "creditcard.fill", "Domyślna karta płatnicza"),
        ("BLIK", "qrcode", "Szybka płatność kodem"),
        ("Gotówka", "banknote.fill", "Płatność bezpośrednio u kierowcy")
    ]

    var body: some View {
        VStack(spacing: 18) {
            Capsule()
                .fill(Color.white.opacity(0.3))
                .frame(width: 36, height: 4)
                .padding(.top, 12)

            Text("Wybierz metodę płatności")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 10) {
                ForEach(methods, id: \.0) { name, icon, desc in
                    let isSelected = state.paymentMethod == name
                    Button {
                        HapticsManager.shared.selection()
                        state.paymentMethod = name
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            dismiss()
                        }
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                isSelected ? DrivoTheme.accent.opacity(0.2) : DrivoTheme.card2
                                Image(systemName: icon)
                                    .font(.system(size: 18))
                                    .foregroundColor(isSelected ? DrivoTheme.accent2 : .white)
                            }
                            .frame(width: 44, height: 44)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(name)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                Text(desc)
                                    .font(.system(size: 11))
                                    .foregroundColor(DrivoTheme.muted)
                            }

                            Spacer()

                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(DrivoTheme.green)
                            }
                        }
                        .padding(14)
                        .background(DrivoTheme.card2)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isSelected ? DrivoTheme.accent : DrivoTheme.border, lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .background(DrivoTheme.bg.ignoresSafeArea())
    }
}