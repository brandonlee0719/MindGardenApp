//
//  BonusModal.swift
//  MindGarden
//
//  Created by Dante Kim on 6/26/21.
//

import SwiftUI

struct BonusModal: View {
    @ObservedObject var bonusModel: BonusViewModel
    @Binding var shown: Bool
    @Binding var coins: Int
    @State private var showCoins: Bool = false
    @State private var streakCoins: Bool = false
    
    private enum animationPlace {
        case button1, button2, button3
    }
    
    @State private var place : animationPlace = .button1
    
    var body: some View {
        GeometryReader { g in
        ZStack {
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        ZStack {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    shown = false
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Clr.darkWhite)
                                    Image(systemName: "xmark")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.gray)
                                }.frame(width: 30)
                            }.position(x: 30, y: 35)
                            .buttonStyle(NeoPress())
                            HStack(alignment: .center) {
                                Text("Daily Bonus")
                                    .font(Font.fredoka(.bold, size: 28))
                                    .foregroundColor(Clr.black1)
                                    .padding()
                            }.padding(.bottom, -5)

                        }.frame(height: g.size.height * 0.08)
                        ZStack {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                if bonusModel.dailyBonus == "" || (bonusModel.formatter.date(from: bonusModel.dailyBonus) ?? Date()) - Date() < 0 {
                                    place = .button1
                                    playCoinAnimation()
                                    Analytics.shared.log(event: .home_claim_daily)
                                    bonusModel.saveDaily(plusCoins: 30)
                                    coins += 30
                                    bonusModel.totalBonuses -= 1
                                }

                            } label: {
                                BonusBox(bonusModel: bonusModel, width: g.size.width, height: g.size.height, video: false)
                            }.padding(.bottom, 10)
                                .buttonStyle(NeumorphicPress())
                        }
                        Spacer()
                        if !K.isIpod() {
                            Text("Streaks")
                                .font(Font.fredoka(.bold, size: 28))
                                .foregroundColor(Clr.black1)
                                .frame(alignment: .center)
                                .padding(.bottom, 5)
                        }
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(16)
                                .neoShadow()
                            HStack(spacing: 0) {
                                VStack {
                                    Img.streak
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .neoShadow()
                                    Text("\(bonusModel.streakNumber) ").bold().foregroundColor(Clr.black1) + Text(bonusModel.streakNumber == 1 ? "day" : "days").foregroundColor(Clr.black1)
                                }.frame(width: g.size.width * 0.15)
                                .padding()
                                VStack(spacing: -5) {
                                    Text("7 days")
                                        .font(Font.fredoka(.bold, size: 20))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.center)
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        if bonusModel.sevenDayProgress >= 1.0 {
                                            place = .button2
                                            playCoinAnimation()
                                            streakCoins = true
                                            Analytics.shared.log(event: .home_claim_seven)
                                            bonusModel.saveSeven()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                self.streakCoins.toggle()
                                            }
                                        }
                                    } label: {
                                        ProgressBar(width: g.size.width, height: g.size.height, weekly: true, progress: bonusModel.sevenDayProgress)
                                    }.buttonStyle(BonusPress())

                                    Text("30 days")
                                        .font(Font.fredoka(.bold, size: 20))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.center)
                                        .padding(.top)
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        if bonusModel.thirtyDayProgress >= 1.0 {
                                            place = .button3
                                            playCoinAnimation()
                                            self.streakCoins = true
                                            Analytics.shared.log(event: .home_claim_thirty)
                                            bonusModel.saveThirty()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                self.streakCoins.toggle()
                                            }
                                        }

                                    } label: {
                                        ProgressBar(width: g.size.width, height: g.size.height, weekly: false, progress: bonusModel.thirtyDayProgress)
                                    }.buttonStyle(BonusPress())
                                }
                                .padding()
                            }.padding(.leading)
                        }.frame(width: g.size.width * 0.65, height: g.size.height * 0.25, alignment: .center)
                        Spacer()
                    }
                    .frame(width: g.size.width * 0.85, height: g.size.height * (K.hasNotch() ? 0.55 : 0.6), alignment: .center)
                    .background(Clr.darkWhite)
                    .cornerRadius(32)
                    Spacer()
                } 
                Spacer()
            }
            if showCoins {
                LottieAnimationView(filename: "coins", loopMode: .playOnce)
                .frame(height: 300)
                .offset(x: place == .button1 ? 0 : 50 )
                .offset(y: place == .button1 ? -130 : (place == .button2 ? 50 : 110))
            }
        }
        }
    }
    
    private func playCoinAnimation(){
        showCoins = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showCoins = false
        }
    }
    
    struct ProgressBar: View {
        let width, height: CGFloat
        let weekly: Bool
        let progress: Double

        var body: some View {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(width: width/3 , height: height/25)
                    .foregroundColor(Clr.darkWhite)
                Rectangle()
                    .frame(width: min((CGFloat(progress)*width)/3, width/3), height: height/25)
                    .cornerRadius(50)
                    .foregroundColor(Clr.yellow)
                    .animation(.linear)
                HStack {
                    if progress >= 1.0 && !K.isIpod() {
                        Text("CLAIM!")
                            .foregroundColor(Clr.black1)
                            .font(Font.fredoka(.bold, size: 16))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    } else {
                        Spacer()
                    }
                    
                    Img.coin
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.06)
                    Text(weekly ? "300" : "1000")
                        .foregroundColor(Clr.black1)
                        .font(Font.fredoka(.semiBold, size: 16))
                    Spacer()
                }.padding()
                .frame(alignment: .center)
            }
        }
    }

    struct BonusBox: View {
        @ObservedObject var bonusModel: BonusViewModel
        @State private var dailyCooldown = ""
        let width, height: CGFloat
        let video: Bool
        @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        var body: some View {
            ZStack(alignment: .center){
                Rectangle()
                    .fill(Clr.darkWhite)
                    .frame(width: width * 0.65, height: height * 0.07)
                    .cornerRadius(16)
                    .neoShadow()
                HStack {
                    if bonusModel.dailyBonus == "" || (bonusModel.formatter.date(from: bonusModel.dailyBonus) ?? Date()) - Date() < 0 {
                        Img.coin
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.07)
                        Text("30")
                            .foregroundColor(Clr.black1)
                            .font(Font.fredoka(.semiBold, size: 24))
                            .minimumScaleFactor(0.5)
                            .padding(.trailing)
                        Capsule()
                            .fill(Clr.brightGreen)
                            .overlay(
                                Group {
                                    if video {
                                        Image(systemName: "play.fill")
                                            .foregroundColor(.white)
                                    } else {
                                        Text("CLAIM")
                                            .font(Font.fredoka(.bold, size: 20))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                            )
                            .frame(width: width * 0.3, height: height * 0.04)
                            .padding(.leading)
                            .neoShadow()
                    } else {
                        Text("\(bonusModel.dailyInterval.stringFromTimeInterval())")
                            .foregroundColor(Clr.darkgreen)
                            .font(Font.fredoka(.bold, size: 30))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .padding(.trailing)
                    }

                }.padding()
            }
            .onReceive(timer) { time in
                if bonusModel.dailyInterval > 0 {
                    bonusModel.dailyInterval -= 1
                }
            }
        }
    }
}

struct BonusModal_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            BonusModal(bonusModel: BonusViewModel(userModel: UserViewModel(), gardenModel: GardenViewModel()), shown: .constant(true), coins: .constant(0))
        }
    }
}


