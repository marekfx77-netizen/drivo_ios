import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var state: AppState
    struct Trip { let date,price,from,to,type,time,dist,status,statusHex: String }
    let trips = [
        Trip(date:"Dzis, 18:34",price:"12.50 zl",from:"Plac Defilad 1",to:"Zlote Tarasy",type:"Eco",time:"8 min",dist:"2.1 km",status:"Zakonczone",statusHex:"00D68F"),
        Trip(date:"Wczoraj, 09:12",price:"18.90 zl",from:"Stacja Centralna",to:"Lotnisko Chopina",type:"Comfort",time:"22 min",dist:"12.4 km",status:"Zakonczone",statusHex:"00D68F"),
        Trip(date:"17 wrz, 20:45",price:"28.00 zl",from:"Stare Miasto",to:"Ursynow",type:"XL",time:"35 min",dist:"18.2 km",status:"Zakonczone",statusHex:"00D68F"),
        Trip(date:"15 wrz, 14:20",price:"9.80 zl",from:"Centrum Kopernik",to:"Plac Defilad 1",type:"Eco",time:"11 min",dist:"3.7 km",status:"Anulowany",statusHex:"FF4757"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Historia").font(.system(size: 28, weight: .heavy)).foregroundColor(.white)
                Spacer()
            }.padding(.horizontal, 18).padding(.top, 64).padding(.bottom, 14).background(DrivoTheme.card)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(trips.indices, id: \.self) { i in
                        let t = trips[i]
                        VStack(spacing: 0) {
                            HStack {
                                Text(t.date).font(.system(size: 12)).foregroundColor(DrivoTheme.muted)
                                Spacer()
                                Text(t.price).font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                            }.padding(.bottom, 10)

                            HStack(spacing: 8) {
                                VStack(spacing: 3) {
                                    Circle().fill(DrivoTheme.green).frame(width: 8, height: 8)
                                    Rectangle().fill(DrivoTheme.border).frame(width: 1, height: 12)
                                    Circle().fill(DrivoTheme.accent).frame(width: 8, height: 8)
                                }
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(t.from).font(.system(size: 13)).foregroundColor(.white)
                                    Text(t.to).font(.system(size: 13)).foregroundColor(.white)
                                }
                                Spacer()
                            }

                            HStack(spacing: 8) {
                                ForEach([t.type, t.time, t.dist], id: \.self) { c in
                                    Text(c).font(.system(size: 11)).foregroundColor(DrivoTheme.muted)
                                        .padding(.horizontal, 10).padding(.vertical, 5)
                                        .background(DrivoTheme.pill).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                                Spacer()
                                Text(t.status).font(.system(size: 11, weight: .semibold)).foregroundColor(Color(hex: t.statusHex))
                            }.padding(.top, 10)
                        }
                        .padding(14).background(DrivoTheme.card2)
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(DrivoTheme.border, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }.padding(.horizontal, 18).padding(.vertical, 12).padding(.bottom, 60)
            }.background(DrivoTheme.bg)

            BottomNavView(selectedTab: .constant(2)).environmentObject(state)
        }.background(DrivoTheme.bg).ignoresSafeArea(edges: .top)
    }
}