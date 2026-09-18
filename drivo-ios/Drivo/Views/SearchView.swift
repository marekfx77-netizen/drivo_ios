import SwiftUI

struct SearchView: View {
    @EnvironmentObject var state: AppState
    @State private var query = ""
    let suggestions = [
        ("Zlote Tarasy","Al. Jana Pawla II 15, Warszawa","2.1 km"),
        ("Lotnisko Chopina","ul. Zwirki i Wigury 1, Warszawa","12.4 km"),
        ("Centrum Nauki Kopernik","ul. Wybrzeze Kosciuszkowskie 20","3.7 km"),
        ("Dworzec Centralny","Al. Jerozolimskie 54, Warszawa","1.8 km"),
        ("Stare Miasto","Rynek Starego Miasta, Warszawa","5.2 km")
    ]
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                HStack {
                    Button { state.screen = .home } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left").font(.system(size: 18, weight: .semibold))
                            Text("Wstecz").font(.system(size: 16, weight: .medium))
                        }.foregroundColor(DrivoTheme.accent2)
                    }
                    Spacer()
                }.padding(.top, 8)

                HStack(spacing: 10) {
                    Image(systemName: "location.circle.fill").foregroundColor(DrivoTheme.accent)
                    Text("Plac Defilad 1, Warszawa").font(.system(size: 15)).foregroundColor(.white)
                    Spacer()
                }
                .padding(14).background(DrivoTheme.card2)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(DrivoTheme.accent, lineWidth: 1.5))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                HStack(spacing: 10) {
                    Image(systemName: "mappin.circle.fill").foregroundColor(DrivoTheme.accent)
                    TextField("Dokad jedziesz?", text: $query).font(.system(size: 15)).foregroundColor(.white).accentColor(DrivoTheme.accent)
                }
                .padding(14).background(DrivoTheme.card2)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(DrivoTheme.border, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(.horizontal, 18).padding(.bottom, 14).padding(.top, 60).background(DrivoTheme.card)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["Wszystko","Lotniska","Centra handlowe","Hotele"], id: \.self) { c in
                        Text(c).font(.system(size: 12, weight: .semibold))
                            .foregroundColor(c == "Wszystko" ? DrivoTheme.accent2 : DrivoTheme.muted)
                            .padding(.horizontal, 14).padding(.vertical, 8)
                            .background(c == "Wszystko" ? DrivoTheme.accent.opacity(0.2) : DrivoTheme.card)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(c == "Wszystko" ? DrivoTheme.accent : DrivoTheme.border, lineWidth: 1))
                            .clipShape(Capsule())
                    }
                }.padding(.horizontal, 18).padding(.vertical, 10)
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(suggestions, id: \.0) { name, addr, dist in
                        Button { state.screen = .ride } label: {
                            HStack(spacing: 12) {
                                ZStack {
                                    DrivoTheme.card
                                    Image(systemName: "mappin.and.ellipse").foregroundColor(DrivoTheme.muted).font(.system(size: 18))
                                }
                                .frame(width: 46, height: 46).clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(name).font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                                    Text(addr).font(.system(size: 11)).foregroundColor(DrivoTheme.muted)
                                }
                                Spacer()
                                Text(dist).font(.system(size: 12, weight: .semibold)).foregroundColor(DrivoTheme.accent2)
                            }.padding(.vertical, 13)
                        }
                        Divider().background(DrivoTheme.border)
                    }
                }.padding(.horizontal, 18)
            }
            BottomNavView(selectedTab: .constant(1)).environmentObject(state)
        }.background(DrivoTheme.bg).ignoresSafeArea(edges: .top)
    }
}
