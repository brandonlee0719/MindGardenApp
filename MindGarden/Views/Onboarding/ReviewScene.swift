//
//  ReviewScene.swift
//  MindGarden
//
//  Created by Dante Kim on 12/6/21.
//

import SwiftUI
import Paywall
import Amplitude
import OneSignal

var tappedTurnOn = false
struct ReviewScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var experience: (Image, String) =  (Img.moon, "")
    @State private var aim = (Img.redTulips3, "")
    @State private var aim2 = (Img.redTulips3, "")
    @State private var aim3 = (Img.redTulips3, "")
    @State private var notifications = ""
    @State private var showLoading = false
    @State private var showPaywall = false
    var displayedTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }
    
    var body: some View {
        ZStack {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack(spacing: 5) {
                        HStack {
                            if !K.isSmall() && K.hasNotch() {
                                Img.topBranch
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.screenWidth * 0.6)
                                    .padding(.leading, -20)
                                    .offset(y: -10)
                            }
                            Spacer()
                        }.edgesIgnoringSafeArea(.all)
                        Spacer()
                        Text("So, to recap \(UserDefaults.standard.string( forKey: "name") ?? "")")
                            .font(Font.fredoka(.bold, size: 30))
                            .foregroundColor(Clr.black2)
                            .padding()
                            .lineLimit(2)
                            .minimumScaleFactor(0.05)
                            .frame(width: width * 0.75)
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(14)
                                .frame(width: width * 0.75, height: width * (arr.count == 1 ? 0.22 : arr.count == 2 ? 0.4 : arr.count == 3 ? 0.55 : 0.5))
                                .neoShadow()
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(zip(arr.indices, arr)), id: \.0) { idx, item in
                                    HStack {
                                        ReasonItem.getImage(str: item)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: width * 0.125, height: width * 0.125)
                                            .padding(10)
                                        VStack(alignment: .leading) {
                                            if idx == 0 {
                                                Text("Your aim is to")
                                                    .foregroundColor(.gray)
                                                    .font(Font.fredoka(.regular, size: 20))
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.05)
                                            }
                                            Text(item == "Managing Stress & Anxiety" ? " stress/anxiety" : item)
                                                .foregroundColor(Clr.black1)
                                                .font(Font.fredoka(.semiBold, size: 20))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                        }.frame(width: width * 0.5, alignment: .leading)
                                    }
                                }
                            }
                        }
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(14)
                                .frame(width: width * 0.75, height: width * 0.22)
                                .neoShadow()
                            HStack(spacing: -10) {
                                experience.0
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.125, height: width * 0.125, alignment: .leading)
                                    .padding()
                                VStack(alignment: .leading) {
                                    Text("Your experience level")
                                        .foregroundColor(.gray)
                                        .font(Font.fredoka(.regular, size: 16))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                    Text("\(experience.1)")
                                        .foregroundColor(Clr.black1)
                                        .font(Font.fredoka(.semiBold, size: 20))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                }.frame(width: width * 0.5, alignment: .leading)
                            }
                        }.padding(.top, 15)
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(14)
                                .frame(width: width * 0.75, height: width * 0.22)
                                .neoShadow()
                            HStack(spacing: -10){
                                Img.bell
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.125, height: width * 0.175)
                                    .padding()
                                    .padding(.trailing)
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Your notifcations are")
                                        .foregroundColor(.gray)
                                        .font(Font.fredoka(.regular, size: 16))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                    HStack {
                                        Text("\(notifications)")
                                            .foregroundColor(Clr.black1)
                                            .font(Font.fredoka(.semiBold, size: 20))
                                        if notifications == "Off" {
                                            Button {
                                                MGAudio.sharedInstance.playBubbleSound()
                                                withAnimation {
                                                    tappedTurnOn = true
                                                    viewRouter.currentPage = .notification
                                                }
                                            } label: {
                                                Capsule()
                                                    .fill(Clr.yellow)
                                                    .frame(width: width * 0.2, height: height * 0.03)
                                                    .overlay(
                                                        Text("Turn On")
                                                        
                                                            .foregroundColor(.black)
                                                            .font(.caption)
                                                            .lineLimit(1)
                                                            .minimumScaleFactor(0.05)
                                                    )
                                                    .neoShadow()
                                            }
                                        }
                                    }
                                }.frame(width: width * 0.5, alignment: .leading)
                                 .offset(x: -5)
                            }
                        }
                        Spacer()
                        Button(
                            action: {
                                MGAudio.sharedInstance.playBubbleSound()
                                Analytics.shared.log(event: .review_tapped_tutorial)
                                fromOnboarding = true
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                fromPage = "onboarding2"
                                UserDefaults.standard.setValue("signedUp", forKey: K.defaults.onboarding)
                                UserDefaults.standard.setValue(true, forKey: "onboarded")
                                withAnimation {
                                    viewRouter.progressValue = 1
                                    if fromInfluencer != ""
                                    {
                                        Analytics.shared.log(event: .user_from_influencer)
                                        viewRouter.currentPage = .pricing
                                    } else {
                                        showPaywall = true
                                    }
                                }
                                
                            },
                            label: {
                                HStack {
                                    Text("Let's Go! 🏃‍♂️")
                                        .foregroundColor(Clr.darkgreen)
                                        .font(Font.fredoka(.semiBold, size: 16))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                }.frame(width: g.size.width * 0.75, height: g.size.height/16)
                                    .background(Clr.yellow)
                                    .cornerRadius(24)
                                    .addBorder(.black, width: 1.5,  cornerRadius: 24)
                            }
                          )
                        .triggerPaywall(
                            forEvent: "review_tapped_tutorial",
                            withParams: ["reason": 17],
                            shouldPresent: $showPaywall,
                            onPresent: { paywallInfo in
                                print("paywall info is", paywallInfo)
                                Analytics.shared.log(event: .screen_load_superwall)
                            },
                            onDismiss: { result in
                                switch result.state {
                                case .closed:
                                    print("User dismissed the paywall.")
                                case .purchased(productId: let productId):
                                    switch productId {
                                    case "io.mindgarden.pro.monthly": Analytics.shared.log(event: .monthly_started_from_superwall)
                                        UserDefaults.standard.setValue(true, forKey: "isPro")
                                    case "io.mindgarden.pro.yearly":
                                        Analytics.shared.log(event: .yearly_started_from_superwall)
                                        UserDefaults.standard.setValue(true, forKey: "freeTrial")
                                        UserDefaults.standard.setValue(true, forKey: "isPro")
                                        if UserDefaults.standard.bool(forKey: "isNotifOn") {
                                            NotificationHelper.freeTrial()
                                        }
                                    default: break
                                    }
                                case .restored:
                                    print("Restored purchases, then dismissed.")
                                }
                                showLoading = true
                            },
                            onFail: { error in
                                print("did fail", error)
                                viewRouter.currentPage = .pricing
                            }
                        )
                        .padding(20)
                        .buttonStyle(NeumorphicPress())
                    
                     
//                        Button {
//                            Analytics.shared.log(event: .review_tapped_explore)
//                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
//
//                            if let segments = UserDefaults.standard.array(forKey: "storySegments") as? [String] {
//                                var newArr = segments
//                                newArr.append("non-tutorial")
//                                storySegments = Set(newArr)
//                                StorylyManager.refresh()
//                            }
//
//                            UserDefaults.standard.setValue(true, forKey: "review")
//                            UserDefaults.standard.setValue("meditate", forKey: K.defaults.onboarding)
//                            withAnimation {
//                                viewRouter.progressValue = 1
//                                if fromInfluencer != "" {
//                                    Analytics.shared.log(event: .user_from_influencer)
//                                    viewRouter.currentPage = .pricing
//                                } else {
//                                    Paywall.present { info in
//                                        Analytics.shared.log(event: .screen_load_superwall)
//                                    } onDismiss: {  didPurchase, productId, paywallInfo in
//                                        switch productId {
//                                        case "io.mindgarden.pro.monthly": Analytics.shared.log(event: .monthly_started_from_superwall)
//                                            UserDefaults.standard.setValue(true, forKey: "isPro")
//                                        case "io.mindgarden.pro.yearly":
//                                            Analytics.shared.log(event: .yearly_started_from_superwall)
//                                            UserDefaults.standard.setValue(true, forKey: "freeTrial")
//                                            UserDefaults.standard.setValue(true, forKey: "isPro")
//                                            if UserDefaults.standard.bool(forKey: "isNotifOn") {
//                                                NotificationHelper.freeTrial()
//                                            }
//                                        default: break
//                                        }
//                                        showLoading = true
//                                    } onFail: { error in
//                                        viewRouter.currentPage = .pricing
//                                    }
//                                }
//                            }
//                        } label: {
//                                Text("Explore myself")
//                                    .underline()
//                                    .font(Font.fredoka(.regular, size: 16))
//                                    .foregroundColor(.gray)
//                                    .padding(.top, K.isSmall() ? 10 : 20)
//                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showLoading)  {
            LoadingIllusion()
                .frame(height: UIScreen.screenHeight + 50)
        }
        .transition(.move(edge: .trailing))
        .onAppearAnalytics(event: .screen_load_review)
            .onAppear {
                if UserDefaults.standard.string(forKey: "experience") != nil {
                switch UserDefaults.standard.string(forKey: "experience") {
                    case Experience.often.title:
                    
                        experience = (Img.redTulips3, "is high")
                    case Experience.nowAndThen.title:
                        experience = (Img.redTulips2, "is low")
                    case Experience.never.title:
                        experience = (Img.redTulips1, "is none")
                    default: break
                    }
                }
                if UserDefaults.standard.value(forKey: K.defaults.meditationReminder) != nil {
                    notifications = "On"
                } else {
                    notifications = "Off"
                }
            }
    }

}

struct ReviewScene_Previews: PreviewProvider {
    static var previews: some View {
        ReviewScene()
    }
}

