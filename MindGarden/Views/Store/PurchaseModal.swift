//
//  PurchaseModal.swift
//  MindGarden
//
//  Created by Dante Kim on 6/14/21.
//

import SwiftUI
import StoreKit

struct PurchaseModal: View {
    @Binding var shown: Bool
    @Binding var showConfirm: Bool
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var bonusModel: BonusViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var meditateModel: MeditationViewModel
//    var img: Img = Image()
    @State private var showProfile: Bool = false


    var body: some View {
        GeometryReader { g in
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center) {
                        HStack(alignment: .center) {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    shown = false
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Clr.darkWhite)
                                        .neoShadow()
                                    Image(systemName: "xmark")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.gray)
                                }.frame(width: 30)
                                 .padding(.leading, 24)
                            }
                            Spacer()
                            Text((userModel.willBuyPlant?.title == "Real Tree" ? "Plant a " : "") + (userModel.willBuyPlant?.title ?? ""))
                                .font(Font.fredoka(.bold, size: userModel.willBuyPlant?.title == "Real Tree" ? 26 : 30))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .foregroundColor(Clr.black1)
                                .padding()
                            Spacer()
                            Image(systemName: "xmark")
                                .font(.system(size: 18))
                                .padding()
                                .opacity(0)
                                .frame(width: 30)
                                .padding(.leading, 24)
                        }.frame(height: 75)
                        if Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) {
                            userModel.willBuyPlant?.coverImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: g.size.width * 0.325, height: g.size.height * 0.225, alignment: .center)
                        } else {
                            if userModel.willBuyPlant?.title == "Real Tree" {
                                Img.treeCover
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: g.size.width * 0.6, alignment: .center)
                                    .cornerRadius(20)
                                    .shadow(radius: 7)
                            } else {
                                userModel.willBuyPlant?.packetImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: g.size.width * 0.4, alignment: .center)
                            }
                            
                        }
                        if userModel.willBuyPlant?.title == "Real Tree" {
                            HStack(spacing: 5) {
                                Text("\(userModel.willBuyPlant?.description ?? "")")
                                    .font(Font.fredoka(.semiBold, size: 18))
                                    .foregroundColor(Clr.black1)
                                + Text(" Learn More")
                                    .font(Font.fredoka(.bold, size: 18))
                                    .foregroundColor(Clr.darkgreen)
                            }.padding(.horizontal, 20)
                            .minimumScaleFactor(0.05)
                            .lineLimit(8)
                            .padding(.vertical, 10)
                            .onTapGesture {
                                guard let url = URL(string: "https://trees.org/our-work/") else { return }
                                UIApplication.shared.open(url)
                            }
                        } else {
                            HStack(spacing: 5) {
                                Text("\(userModel.willBuyPlant?.description ?? "")")
                                    .font(Font.fredoka(.semiBold, size: 20))
                                    .foregroundColor(Clr.black1)
                        
                            }.padding(.horizontal, 40)
                            .minimumScaleFactor(0.05)
                            .lineLimit(8)
                            .padding(.vertical, 10)
                        }
           
                        HStack(spacing: 10){
//                            userModel.willBuyPlant?.title == "Aloe" || userModel.willBuyPlant?.title == "Monstera" ?
//                            Img.pot
//                            :
                            Img.seed
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.width * 0.04)
                                .offset(y: 15)
                            Image(systemName: "arrow.right")
                            userModel.willBuyPlant?.one
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.width * 0.10)
                                .offset(y: 15)
                            Image(systemName: "arrow.right")
                            userModel.willBuyPlant?.two
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.width * 0.13)
                                .offset(y: 10)
                            Image(systemName: "arrow.right")
                            userModel.willBuyPlant?.coverImage
                                .resizable() 
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.width * 0.2)
                        }.padding(.horizontal, 20)
                        if Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) {
                            HStack {
                                switch Plant.badgeDict[(userModel.willBuyPlant ?? Plant.plants[0]).price] {
                                case "✏️ 30 Journal Entries": Text("Total Journal Entries: \(UserDefaults.standard.integer(forKey: "numGrads"))")
                                case "7️⃣ Day Streak": Text("Current Streak: \(bonusModel.streakNumber)")
                                case  "🌸 Meditate on Mar 20": Text("Current Streak: \(bonusModel.streakNumber)")
                                default: Text("")
                                }
                            }
                            .font(Font.fredoka(.semiBold, size: 18))
                            .foregroundColor(Clr.black2)
                            .padding(.bottom, -10)
                        }
                        
                        if userModel.willBuyPlant?.title == "Real Tree" {
                            Text("💰 MindGarden will donate one tree per purchase.")
                                .font(Font.fredoka(.medium, size: 20))
                                .foregroundColor(Clr.lightTextGray)
                                .multilineTextAlignment(.leading)
                                .frame(width: g.size.width * 0.7)
                            Text("🌱 You have planted: \(userModel.plantedTrees.count) trees")
                                .font(Font.fredoka(.semiBold, size: 20))
                                .foregroundColor(Clr.darkgreen)
                                .multilineTextAlignment(.leading)
                                .frame(width: g.size.width * 0.7, alignment: .leading)
                                .padding(.top)
                        }
                        Spacer()
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            if Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) {
                                switch Plant.badgeDict[(userModel.willBuyPlant ?? Plant.plants[0]).price] {
                                case "⭐️ Rate the app":
                                    if !UserDefaults.standard.bool(forKey: "tappedRate") {
                                        Analytics.shared.log(event: .store_tapped_rate_app)
                                        withAnimation {
                                            if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene)
                                                UserDefaults.standard.setValue(true, forKey: "tappedRate")
                                                userModel.buyPlant(unlockedStrawberry: true)
                                            }
                                        }
                                    }
                                case "🌸 Finish Intro Course":
                                    withAnimation {
                                        meditateModel.selectedMeditation = Meditation.allMeditations.first(where: { $0.id == 6 })
                                        viewRouter.currentPage = .middle
                                    }
                                case "💌 Refer a friend":
                                    Analytics.shared.log(event: .store_tapped_refer_friend)
                                    withAnimation {
                                        tappedRefer = true
                                        showProfile = true
                                    }
                                case "👨‍🌾 Become a pro user":
                                    if !UserDefaults.standard.bool(forKey: "isPro") {
                                        withAnimation {
                                            Analytics.shared.log(event: .pricing_from_store)
                                            fromPage = "store"
                                            viewRouter.currentPage = .pricing
                                        }
                                    }
                                case "👨‍👩‍👦‍👦 Join our Reddit":
                                    if let url = URL(string: "https://www.reddit.com/r/MindGarden/") {
                                        UIApplication.shared.open(url)
                                    }
                                    Analytics.shared.log(event: .store_tapped_discord)
                                    if !UserDefaults.standard.bool(forKey: "reddit") {
                                        UserDefaults.standard.setValue(true, forKey: "reddit")
                                    }
                                case "✏️ 30 Journal Entries":
                                    withAnimation {
                                        viewRouter.previousPage = .shop
                                        viewRouter.currentPage = .journal
                                    }
                                default:
                                    withAnimation {
                                        viewRouter.currentPage = .learn
                                    }
                                }
                            } else {
                                Analytics.shared.log(event: .store_tapped_purchase_modal_buy)
                                if userModel.coins >= userModel.willBuyPlant?.price ?? 0 {
                                    withAnimation {
                                        showConfirm = true
                                    }
                                }
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.yellow)
                                .frame(width: g.size.width * 0.75, height: g.size.height * 0.05)
                                .neoShadow()
                                .addBorder(.black, width: 1.5, cornerRadius: 30)
                                .padding()
                                .overlay(HStack{
                                    if Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) {
                                        Text("\(Plant.badgeDict[(userModel.willBuyPlant ?? Plant.plants[0]).price] ?? "" )")
                                            .font(Font.fredoka(.bold, size: 18))
                                            .foregroundColor(Clr.black2)
                                    } else {
                                        Text("Purchase")
                                            .font(Font.fredoka(.bold, size: Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) ? 18 : 20))
                                            .foregroundColor( Clr.black2)
                                        Img.coin
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: g.size.width * 0.05, height: g.size.width * 0.05)
                                            .shadow(radius: 15)
                                        Text("\(userModel.willBuyPlant?.price ?? 0)")
                                            .font(Font.fredoka(.medium, size: Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) ? 18 : 20))
                                            .foregroundColor( Clr.black2)
                                    }
                                })
                        }
                    }.frame(width: g.size.width * 0.85, height: g.size.height * (userModel.willBuyPlant?.title == "Real Tree" ? 0.85 : 0.80), alignment: .top)
                    .background(Clr.darkWhite)
                    .cornerRadius(32)
                    .padding(.bottom)
                    .buttonStyle(NeoPress())
                    Spacer()
                }.cornerRadius(20)
                Spacer()
            }
        }.fullScreenCover(isPresented: $showProfile) {
            ProfileScene(profileModel: profileModel)
                .environmentObject(userModel)
                .environmentObject(gardenModel)
                .environmentObject(viewRouter)
        }
    }
}

struct PurchaseModal_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            PurchaseModal(shown: .constant(true), showConfirm: .constant(false))
        }
    }
}
