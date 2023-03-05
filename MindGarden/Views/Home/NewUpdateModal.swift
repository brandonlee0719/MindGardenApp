//
//  NewUpdateModal.swift
//  MindGarden
//
//  Created by Dante Kim on 10/4/21.
//

import SwiftUI
var fiftyOff = false

struct NewUpdateModal: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var shown: Bool
    @Binding var showSearch: Bool

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Spacer()
//                            Img.mainIcon
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: g.size.height * 0.1)
                            Text("💎 You've Earned a 50% Pro Chest")
                                .multilineTextAlignment(.center) 
                                .font(Font.fredoka(.bold, size: 24))
                                .foregroundColor(Clr.black2)
                                .frame(height: g.size.height * 0.1)
                            Spacer()
                        }.padding([.horizontal, .top])
                         .frame(width: g.size.width * 0.85 * 0.9)
                    
                        Img.greenChest
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(26)
                            .frame(width:  g.size.width * 0.85 * 0.5)
                            .padding()
                        HStack {
                            Text("You've been randomly selected to earn a ONE time 75% off of Pro!")
                        }.multilineTextAlignment(.center)
                        .font(Font.fredoka(.medium, size: 20))
                        .foregroundColor(Clr.black2)
                        .frame(width: g.size.width * 0.85 * 0.8)
                        .padding(.bottom, 10)
                        .padding(.top)
                        HStack {
                            Text("📈 Pro users are") + Text(" 4x more likely ").bold() + Text("to stick with meditation.")
                        }.multilineTextAlignment(.center)
                        .font(Font.fredoka(.medium, size: 20))
                        .foregroundColor(Clr.black2)
                        .frame(width: g.size.width * 0.85 * 0.8)
                        .padding(.bottom, 10)
                        .padding(.top)
                        HStack {
                            Text("")
                        }.multilineTextAlignment(.center)
                        .font(Font.fredoka(.medium, size: 20))
                        .foregroundColor(Clr.black2)
                        .frame(width: g.size.width * 0.85 * 0.8)
                        .padding(.bottom, 10)
                        .padding(.top)
//                        Button {
//                            withAnimation {
//                                UserDefaults.standard.setValue(true, forKey: "1.1Update")
//                                viewRouter.currentPage = .profile
//                            }
//                        } label: {
//                            HStack {
//                                Text("💌 ") + Text("Refer a friend ").bold().underline().foregroundColor(.blue) + Text("or rate the app for ") + Text("two free weeks")
//                                    .foregroundColor(Clr.brightGreen)
//                                    .bold()
//                                + Text(" of pro!")
//                            }.multilineTextAlignment(.leading)
//                                .font(Font.fredoka(.regular, size: 20))
//                        }.padding(.top, 10)
//                        .foregroundColor(Clr.black2)
//                        .frame(width: g.size.width * 0.85 * 0.8, alignment: .leading)


//                        Button {
//                            guard let url = URL(string: "https://www.reddit.com/r/MindGarden/") else { return }
//                            UIApplication.shared.open(url)
//                        } label: {
//                            HStack {
//                                Text("👨‍🌾 Join the community to chat, request features, give feedback and stay updated!")
//                                    .foregroundColor(Clr.black2)
//                                +
//                                Text(" Join Reddit")
//                                    .bold()
//                                    .foregroundColor(Clr.brightGreen)
//                            } .multilineTextAlignment(.leading)
//                        }
//                        .frame(width: g.size.width * 0.85 * 0.8, alignment: .leading)
//                        .padding(.bottom, 10)

//                        Text("- 🥳 Dante (Founder of MindGarden)")
//                            .frame(width: g.size.width * 0.85 * 0.8, alignment: .trailing)
//                            .padding(.bottom, 10)
//                            .padding(.top, 5)
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                UserDefaults.standard.setValue(true, forKey: "14DayModal")
                                fromInfluencer = ""
                                fiftyOff = true
                                viewRouter.currentPage = .pricing
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.darkgreen)
                                .overlay(
                                    Text("Claim my 75% off")
                                        .font(Font.fredoka(.bold, size: 20))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                )
                                .frame(width: g.size.width * 0.7, height: 45)
                        }.buttonStyle(NeumorphicPress())
                        Button {
                            Analytics.shared.log(event: .no_thanks_50)
                            withAnimation {
                                UserDefaults.standard.setValue(true, forKey: "14DayModal")
                                shown = false
                            }
                        } label: {
                                Text("No Thanks")
                                    .foregroundColor(Color.gray)
                                    .font(Font.fredoka(.regular, size: 20))
                        }
                        .padding(20)
                    }
                    .font(Font.fredoka(.regular, size: 18))
                    .frame(width: g.size.width * 0.85, height: g.size.height * 0.7, alignment: .center)
                    .minimumScaleFactor(0.05)
                    .background(Clr.darkWhite)
                    .neoShadow()
                    .cornerRadius(12)
                    .offset(y: -50)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct NewUpdateModal_Previews: PreviewProvider {
    static var previews: some View {
        NewUpdateModal(shown: .constant(true), showSearch: .constant(false))
    }
}
