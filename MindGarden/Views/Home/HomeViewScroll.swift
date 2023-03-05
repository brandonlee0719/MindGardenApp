//
//  HomeViewScroll.swift
//  MindGarden
//
//  Created by Vishal Davara on 13/04/22.
//

import SwiftUI

struct HomeViewScroll: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var bonusModel: BonusViewModel

    @State var gardenModel: GardenViewModel
    @Binding var showModal : Bool
    @Binding var showMiddleModal : Bool
    @Binding var activeSheet: Sheet?
    @Binding var totalBonuses: Int
    @Binding var attempts : Int
    @Binding var showIAP : Bool
    @State var userModel: UserViewModel
    @State private var isRecent = true
    @State private var isOpen = false

    let width = UIScreen.screenWidth
    let height = UIScreen.screenHeight
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        ZStack(alignment: .top) {
            //MARK: - scroll view
       
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    HStack {
                        Img.topBranch
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.screenWidth * 0.6)
                            .padding(.leading, -20)
                            .offset(x: -20, y: -60)
                        Spacer()
                        HStack(alignment: .bottom, spacing: 16) {
                            HStack(alignment: .bottom, spacing: 7) {
                                Img.streak
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24)
                                Text("\(bonusModel.streakNumber)")
                                    .font(Font.fredoka(.medium, size: 24))
                                    .foregroundColor(Clr.healthSecondary)
                            }.onTapGesture {
                                withAnimation {
                                    Analytics.shared.log(event: .home_tapped_streak)
                                    showModal = true
                                }
                            }                     
                            HStack(alignment: .bottom, spacing: 3) {
                                Img.realTree
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28)
                                Text("\(userModel.plantedTrees.count)")
                                    .font(Font.fredoka(.medium, size: 24))
                                    .foregroundColor(Clr.darkgreen)
                            }.onTapGesture {
                                withAnimation {
                                    Analytics.shared.log(event: .home_tapped_real_tree)
                                    NotificationCenter.default.post(name: Notification.Name("trees"), object: nil)
                                }
                            }
                        }.offset(x: -50, y: -30)
                    }
                    VStack {
 
                    HStack(spacing: -4) {
                        HStack {
                            FloatingMenu(showModal:$showModal, activeSheet: $activeSheet, totalBonuses:$totalBonuses)
                                .edgesIgnoringSafeArea(.all)
                            Spacer()
                        }.zIndex(1)
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(16)
                                .frame(width: width * 0.725, height: 110, alignment: .center)
                                .addBorder(.black, width: 1.5, cornerRadius: 16)
                            Stories()
                                .frame(width: width * 0.7, height: K.isSmall() ? 70 : 95, alignment: .trailing)
                                .padding(30)
                                .offset(y: K.isSmall() ? 3 : 8)
                        }.frame(width: width * 0.7, height: 110, alignment: .center)
                         .padding(.leading, 16)
                    }.frame(width: width * 0.85)
                        .offset(x: width * -0.025)
                    .padding(.top, 40)
                    .zIndex(1)
                    .offset(x: -4)
       
                        HomeViewDashboard(showModal: $showModal, totalBonuses: $bonusModel.totalBonuses, greeting:$userModel.greeting,name:userModel.name , activeSheet:$activeSheet, showIAP: $showIAP, streakNumber: $bonusModel.streakNumber)
                        StartDayView()
                        if !UserDefaults.standard.bool(forKey: "isPro") {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                Analytics.shared.log(event: .pricing_from_home)
                                withAnimation {
                                    fromPage = "home"
                                    viewRouter.currentPage = .pricing
                                }
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .fill(LinearGradient(colors: [Clr.brightGreen.opacity(0.8), Clr.yellow], startPoint: .leading, endPoint: .trailing))
                                        .frame(height: height * 0.1)
                                        .addBorder(.black, width: 1.5, cornerRadius: 16)
                                    HStack(spacing: 10) {
                                        HStack(spacing: 10) {
                                            Img.panda
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: width * 0.15)
                                            (Text("Get Focused.\n")
                                                .font(Font.fredoka(.bold, size: 16))
                                                .foregroundColor(.black)
                                            + Text("Start your free trial").font(Font.fredoka(.medium, size: 16))                                            .foregroundColor(Clr.black2))
                                                .multilineTextAlignment(.leading)
                                        }.frame(width: width * 0.5)
                                        Text("✨ Try Pro")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.fredoka(.semiBold, size: 16))
                                            .padding(8)
                                            .frame(width: width * 0.3, height: height * 0.055)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                            .addBorder(.black, width: 1.5, cornerRadius: 12)
                                            .rightShadow()
                                            .padding(.trailing)
                                    }
                                }.padding(.top, 15)
                                .frame(width: width * 0.85)
                            }.buttonStyle(NeoPress())
                        }
                      
                
                        HStack(spacing: 15) {
                            Text("\(numberOfMeds)")
                                .font(Font.fredoka(.bold, size: 36))
                                .foregroundColor(Clr.black1)
                            Text("people are meditating \nright now")
                                .font(Font.fredoka(.regular, size: 16))
                                .minimumScaleFactor(0.05)
                                .lineLimit(2)
                                .foregroundColor(.gray)
                        }
                        .frame(width: width * 0.8, height: height * 0.06)
                        .padding([.vertical, .top], 30)
                    }.offset(y: -height * 0.125)
            }
            }.frame(height: height + (K.isSmall() ? 125 : 0))
                .padding(.bottom)
        }
    }
}
