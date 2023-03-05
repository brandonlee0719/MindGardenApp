//
//  Home.swift
//  MindGarden
//
//  Created by Dante Kim on 6/11/21.
//

import SwiftUI
import FirebaseAuth
import StoreKit
import Purchases
import Firebase
import FirebaseFirestore
import AppsFlyerLib
import Paywall

var launchedApp = false
var showProfile = false
enum Sheet: Identifiable {
    case profile, plant, search, streak, mood
    var id: Int {
        hashValue
    }
}
var searchScreen = false
var swipedTrees = false
struct Home: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var authModel: AuthenticationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    @State private var showModal:Bool = false
    @State private var showSearch = false
    @State private var showUpdateModal = false
    @State private var showMiddleModal = false
    @State private var showPurchase = false
    @State private var confirmModal = false
    @State private var showIAP = false
    @State private var wentPro = false
    @State private var ios14 = true
    @State private var coins = 0
    @State private var attempts = 5
    @State var activeSheet: Sheet?
    @State private var showChallenge = false
    @State private var showMoodElaborate = true
    @State private var showAuth = false
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
 
                GeometryReader { g in
                    HomeViewScroll(gardenModel: gardenModel, showModal: $showModal, showMiddleModal: $showMiddleModal, activeSheet: $activeSheet, totalBonuses: $bonusModel.totalBonuses, attempts: $attempts, showIAP: $showIAP, userModel: userModel)
                    if showModal || showUpdateModal || showMiddleModal || showIAP || showPurchase || showChallenge {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showModal = false
                                showUpdateModal = false
                                showMiddleModal = false
                                showIAP = false
                            }
                        Spacer()
                    }
                    ConfirmModal(shown: $confirmModal, showMainModal: $showPurchase)
                        .offset(y: confirmModal ? 0 : g.size.height)
                        .animation(.default, value: confirmModal)
                    MiddleModal(shown: $showMiddleModal)
                        .offset(y: showMiddleModal ? 0 : g.size.height)
                        .edgesIgnoringSafeArea(.top)
                        .animation(.default, value: showMiddleModal)
                    BonusModal(bonusModel: bonusModel, shown: $showModal, coins: $coins)
                        .offset(y: showModal ? 0 : g.size.height)
                        .edgesIgnoringSafeArea(.top)
                        .animation(.default, value: showModal)
                    NewUpdateModal(shown: $showUpdateModal, showSearch: $showSearch)
                        .offset(y: showUpdateModal ? 0 : g.size.height)
                        .animation(.default, value: showUpdateModal)
               
                }
            }
     
            .fullScreenCover(isPresented: $userModel.triggerAnimation) {
                PlantGrowing()
            }

            .sheet(item: $activeSheet) { item in
                switch item {
                case .profile:
                    ProfileScene(profileModel: profileModel)
                        .environmentObject(userModel)
                        .environmentObject(gardenModel)
                        .environmentObject(viewRouter)
                case .plant:
                    Store(isShop: false)
                case .search:
                    CategoriesScene(isSearch: searchScreen, showSearch: $showSearch, isBack: .constant(false))
                case .streak:
                    EmptyView()
                case .mood:
                    MoodElaborate()
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $wentPro) {
                Alert(title: Text("😎 Welcome to the club."), message: Text("🍀 You're now a MindGarden Pro Member"), dismissButton: .default(Text("Got it!")))
            }

        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("runCounter")))
        { _ in
            runCounter(counter: $attempts, start: 0, end: 3, speed: 1)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("intro")))
        { _ in
            model.selectedMeditation = Meditation.allMeditations.first(where: { $0.id == 6 })
            viewRouter.currentPage = .middle
        }

        .onAppear {
            if !UserDefaults.standard.bool(forKey: "showWidget") && (UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "garden") {
                profileModel.showWidget = true
            }
                                    
            viewRouter.previousPage = .meditate
            fromPage = "profile"
            tappedSignOut = false
            if showProfile {
                activeSheet = .profile
                showProfile = false
            }
            
            userModel.checkIfPro()
            DispatchQueue.main.async {
                if #available(iOS 15.0, *) {
                    ios14 = false
                }
                
                if userWentPro {
                    wentPro = userWentPro
                    userWentPro = false
                }
                
                numberOfMeds += Int.random(in: -3 ... 3)
                //handle update modal or deeplink
                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "garden" {
                    if UserDefaults.standard.bool(forKey: "introLink") {
                        model.selectedMeditation = Meditation.allMeditations.first(where: {$0.id == 6})
                        viewRouter.currentPage = .middle
                        UserDefaults.standard.setValue(false, forKey: "introLink")
                    } else if UserDefaults.standard.bool(forKey: "happinessLink") {
                        model.selectedMeditation = Meditation.allMeditations.first(where: {$0.id == 14})
                        viewRouter.currentPage = .middle
                        UserDefaults.standard.setValue(false, forKey: "happinessLink")
                    }
                }
                                
                if (UserDefaults.standard.integer(forKey: "dailyLaunchNumber") == 2 && !UserDefaults.standard.bool(forKey: "isPro") && !UserDefaults.standard.bool(forKey: "14DayModal")) || userModel.show50Off {
                    showUpdateModal = true
                    userModel.show50Off = false
                    UserDefaults.standard.setValue(true, forKey: "freeTrialTo50")
                }
                
                // coins = userModel.coins
                // self.runCounter(counter: $coins, start: 0, end: coins, speed: 0.015)
            }
        
        }
        .onAppearAnalytics(event: .screen_load_home)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("notification")))
        { _ in
            withAnimation {
                mindfulNotifs = true
                activeSheet = .profile
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("storyOnboarding")))
        { _ in
            withAnimation {
                if (UserDefaults.standard.bool(forKey: "review") || (UserDefaults.standard.string(forKey: "onboarding") == "done") || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "garden") && !UserDefaults.standard.bool(forKey: "showedChallenge") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Change `2.0` to the desired number of seconds.
                       // Code you want to be delayed
//                        showChallenge = true
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("referrals")))
        { _ in
            withAnimation {
                tappedRefer = true
                activeSheet = .profile
            }
        }
    }
}


func runCounter(counter: Binding<Int>, start: Int, end: Int, speed: Double) {
    counter.wrappedValue = start
    
    Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
        counter.wrappedValue += 1
        if counter.wrappedValue == end {
            counter.wrappedValue = 0
            timer.invalidate()
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 5
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}

