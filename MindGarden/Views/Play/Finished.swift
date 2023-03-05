//
//  Finished.swift
//  MindGarden
//
//  Created by Dante Kim on 7/10/21.
//

import SwiftUI
import Photos
import StoreKit
import AppsFlyerLib
import Amplitude
import Firebase
import OneSignal

var moodFromFinished = false
struct Finished: View {
    var bonusModel: BonusViewModel
    var model: MeditationViewModel
    var userModel: UserViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    var gardenModel: GardenViewModel
    @State private var sharedImage: UIImage?
    @State private var shotting = true
    @State private var isOnboarding = false
    @State private var animateViews = false
    @State private var favorited = false
    @State private var showUnlockedModal = false
    @State private var reward : Int = 0
    @State private var hideConfetti = false
    @State private var showStreak = false
    @State private var ios14 = true
    @State private var ios16 = false
    @State private var triggerRating = false
    @State private var showRating = false
    @Environment(\.sizeCategory) var sizeCategory

    var minsMed: Int {
        if model.selectedMeditation?.duration == -1 {
            return Int((model.secondsRemaining/60.0).rounded())
        } else {
            if Int(model.selectedMeditation?.duration ?? 0)/60 == 0 {
                return 1
            } else {
                return Int(model.selectedMeditation?.duration ?? 0)/60
            }
        }
    }

    init(bonusModel: BonusViewModel, model: MeditationViewModel, userModel: UserViewModel, gardenModel: GardenViewModel) {
        self.bonusModel = bonusModel
        self.model = model
        self.userModel = userModel
        self.gardenModel = gardenModel
    }

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { g in
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ZStack {
                                Rectangle()
                                    .fill(Clr.brightGreen)
                                    .frame(width: g.size
                                            .width/1, height: g.size.height/2)
                                    .offset(y: -g.size.height/6)
                                    .opacity(0.35)
                                Img.greenBlob
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: g.size.width/1, height: g.size.height/2)
                                    .offset(x: g.size.width/6, y: -g.size.height/6)
                                LottieView(fileName: "confetti")
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                                    .opacity(hideConfetti ? 0 : 1)
                                HStack(alignment: .center) {
                                    VStack {
                                        Text(model.totalBreaths > 0 ? "Total Breaths" : "Minutes Meditated")
                                            .font(Font.fredoka(.semiBold, size: 28))
                                            .foregroundColor(.white)
                                            .onTapGesture {
                                                withAnimation {
                                                    viewRouter.currentPage  = .garden
                                                }
                                            }
                                            .font(Font.fredoka(.bold, size: 70))
                                            .foregroundColor(.white)
                                            .animation(.easeInOut(duration: 1.5))
                                            .opacity(animateViews ? 0 : 1)
                                            .offset(x: animateViews ? 500 : 0)
                                        Text(model.totalBreaths > 0 ? String(model.totalBreaths) : String(minsMed))
                                            .font(Font.fredoka(.bold, size: 70))
                                            .foregroundColor(.white)
                                            .animation(.easeInOut(duration: 1.5))
                                            .opacity(animateViews ? 0 : 1)
                                            .offset(x: animateViews ? 500 : 0)
                                        VStack {
                                            HStack {
                                                Text("You received:")
                                                    .font(Font.fredoka(.semiBold, size: 24))
                                                    .foregroundColor(.white)
                                                Img.coin
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(height: 25)
                                                Text(UserDefaults.standard.bool(forKey: "isPro") ?  "\(reward/2) x 2: \(reward)": "+\(reward)!")
                                                    .font(Font.fredoka(.bold, size: 24))
                                                    .foregroundColor(.white)
                                                    .offset(x: -3)
                                                if userModel.isPotion || userModel.isChest {
                                                    Img.sunshinepotion
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(height: 30)
                                                        .rotationEffect(.degrees(30))
                                                }
                                            }.offset(y: sizeCategory > .large ? -60 : -25)
                                            if !isOnboarding {
                                                HStack {
                                                    Button {
                                                    } label: {
                                                        HStack {
                                                            Img.veryGood
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 50)
                                                                .padding(.vertical, 5)
                                                            Text("Log Mood")
                                                                .foregroundColor(.black)
                                                                .font(Font.fredoka(.semiBold, size: 16))
                                                                .padding(.trailing)
                                                                .lineLimit(1)
                                                                .minimumScaleFactor(0.05)
                                                        }.frame(width: g.size.width * 0.4, height: 45)
                                                            .background(Clr.yellow)
                                                            .cornerRadius(24)
                                                            .addBorder(.black, width: 1.5, cornerRadius: 24)
                                                            .onTapGesture {
                                                                moodFromFinished = true
                                                                withAnimation(.easeOut) {
                                                                    hideConfetti = true
                                                                    Analytics.shared.log(event: .home_tapped_categories)
                                                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                                                    impact.impactOccurred()
                                                                    NotificationCenter.default.post(name: Notification.Name("mood"), object: nil)
                                                                }
                                                            }
                                                    }.buttonStyle(BonusPress())
                                                    Button { } label: {
                                                        HStack {
                                                            Img.streakPencil
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .padding([.leading])
                                                                .padding(.vertical, 5)
                                                            Text("Journal")
                                                                .foregroundColor(.black)
                                                                .font(Font.fredoka(.semiBold, size: 16))
                                                                .padding(.trailing)
                                                                .lineLimit(1)
                                                                .minimumScaleFactor(0.05)
                                                        }.frame(width: g.size.width * 0.4, height: 45)
                                                            .background(Clr.yellow)
                                                            .cornerRadius(24)
                                                            .addBorder(.black, width: 1.5, cornerRadius: 24)
                                                            .onTapGesture {
                                                                withAnimation {
                                                                    hideConfetti = true
                                                                    Analytics.shared.log(event: .home_tapped_categories)
                                                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                                                    impact.impactOccurred()
                                                                    viewRouter.previousPage = .garden
                                                                    viewRouter.currentPage = .journal
                                                                }
                                                            }
                                                    }
                                                    .buttonStyle(BonusPress())
                                                }.frame(width: g.size.width, height: 45)
                                                .padding(.top, 10)
                                                .zIndex(100)
                                                .offset(y: sizeCategory > .large ? -60 : K.isSmall() ? -15 : 0)
                                            }
                                        }.offset(y: !isOnboarding ? 0 : -25)
                                    }.offset(y: !isOnboarding ? 15 : -50)
                                }.padding(.top, ios14 && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "done" ? 50 : 0)
                            }
                  
                            HStack(alignment: .center) {
                                Spacer()
                                VStack(alignment: .center, spacing: 10) {
                                    if !UserDefaults.standard.bool(forKey: "isNotifOn") && !isOnboarding {
                                        ReminderView(playAnim: .constant(false))
                                            .frame(width:UIScreen.screenWidth*0.85, height: 250, alignment: .center)
                                            .padding(.top,50)
                                            .padding()
                                            .offset(y: !isOnboarding ? -75 : -100)
                                        Spacer()
                                    }
                                    VStack {
                                        Text("You completed your \(gardenModel.allTimeSessions.ordinal) session!")
                                            .font(Font.fredoka(.regular, size: 20))
                                            .foregroundColor(Clr.black2)
                                            .padding([.horizontal])
                                        Text("With patience and mindfulness you were able to grow \(userModel.modTitle())!")
                                            .font(Font.fredoka(.bold, size: 22))
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.05)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Clr.black1)
                                            .frame(height: g.size.height/14)
                                            .padding([.horizontal], 15)
                                        userModel.selectedPlant?.badge
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: g.size.height/2.75)
                                            .padding(.top, 10)
                                            .animation(.easeInOut(duration: 2.0))
                                    }.frame(width: g.size.width * 0.85, height: g.size.height/2.25)
                                }
                                Spacer()
                            }.offset(y: !isOnboarding ? -20 : -75)
                        }.offset(y: -g.size.height/(ios16 ? 12 : 6))
                    }.frame(width: g.size.width)
                    HStack {
                        heart.padding(.horizontal)
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Clr.black1)
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                PHPhotoLibrary.requestAuthorization { (status) in
                                    // No crash
                                }
                                let snap = self.takeScreenshot(origin: g.frame(in: .global).origin, size: g.size)
                                if let myURL = URL(string: "https://mindgarden.io") {
                                    let objectToshare = [snap, myURL] as [Any]
                                    let activityVC = UIActivityViewController(activityItems: objectToshare, applicationActivities: nil)
                                    UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                                }
                            }
                        Spacer()
                        Button {
                            gardenModel.updateSelf()
                        } label: {
                            Capsule()
                                .fill(Clr.yellow)
                                .overlay(
                                    HStack {
                                        Text("Finished")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.fredoka(.bold, size: 22))
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 22, weight: .bold))
                                    }
                                )
                                .addBorder(.black, width: 1.5, cornerRadius: 24)
                                .padding(.horizontal)
                            // TODO -> change not now in saveProgress modal to trigger showStreak
                                .onTapGesture {
                                    Analytics.shared.log(event: .finished_tapped_finished)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        let launchNum = UserDefaults.standard.integer(forKey: "dailyLaunchNumber")
                                        if !showRating {
                                            if launchNum == 2 || launchNum == 4 || launchNum == 7 || launchNum == 9  {
                                                showRating = true
                                                if !UserDefaults.standard.bool(forKey: "reviewedApp") {
                                                    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                                        SKStoreReviewController.requestReview(in: scene)
                                                    } else {
                                                        dismiss()
                                                    }
                                                } else {
                                                    dismiss()
                                                }
                                            } else {
                                                dismiss()
                                            }
                                        } else {
                                            dismiss()
                                        }
                                    }
                                }
                        }
                        .zIndex(100)
                        .frame(width: g.size.width * 0.6, height: g.size.height/16)
                        .buttonStyle(ScalePress())
                    }.frame(width: abs(g.size.width - 50), height: g.size.height/10)
                    .background(!K.isSmall() ? .clear : Clr.darkWhite)
                    .padding()
                    .position(x: g.size.width/2, y: g.size.height - g.size.height/(K.hasNotch() ? ios14 ? 7 : 9 : 4))
                    if showUnlockedModal {
                        Color.black
                            .opacity(0.55)
                            .edgesIgnoringSafeArea(.all)
                        Spacer()
                    }
//                    OnboardingModal(shown: $showUnlockedModal, isUnlocked: true)
//                        .offset(y: showUnlockedModal ? 0 : g.size.height)
//                        .animation(.default, value: showUnlockedModal)
                }
            }
        }.transition(.move(edge: .trailing))
            .fullScreenCover(isPresented: $showStreak, content: {
                StreakScene(showStreak: $showStreak)
                        .environmentObject(bonusModel)
                        .environmentObject(viewRouter)
                        .background(Clr.darkWhite)
            })
            .onDisappear {
                model.totalBreaths = 0
                model.playImage = Img.seed
                model.lastSeconds = false
                if let oneId = UserDefaults.standard.value(forKey: "oneDayNotif") as? String {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oneId])
                    print("numSession", UserDefaults.standard.integer(forKey: "numSessions"))
                    NotificationHelper.addOneDay()
                }
                if let threeId = UserDefaults.standard.value(forKey: "threeDayNotif") as? String {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [threeId])
                    NotificationHelper.addThreeDay()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.runCounter))
        { _ in }
            .onAppear {
                
                if UserDefaults.standard.bool(forKey: "isPlayMusic") {
                    if let player = player {
                        player.play()
                    }
                }
                
                DispatchQueue.main.async {
                    if #available(iOS 15.0, *) {
                        ios14 = false
                    }
                    if  #available(iOS 16.0, *)  {
                        ios16 = true
                    }
                }
                
                
          
                var session = [String: String]()
                session[K.defaults.plantSelected] = userModel.selectedPlant?.title
                var minutesMed = 0
                
                if model.totalBreaths > 0 {
                    if let selectedBreath = model.selectedBreath {
                        session[K.defaults.meditationId] = String(selectedBreath.id)
                        switch (selectedBreath.duration * model.totalBreaths) {
                        case 0...35: minutesMed = 30
                        case 36...70: minutesMed = 60
                        default: minutesMed = selectedBreath.duration * model.totalBreaths
                        }
                        if minutesMed >= 30 {
                            userModel.finishedMeditation(id: String(selectedBreath.id))
                        }
                    }
                    session[K.defaults.duration] = String(minutesMed)
                    //Log Analytics
                    #if !targetEnvironment(simulator)
                    Amplitude.instance().logEvent("finished_breathwork", withEventProperties: ["breathwork": model.selectedBreath?.title ?? "default"])
                    #endif
                     print("logging, \("finished_\(model.selectedMeditation?.returnEventName() ?? "")")")
                } else {
                    session[K.defaults.meditationId] = String(model.selectedMeditation?.id ?? 0)
                    session[K.defaults.duration] = model.selectedMeditation?.duration == -1 ? String(model.secondsRemaining) : String(model.selectedMeditation?.duration ?? 0)
                    let dur = model.selectedMeditation?.duration ?? 0
                    if !((model.forwardCounter > 2 && dur <= 120) || (model.forwardCounter > 6) || (model.selectedMeditation?.id == 22 && model.forwardCounter >= 1)) {
                        userModel.finishedMeditation(id: String(model.selectedMeditation?.id ?? 0))
                    }
                    //Log Analytics
                    #if !targetEnvironment(simulator)
                    Amplitude.instance().logEvent("finished_meditation", withEventProperties: ["meditation": model.selectedMeditation?.returnEventName() ?? ""])
                    #endif
                     print("logging, \("finMed_\(model.selectedMeditation?.returnEventName() ?? "")")")
                }
                session["timeStamp"] = Date.getTime()
                reward = model.getReward()
                if userModel.isPotion || userModel.isChest {
                    reward = reward * 3
                }
                
                if reward == 0 && (UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "garden") {
                    viewRouter.currentPage = .garden
                }
//
                userModel.coins += reward
                gardenModel.save(key: "sessions", saveValue: session, coins: userModel.coins) {
                    if model.shouldStreakUpdate {
                        bonusModel.updateStreak()
                    }
                    
                    
                    if !userModel.ownedPlants.contains(where: { plt in  plt.title == "Cherry Blossoms"}) && UserDefaults.standard.bool(forKey: "unlockedCherry") {
                        userModel.willBuyPlant = Plant.badgePlants.first(where: { p in
                            p.title == "Cherry Blossoms"
                        })
                        userModel.buyPlant(unlockedStrawberry: true)
                    }
                }

                

                favorited = model.isFavorited
                // onboarding
                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                    Analytics.shared.log(event: .onboarding_finished_meditation)
                    UserDefaults.standard.setValue("garden", forKey: K.defaults.onboarding)
                    isOnboarding = true
                } else {
                    OneSignal.sendTag("firstMeditation", value: "true")
                }
                
            }
            .onAppearAnalytics(event: .screen_load_finished)
            .alert(isPresented: $triggerRating) {
                Alert(title: Text("🧑‍🌾 Are you enjoying MindGarden so far?"), message: Text(""),
                      primaryButton: .default(Text("Yes!")) {
                    Analytics.shared.log(event: .rating_tapped_yes)
                    showRating = true
                    UserDefaults.standard.setValue(true, forKey: "reviewedApp")
   
                },
                      secondaryButton: .default(Text("No")) {
                    Analytics.shared.log(event: .rating_tapped_no)
                    dismiss()
                })
            }
    }


    var heart: some View {
        ZStack {
            if model.isFavoritedLoaded {
                LikeButton(isLiked: model.isFavorited, size:35) {
                    likeAction()
                }
            } else {
                LikeButton(isLiked: false) {
                    likeAction()
                }
            }
        }
    }
    private func dismiss() {
        if updatedStreak && model.shouldStreakUpdate {
            showStreak.toggle()
            updatedStreak = false
        } else {
            viewRouter.currentPage = .garden
        }

    }
    
    private func likeAction(){
        Analytics.shared.log(event: .play_tapped_favorite)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if let med = model.selectedMeditation {
//                    Analytics.shared.log(event: "favorited_\(med.returnEventName())")
            model.favorite(id: med.id)
        }
        favorited.toggle()
    }
}

struct Finished_Previews: PreviewProvider {
    static var previews: some View {
        Finished(bonusModel: BonusViewModel(userModel: UserViewModel(), gardenModel: GardenViewModel()), model: MeditationViewModel(), userModel: UserViewModel(), gardenModel: GardenViewModel())
    }
}

extension Int {

    var ordinal: String {
        var suffix: String
        let ones: Int = self % 10
        let tens: Int = (self/10) % 10
        if tens == 1 {
            suffix = "th"
        } else if ones == 1 {
            suffix = "st"
        } else if ones == 2 {
            suffix = "nd"
        } else if ones == 3 {
            suffix = "rd"
        } else {
            suffix = "th"
        }
        return "\(self)\(suffix)"
    }

}
