import SwiftUI

struct SearchDestination: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let category: String
    let distanceKm: Double
    let timeMin: Int
}

struct SearchView: View {
    @EnvironmentObject var state: AppState
    @State private var query = ""
    @State private var selectedCategory = "Wszystko"

    let categories = ["Wszystko", "Centra handlowe", "Lotniska", "Dworce", "Hotele", "Kawiarnie"]

    let allPlaces: [SearchDestination] = [
        SearchDestination(name: "Złote Tarasy", address: "ul. Złota 59, Warszawa", category: "Centra handlowe", distanceKm: 2.1, timeMin: 8),
        SearchDestination(name: "Lotnisko Chopina", address: "ul. Żwirki i Wigury 1, Warszawa", category: "Lotniska", distanceKm: 12.4, timeMin: 24),
        SearchDestination(name: "Dworzec Centralny", address: "Al. Jerozolimskie 54, Warszawa", category: "Dworce", distanceKm: 1.8, timeMin: 6),
        SearchDestination(name: "Centrum Nauki Kopernik", address: "ul. Wybrzeże Kościuszkowskie 20, Warszawa", category: "Centra handlowe", distanceKm: 3.7, timeMin: 11),
        SearchDestination(name: "Stare Miasto", address: "Rynek Starego Miasta, Warszawa", category: "Wszystko", distanceKm: 5.2, timeMin: 15),
        SearchDestination(name: "Westfield Arkadia", address: "Al. Jana Pawła II 82, Warszawa", category: "Centra handlowe", distanceKm: 4.8, timeMin: 14),
        SearchDestination(name: "Hotel Marriott", address: "Al. Jerozolimskie 65/79, Warszawa", category: "Hotele", distanceKm: 1.9, timeMin: 7),
        SearchDestination(name: "Dworzec Zachodni", address: "Al. Jerozolimskie 144, Warszawa", category: "Dworce", distanceKm: 4.1, timeMin: 12),
        SearchDestination(name: "Łazienki Królewskie", address: "ul. Agrykola 1, Warszawa", category: "Wszystko", distanceKm: 4.3, timeMin: 13),
        SearchDestination(name: "Starbucks Nowy Świat", address: "ul. Nowy Świat 64, Warszawa", category: "Kawiarnie", distanceKm: 2.3, timeMin: 9)
    ]

    var filteredPlaces: [SearchDestination] {
        allPlaces.filter { place in
            let matchesCategory = (selectedCategory == "Wszystko" || place.category == selectedCategory)
            let matchesQuery = query.isEmpty ||
                place.name.localizedCaseInsensitiveContains(query) ||
                place.address.localizedCaseInsensitiveContains(query)
            return matchesCategory && matchesQuery
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // HEADER & INPUT FIELDS
            VStack(spacing: 12) {
                // Back Button & Title
                HStack {
                    Button {
                        HapticsManager.shared.impact(.light)
                        state.screen = .home
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                            Text("Wróć")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(DrivoTheme.accent2)
                    }

                    Spacer()

                    Text("Wyszukaj trasę")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    // Invisible balance element for centered title
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Wróć")
                    }
                    .opacity(0)
                }
                .padding(.top, 54)

                // Pickup Field
                HStack(spacing: 12) {
                    Circle()
                        .fill(DrivoTheme.green)
                        .frame(width: 10, height: 10)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Miejsce odbioru")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(DrivoTheme.muted)
                        Text(state.pickupAddress)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                    Spacer()
                }
                .padding(12)
                .background(DrivoTheme.card2)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(DrivoTheme.border, lineWidth: 1))

                // Destination Field
                HStack(spacing: 12) {
                    Circle()
                        .fill(DrivoTheme.accent)
                        .frame(width: 10, height: 10)

                    TextField("Gdzie chcesz jechać?", text: $query)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .accentColor(DrivoTheme.accent)

                    if !query.isEmpty {
                        Button {
                            HapticsManager.shared.impact(.light)
                            query = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(DrivoTheme.muted)
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(14)
                .background(DrivoTheme.card2)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(DrivoTheme.accent, lineWidth: 1.5))
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 14)
            .background(DrivoTheme.card)

            // CATEGORIES BAR
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { cat in
                        let isSelected = selectedCategory == cat
                        Button {
                            HapticsManager.shared.selection()
                            selectedCategory = cat
                        } label: {
                            Text(cat)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(isSelected ? .white : DrivoTheme.muted)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(isSelected ? DrivoTheme.accent : DrivoTheme.card2)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(isSelected ? DrivoTheme.accent2 : DrivoTheme.border, lineWidth: 1))
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
            }
            .background(DrivoTheme.bg)

            // FILTERED DESTINATIONS LIST
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    if filteredPlaces.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "mappin.slash")
                                .font(.system(size: 40))
                                .foregroundColor(DrivoTheme.muted)
                            Text("Brak wyników dla \"\(query)\"")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Text("Spróbuj wpisać inną nazwę ulicy lub miejsca")
                                .font(.system(size: 12))
                                .foregroundColor(DrivoTheme.muted)
                        }
                        .padding(.top, 60)
                    } else {
                        ForEach(filteredPlaces) { place in
                            Button {
                                HapticsManager.shared.impact(.medium)
                                state.destinationName = place.name
                                state.destinationAddress = place.address
                                state.tripDistanceKm = place.distanceKm
                                state.tripDurationMinutes = place.timeMin
                                state.screen = .ride
                            } label: {
                                HStack(spacing: 14) {
                                    ZStack {
                                        DrivoTheme.card2
                                        Image(systemName: "mappin.and.ellipse")
                                            .foregroundColor(DrivoTheme.accent2)
                                            .font(.system(size: 18))
                                    }
                                    .frame(width: 44, height: 44)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(DrivoTheme.border, lineWidth: 1))

                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(place.name)
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.white)
                                        Text(place.address)
                                            .font(.system(size: 12))
                                            .foregroundColor(DrivoTheme.muted)
                                            .lineLimit(1)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(String(format: "%.1f km", place.distanceKm))
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(DrivoTheme.accent2)
                                        Text("\(place.timeMin) min")
                                            .font(.system(size: 11))
                                            .foregroundColor(DrivoTheme.muted)
                                    }
                                }
                                .padding(.horizontal, 18)
                                .padding(.vertical, 13)
                            }
                            Divider().background(DrivoTheme.border).padding(.leading, 76)
                        }
                    }
                }
                .padding(.bottom, 80)
            }
            .background(DrivoTheme.bg)

            BottomNavView(selectedTab: .constant(1))
                .environmentObject(state)
        }
        .background(DrivoTheme.bg)
        .ignoresSafeArea(edges: .top)
    }
}
