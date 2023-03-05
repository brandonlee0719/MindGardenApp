//
//  OnboardingScene.swift
//  MindGarden
//
//  Created by Dante Kim on 6/6/21.
//

import SwiftUI
import Paywall
import OneSignal
import Purchases
import Amplitude
import Lottie
import AppTrackingTransparency

var tappedSignIn = false
struct OnboardingScene: View {
    @State private var index = 0
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var authModel: AuthenticationViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var userModel: UserViewModel
    var title = "Meditate."
    @State private var showAuth = false
    init() {
        if #available(iOS 14.0, *) {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Clr.gardenGreen)
        } else {
            // Fallback on earlier versions
        }
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }

    var body: some View {
        NavigationView {
            GeometryReader { g in
                let width = g.size.height
                let height = g.size.height
                ZStack(alignment: .center) {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack {
                        HStack(alignment:.top) {
                            Img.onboardingCamelia
                                .offset(x: -60, y: -60)
                            Spacer()
                            Img.onBoardingCalender
                                .neoShadow()
                                .offset(x: 25, y: -25)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        }
                        Spacer()
                        HStack(alignment:.bottom) {
                            Img.onBoardingFlower
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                            Spacer()
                            Img.onboardingApple
                                .offset(x: 40, y: 100)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .ignoresSafeArea()
                    VStack(alignment: .center,spacing:0) {
                        Spacer()
                        Spacer()
                        VStack(spacing:0) {
                            VStack {
                                Text("Meditate.")
                                    .foregroundColor(Clr.healthSecondary)
                                    .frame(width: width * 0.4 , alignment: .leading)
                                Text("Journal.")
                                    .foregroundColor(Clr.brightGreen)
                                    .frame(width: width * 0.4, alignment: .leading)
                                Text("Grow.")
                                    .foregroundColor(Clr.energySecondary)
                                    .frame(width: width * 0.4, alignment: .leading)
                            }
                                .multilineTextAlignment(.leading)
                                .font(Font.fredoka(.bold, size: 40))
                                .offset(y: K.isSmall() ?  height * 0.1 : height * 0.15)
                            LottieAnimationView(filename: "onboarding1", loopMode: LottieLoopMode.loop, isPlaying: .constant(true))
                                .frame(width: width * 0.45)
                                .offset(y: height * -0.15)
                        }
                        .foregroundColor(Clr.brightGreen)
                        //                        font(Font.fredoka(.bold, size: 32))
                        .padding(.horizontal)
                        VStack {
                            Button {
                                MGAudio.sharedInstance.playBubbleSound()
                                Analytics.shared.log(event: .onboarding_tapped_continue)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation(.easeOut(duration: 0.4)) {
                                    DispatchQueue.main.async {
                                        viewRouter.progressValue = 0.2
                                        viewRouter.currentPage = .experience
                                    }
                                }
                                if let onesignalId = OneSignal.getDeviceState().userId {
                                    Purchases.shared.setOnesignalID(onesignalId)
                                }
                            } label: {
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text("Start Growing 👉")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.fredoka(.bold, size: 20))
                                    ).addBorder(Color.black, width: 1.5, cornerRadius: 24)
                            }.frame(width:UIScreen.screenWidth*0.8, height: 50)
                                .padding()
                                .buttonStyle(BonusPress())
                            Button {
                                MGAudio.sharedInstance.playBubbleSound()
                                Analytics.shared.log(event: .onboarding_tapped_sign_in)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                tappedSignIn = true
                                withAnimation {
                                    fromPage = "onboarding"
                                    tappedSignOut = true
                                    authModel.isSignUp = false
                                    viewRouter.currentPage = .authentication
                                }
                            } label: {
                                Text("Already have an account")
                                    .underline()
                                    .font(Font.fredoka(.semiBold, size: 18))
                                    .foregroundColor(.gray)
                            }.frame(height: 30)
                                .padding([.horizontal,.bottom])
                                .offset(y: 25)
                                .buttonStyle(BonusPress())
                        }.offset(y: height * -0.1)
                        Spacer()
                    }
                }
            }.navigationBarTitle("", displayMode: .inline)
        }.onAppearAnalytics(event: .screen_load_onboarding)
            .onAppear {
                UserDefaults.standard.setValue("onboarding", forKey: K.defaults.onboarding)
                if let num = UserDefaults.standard.value(forKey: "abTest") as? Int {
                    let identify = AMPIdentify()
                        .set("abTest1.53", value: NSNumber(value: num))
                    Amplitude.instance().identify(identify ?? AMPIdentify())
                }
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        Analytics.shared.log(event: .onboarding_tapped_allowed_att)
                    case .notDetermined:
                        print("test")
                    case .restricted:
                        print("restricted")
                    default:
                        Analytics.shared.log(event: .onboarding_tapped_denied_att)
                    }
                }
            }
            .sheet(isPresented: $showAuth) {
                if tappedSignOut {
                    
                } else {
                    Authentication(viewModel: authModel)
                        .environmentObject(medModel)
                        .environmentObject(userModel)
                        .environmentObject(gardenModel)
                }
            }
    }
    
}

struct OnboardingScene_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScene()
    }
}
