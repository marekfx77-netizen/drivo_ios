import SwiftUI
import MapKit

struct RideOption: Identifiable {
    let id: String; let name: String; let sub: String; let eta: String
    let price: String; let originalPrice: String?; let icon: String; let badge: String?
}

struct RideSelectView: View {
    @EnvironmentObject var state: AppState
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122),
        span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
    )
    @State private var mapType: MKMapType = .standard

    let rides: [RideOption] = [
        RideOption(id:"eco",name:"Drivo Eco",sub:"Standardowy · Do 3 osob",eta:"Za 2 min · Najblizej",price:"12.50 zl",originalPrice:nil,icon:"car.fill",badge:nil),
        RideOption(id:"comfort",name:"Drivo Comfort",sub:"Premium · Klimatyzacja · 4 osoby",eta:"Za 4 min",price:"18.90 zl",originalPrice:"21.00 zl",icon:"car.2.fill",badge:"POPULAR"),
        RideOption(id:"xl",name:"Drivo XL",sub:"Van / MPV · Do 6 osob",eta:"Za 6 min",price:"28.00 zl",originalPrice:nil,icon:"box.truck.fill",badge:nil),
    ]

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                DrivoMapView(region: $region, mapType: $mapType).frame(height: 240)
                Button { state.screen = .search } label: {
                    Image(systemName: "chevron.left").font(.system(size: 18, weight: .semibold)).foregroundColor(.white)
                        .frame(width: 40, height: 40).background(.ultraThinMaterial).clipShape(Circle())
                        .overlay(Circle().stroke(DrivoTheme.border, lineWidth: 1))
                }.padding(.top, 64).padding(.leading, 16)
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.2)).frame(width: 36, height: 4).padding(.top, 14).padding(.bottom, 2)

                    // Route
                    HStack(spacing: 12) {
                        VStack(spacing: 3) {
                            Circle().fill(DrivoTheme.green).frame(width: 10, height: 10)
                            Rectangle().fill(DrivoTheme.border).frame(width: 2, height: 22)
                            Circle().fill(DrivoTheme.accent).frame(width: 10, height: 10)
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Plac Defilad 1, Warszawa").font(.system(size: 13)).foregroundColor(DrivoTheme.muted)
                            Text("Zlote Tarasy, Warszawa").font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 18).padding(.vertical, 14)
                    Divider().background(DrivoTheme.border)

                    // Meta
                    HStack(spacing: 10) {
                        MChip(icon: "clock", label: "8 min jazdy")
                        MChip(icon: "arrow.left.and.right", label: "2.1 km")
                        MChip(icon: "bolt.fill", label: "2 min odbioru")
                    }.padding(.horizontal, 18).padding(.vertical, 10)
                    Divider().background(DrivoTheme.border)

                    // Promo code
                    HStack(spacing: 10) {
                        Text("% KOD").font(.system(size: 12, weight: .bold)).foregroundColor(DrivoTheme.green)
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(DrivoTheme.green.opacity(0.1))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(DrivoTheme.green.opacity(0.3), lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        Text("Dodaj kod promocyjny").font(.system(size: 14, weight: .medium)).foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right").font(.system(size: 14, weight: .semibold)).foregroundColor(Color.white.opacity(0.3))
                    }.padding(.horizontal, 18).padding(.vertical, 11)
                    Divider().background(DrivoTheme.border)

                    // Ride options
                    VStack(spacing: 10) {
                        ForEach(rides) { ride in
                            RORow(ride: ride, selected: state.selectedRide == ride.id) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { state.selectedRide = ride.id }
                            }
                        }
                    }.padding(.horizontal, 18).padding(.top, 12)

                    // Payment
                    HStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "creditcard").font(.system(size: 16))
                            Text("Gotowka").font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.white).padding(.horizontal, 12).padding(.vertical, 7)
                        .background(DrivoTheme.card2).overlay(RoundedRectangle(cornerRadius: 10).stroke(DrivoTheme.border, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        Text("Zmien").font(.system(size: 13, weight: .semibold)).foregroundColor(DrivoTheme.accent2)
                    }.padding(.horizontal, 18).padding(.vertical, 10)

                    Button { state.screen = .tracking } label: {
                        Text("Zamow przejazd").font(.system(size: 17, weight: .bold)).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 18)
                            .background(LinearGradient(colors: [DrivoTheme.accent, Color(hex: "5B8DEF")], startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: DrivoTheme.accent.opacity(0.4), radius: 20, y: 8)
                    }.padding(.horizontal, 18).padding(.bottom, 30)
                }
            }.background(DrivoTheme.card)
        }.background(DrivoTheme.bg).ignoresSafeArea(edges: .top)
    }
}

struct MChip: View {
    let icon: String; let label: String
    var body: some View {
        HStack(spacing: 5) { Image(systemName: icon).font(.system(size: 11)); Text(label).font(.system(size: 12)) }
            .foregroundColor(DrivoTheme.muted).padding(.horizontal, 10).padding(.vertical, 7)
            .background(DrivoTheme.pill).clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct RORow: View {
    let ride: RideOption; let selected: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    (selected ? DrivoTheme.accent.opacity(0.15) : DrivoTheme.card)
                    Image(systemName: ride.icon).font(.system(size: 26)).foregroundColor(selected ? DrivoTheme.accent : Color.white.opacity(0.7))
                }
                .frame(width: 72, height: 46).clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(ride.name).font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                        if let b = ride.badge {
                            Text(b).font(.system(size: 9, weight: .bold)).foregroundColor(.white)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(LinearGradient(colors: [DrivoTheme.accent, Color(hex: "5B8DEF")], startPoint: .leading, endPoint: .trailing))
                                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        }
                    }
                    Text(ride.sub).font(.system(size: 11)).foregroundColor(DrivoTheme.muted)
                    HStack(spacing: 4) { Image(systemName: "clock").font(.system(size: 9)); Text(ride.eta).font(.system(size: 11, weight: .semibold)) }.foregroundColor(DrivoTheme.green)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    if let o = ride.originalPrice { Text(o).font(.system(size: 11)).foregroundColor(DrivoTheme.muted).strikethrough() }
                    Text(ride.price).font(.system(size: 18, weight: .heavy)).foregroundColor(.white)
                }
            }
            .padding(14).background(selected ? DrivoTheme.accent.opacity(0.08) : DrivoTheme.card2)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(selected ? DrivoTheme.accent : DrivoTheme.border, lineWidth: selected ? 1.5 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }.buttonStyle(.plain)
    }
}