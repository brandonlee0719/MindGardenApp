//
//  Store.swift
//  MindGarden
//
//  Created by Dante Kim on 6/14/21.
//

import SwiftUI
import OneSignal
import Amplitude

struct Store: View {
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var showModal = false
    @State private var confirmModal = false
    @State private var showSuccess = false
    var isShop: Bool = true
    @State private var isStore = false
    @State private var showTip = false
    @State private var currentHightlight: Int = -1
    @State private var isNotifOn = false
    @State private var tabType:TopTabType = .badge
    @State private var showIAP = false
    @State private var showAlert = false

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // TODO if tapped real tree open storly
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all)
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                VStack {
                    if isShop {
                        StoreTab(selectedTab: $tabType)
                            .frame(width: g.size.width * 0.85)
                            .padding(.top, 35)
                    } else {
                        HStack {
                            Spacer()
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Clr.darkWhite)
                                    Image(systemName: "xmark")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.gray)
                                }.frame(width: 30)
                                 .padding(.leading, 24)
                            }.buttonStyle(NeoPress())
                            Text("🌻 Plant Select" )
                                .font(Font.fredoka(.bold, size: 32))
                                .minimumScaleFactor(0.005)
                                .lineLimit(1)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Clr.black1)
                                .padding(.horizontal, 25)
                            Image(systemName: "xmark")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundColor(Clr.black1)
                                .padding(.leading)
                                .opacity(0)
                            Spacer()
                            
                        }.frame(width: g.size.width * 0.9, height: 45)
                    }
                    if tabType == .realTree {
                        RealTrees(buyRealTree: $showModal)
                    } else {
                        if tabType == .store {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                Analytics.shared.log(event: .pricing_from_home)
                                withAnimation {
                                    fromPage = "store"
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
                                            Img.tripleCoins
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: width * 0.15)
                                            (Text("Get 2x Coins.\n")
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
                        ScrollView(showsIndicators: false) {
                            HStack(alignment: .top, spacing: 20) {
                                VStack(alignment: .leading, spacing: -10) {
                                    HStack {
                                        if isShop {
                                            Text(!(tabType == .store) ? "Badges\n🏆🎖🥇" : "🌻 Seed\nShop" )
                                                .font(Font.fredoka(.bold, size: 32))
                                                .minimumScaleFactor(0.005)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Clr.black1)
                                                .padding(.horizontal, isShop ? 25 : 10)
                                                .frame(width: g.size.width * (isShop ? 0.4 : 0.25), alignment: .center)
                                        }
                                    }
                                    if isShop && !(tabType == .store) {
                                        ForEach(Plant.badgePlants.prefix(Plant.badgePlants.count/2),  id: \.self) { plant in
                                            Button {
                                                Analytics.shared.log(event: .store_tapped_badge_tile)
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                userModel.willBuyPlant = plant
                                                withAnimation {
                                                    showModal = true
                                                }
                                            } label: {
                                                if userModel.ownedPlants.contains(plant) {
                                                    PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop, isOwned: true, isBadge: true)
                                                } else {
                                                    PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop, isBadge: true)
                                                }
                                            }.buttonStyle(NeumorphicPress())
                                        }
                                    } else {
                                        ForEach(isShop ? Plant.packetPlants.prefix(Plant.packetPlants.count/2) : userModel.ownedPlants.prefix(userModel.ownedPlants.count/2), id: \.self)
                                        { plant in
                                            if (userModel.ownedPlants.contains(plant) && isShop && plant.title != "Real Tree") {
                                                PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop, isOwned: true)
                                            } else if (plant.title != "Real Tree") {
                                                Button {
                                     
                                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                    if isShop {
                                                        userModel.willBuyPlant = plant
                                                        withAnimation {
                                                            showModal = true
                                                        }
                                                    } else {
                                                        Amplitude.instance().logEvent("selectedPlant", withEventProperties: ["plant": plant.title])
                                                        UserDefaults.standard.setValue(plant.title, forKey: K.defaults.selectedPlant)
                                                        userModel.selectedPlant = plant
                                                    }
                                                } label: {
                                                    PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop)
                                                }.buttonStyle(NeumorphicPress())
                                            } else {
                                                EmptyView()
                                            }
                                        }
                                    }
                                }
                                
                                SecondColumn(isShop: isShop, tabType: $tabType, showModal: $showModal, showIAP: $showIAP, width: g.size.width, height: g.size.height)
                                
                            }.padding()
                        }.opacity(confirmModal ? 0.3 : 1)
                    }
                }
                if currentHightlight == 0 {
                        triangleDisclosure
                        .position(x: g.size.width/2, y: 180)
                        .opacity(currentHightlight == 0 ? 1 : 0)
                }
                
                    if showModal || confirmModal || showIAP  {
                    Color.black
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: UIScreen.screenHeight)
                }
                if isShop {
                    PurchaseModal(shown: $showModal, showConfirm: $confirmModal).offset(y: showModal  ? 0 : g.size.height)
                        .opacity(confirmModal || showSuccess ? 0.3 : 1)
                        .environmentObject(bonusModel)
                        .environmentObject(profileModel)
                }
                IAPModal(shown: $showIAP, fromPage: "home", showAlert: $showAlert)
                    .offset(y: showIAP ? 0 : g.size.height)
                    .edgesIgnoringSafeArea(.top)
                    .animation(.default, value: showIAP)
                ConfirmModal(shown: $confirmModal, showMainModal: $showModal).offset(y: confirmModal ? 0 : g.size.height)
                    .opacity(showSuccess ? 0.3 : 1)
                //                SuccessModal(showSuccess: $showSuccess, showMainModal: $showModal).offset(y: showSuccess ? 0 : g.size.height)
            }.padding(.top)
                .alert(isPresented: $showTip) {
                    Alert(title: Text("💡 Quick Tip"), message:
                            Text("You can click on badges and open them up")
                          , dismissButton: .default(Text("Got it!")))
                }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text("🚀 Your Purchase was Successful!"), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            if swipedTrees {
                tabType = .realTree
                swipedTrees = false
            }
            if !isShop {
                Analytics.shared.log(event: .screen_load_plant_select)
            } else {
                Analytics.shared.log(event:. screen_load_shop_page)
            }
            //            let _ = storylyViewProgrammatic.openStory(storyGroupId: 41611, play: .StoryGroup)
            DispatchQueue.main.async {
                isNotifOn = UserDefaults.standard.bool(forKey: "isNotifOn")
                if UserDefaults.standard.bool(forKey: "day2") && isShop {
                    if !UserDefaults.standard.bool(forKey: "storeTutorial") {
                        currentHightlight = 0
                    }
                }
                if UserDefaults.standard.bool(forKey: "christmasLink") {
                    userModel.willBuyPlant = Plant.badgePlants.first(where: {$0.title == "Christmas Tree"})
                    withAnimation {
                        showModal = true
                    }
                    UserDefaults.standard.setValue(false, forKey: "christmasLink")
                }
            }
        }
        .fullScreenCover(isPresented: $userModel.showPlantAnimation) {
            PlantGrowing()
                .environmentObject(userModel)
        }
        .onDisappear {
            UserDefaults.standard.setValue(true, forKey: "showTip")
        }.onAppear {
            if isShop {
                
            }
        }
    }
    struct SecondColumn: View {
        @EnvironmentObject var userModel: UserViewModel
        var isShop: Bool
        @Binding var tabType: TopTabType
        @Binding var showModal: Bool
        @Binding var showIAP: Bool
        var width, height: CGFloat
        
        var body: some View {
            VStack {
                HStack {
                    PlusCoins(coins: $userModel.coins)
                        .onTapGesture {
                            withAnimation {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                showIAP.toggle()
                            }
                        }
                }.padding(.bottom, -10)
                if isShop && !(tabType == .store) {
                    ForEach(Plant.badgePlants.suffix(Plant.badgePlants.count/2 + (Plant.badgePlants.count % 2 == 0 ? 0 : 1)), id: \.self) { plant in
                        Button {
                            Analytics.shared.log(event: .store_tapped_badge_tile)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            userModel.willBuyPlant = plant
                            withAnimation {
                                showModal = true
                            }
                        } label: {
                            if userModel.ownedPlants.contains(plant) {
                                PlantTile(width: width, height: height, plant: plant, isShop: isShop, isOwned: true, isBadge: true)
                            } else {
                                PlantTile(width: width, height: height, plant: plant, isShop: isShop, isBadge: true)
                            }
                        }.buttonStyle(NeumorphicPress())
                    }
                } else {
                    ForEach(isShop ? Plant.packetPlants.suffix(Plant.packetPlants.count/2 + (Plant.packetPlants.count % 2 == 0 ? 0 : 1))
                            : userModel.ownedPlants.suffix(userModel.ownedPlants.count/2 + (userModel.ownedPlants.count % 2 == 0 ? 0 : 1)), id: \.self) { plant in
                        if (userModel.ownedPlants.contains(plant) && isShop && plant.title != "Real Tree") {
                            PlantTile(width: width, height: height, plant: plant, isShop: isShop, isOwned: true)
                        } else {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                if isShop {
                                    Analytics.shared.log(event: .store_tapped_plant_tile)
                                    userModel.willBuyPlant = plant
                                    withAnimation {
                                        showModal = true
                                    }
                                } else {
                                    Amplitude.instance().logEvent("selectedPlant", withEventProperties: ["plant": plant.title])
                                    UserDefaults.standard.setValue(plant.title, forKey: K.defaults.selectedPlant)
                                    userModel.selectedPlant = plant
                                    Analytics.shared.log(event: .home_selected_plant)
                                }
                            } label: {
                                PlantTile(width: width, height: height, plant: plant, isShop: isShop)
                            }.buttonStyle(NeumorphicPress())
                        }
                    }
                }
                
            }
        }
    }
    
    var triangleDisclosure: some View {
        VStack (spacing: 0) {
            Triangle()
                .fill(Clr.yellow)
                .frame(width: 40, height: 20)
            Rectangle()
                .fill(Clr.yellow)
                .frame(width: 300, height: 200)
                .overlay(
                    VStack {
                        Text("🎖 Badges are plants that must be earned.\n🪴 Store plants can be bought with coins.")
                            .font(Font.fredoka(.medium, size: 20))
                            .lineLimit(4)
                            .minimumScaleFactor(0.05)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)
                            .foregroundColor(Color.black)
                        Text("Got it")
                            .foregroundColor(Clr.darkgreen)
                            .font(Font.fredoka(.bold, size: 22))
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    UserDefaults.standard.setValue(true, forKey: "storeTutorial")
                                    currentHightlight = 1
                                    showTip = true
                                }
                            }
                    }.padding()
                ).cornerRadius(12)
        }
    }
    
    private func promptNotif() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                UserDefaults.standard.setValue(true, forKey: "isNotifOn")
                Analytics.shared.log(event: .notification_success_store)
                if UserDefaults.standard.value(forKey: "oneDayNotif") == nil {
                    NotificationHelper.addOneDay()
                }
                if UserDefaults.standard.value(forKey: "threeDayNotif") == nil {
                    NotificationHelper.addThreeDay()
                }
                
                if UserDefaults.standard.bool(forKey: "freeTrial") {
                    NotificationHelper.freeTrial()
                }
                UserDefaults.standard.setValue(true, forKey: "notifOn")
                isNotifOn = true
            case .denied:
                Analytics.shared.log(event: .notification_settings_store)
                DispatchQueue.main.async {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
                UserDefaults.standard.setValue(true, forKey: "isNotifOn")
            case .notDetermined:
                Analytics.shared.log(event: .notification_settings_learn)
                DispatchQueue.main.async {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
                UserDefaults.standard.setValue(true, forKey: "isNotifOn")
            default:
                print("Unknow Status")
            }
        })
    }
    
    struct SuccessModal: View {
        @EnvironmentObject var userModel: UserViewModel
        @Binding var showSuccess: Bool
        @Binding var showMainModal: Bool
        
        var  body: some View {
            GeometryReader { g in
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            Text("Successfully Unlocked!")
                                .foregroundColor(Clr.black1)
                                .font(Font.fredoka(.bold, size: 24))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.vertical)
                            Text("Go to the home screen and press the select plant button to equip your new plant")
                                .font(Font.fredoka(.medium, size: 18))
                                .foregroundColor(Clr.black2.opacity(0.7))
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Button {
                                Analytics.shared.log(event: .store_tapped_success_modal_okay)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    showSuccess = false
                                    showMainModal = false
                                    userModel.showPlantAnimation = true
                                }
                            } label: {
                                Text("Got it")
                                    .font(Font.fredoka(.bold, size: 18))
                                    .foregroundColor(.white)
                                    .frame(width: g.size.width/3, height: 40)
                                    .background(Clr.darkgreen)
                                    .clipShape(Capsule())
                                    .padding()
                                    .neoShadow()
                            }
                        }.frame(width: g.size.width * 0.85, height: g.size.height * 0.30, alignment: .center)
                            .background(Clr.darkWhite)
                            .cornerRadius(20)
                        Spacer()
                    }
                    Spacer()
                }
                .fullScreenCover(isPresented: $userModel.showPlantAnimation) {
                    PlantGrowing()
                        .environmentObject(userModel)
                }
            }
        }
    }
    
    struct MenuButton: View {
        var title: String
        var isStore: Bool
        
        var body: some View {
            ZStack {
                Capsule()
                    .fill(isStore ? Clr.gardenGreen : Clr.darkWhite)
                    .frame(width: 100, height: 35)
                    .neoShadow()
                Text(title)
                    .font(Font.fredoka(.regular, size: 16))
                    .foregroundColor(isStore ? .white : Clr.black1)
            }
        }
    }
    
    
}

struct Store_Previews: PreviewProvider {
    static var previews: some View {
        Store()
    }
}
