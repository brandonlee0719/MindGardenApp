//
//  IAPModal.swift
//  MindGarden
//
//  Created by Dante Kim on 4/3/22.
//

import SwiftUI
import Purchases
import AppsFlyerLib
import Amplitude

enum IAPType {
    case freeze,potion,chest
    var productId: String {
        switch self {
        case .freeze:
            return "io.bytehouse.mindgarden.freeze"
        case .potion:
            return "io.bytehouse.mindgarden.potion"
        case .chest:
            return "io.bytehouse.mindgarden.chest"
        }
    }
}

struct IAPModal: View {
    @EnvironmentObject var userModel: UserViewModel
    @Binding var shown: Bool
    var fromPage: String
    @State private var freezePrice = 0.0
    @State private var potionPrice  = 0.0
    @State private var chestPrice  = 0.0
    @State private var packagesAvailableForPurchase = [Purchases.Package]()
    @Binding var showAlert: Bool
    @State var isLoading = false
    //TODO if user has a potion or chest activated can't purchase more or the other.
    //TODO give user the ability to stack freeze streaks
    
    var body: some View {
        LoadingView(isShowing: $isLoading) {
            GeometryReader  { g in
                VStack(spacing: 10) {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            VStack(spacing: 0) {
                                ZStack(alignment: .top) {
                                    Img.coverImage
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: g.size.width * 0.85, height: g.size.height * 0.14)
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        withAnimation { shown.toggle() }
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.gray.opacity(0.85))
                                            .font(.system(size: 22))
                                            .padding()
                                    }.position(x: 30, y: 25)
                                }
                                Text("Potion Shop")
                                        .font(Font.fredoka(.bold, size: 20))
                                        .foregroundColor(Clr.black1)
                                        .padding(.top)
                                if userModel.streakFreeze > 0 {
                                    Text("You have \(userModel.streakFreeze) streak freeze" + "\(userModel.streakFreeze == 1 ? " " : "s ")" + "equipped")
                                        .font(Font.fredoka(.semiBold, size: 16))
                                        .foregroundColor(Clr.freezeBlue)
                                } else {
                                    Text("Purchases will activate immediately")
                                        .font(Font.fredoka(.semiBold, size: 16))
                                        .foregroundColor(Clr.black1)
                                        .opacity(0.8)
                                        .padding(.bottom)
                                }
                                
                                Spacer()
                                Spacer()
                                Spacer()
                            }
                            .frame(width: g.size.width * 0.85, height: g.size.height * (K.isSmall() ? 0.3 : 0.3), alignment: .top)
                            VStack {
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .IAP_tapped_freeze)
                                    onPurchase(type: .freeze)
                                } label: {
                                    PurchaseBox(width: g.size.width, height: g.size.height, img: Img.freezestreak, title: "Freeze Streak (2x)", subtitle: "Protect your streak (twice) if you a miss a day of meditation. ", price: freezePrice, type: .freeze)
                                }.padding(.bottom, 10)
                                Button {
                                    guard  !userModel.isPotion && !userModel.isChest else { return }
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .IAP_tapped_potion)
                                    onPurchase(type: .potion)
                                } label: {
                                    PurchaseBox(isEnabled: (!userModel.isPotion && !userModel.isChest), width: g.size.width, height: g.size.height, img: Img.sunshinepotion, title: "Sunshine Potion", subtitle: "Potion will activate & triple coins after every meditation for 1 WEEK", price: potionPrice, type: .potion)
                                }.padding(.bottom, 10)
                                Button {
                                    guard  !userModel.isPotion && !userModel.isChest else { return }
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .IAP_tapped_chest)
                                    onPurchase(type: .chest)
                                } label: {
                                    PurchaseBox(isEnabled: (!userModel.isPotion && !userModel.isChest), width: g.size.width, height: g.size.height, img: Img.sunshinechest, title: "Sunshine Chest", subtitle: "Potion will activate & triple coins after every meditation for 3 WEEKs", price: chestPrice, type: .chest)
                                }.padding(.bottom, 10)
                                 
                            }.frame(height: g.size.height * 0.4)
                            Spacer()
                        }
                        .frame(width: g.size.width * 0.85, height: g.size.height * (K.isSmall() ? 0.75 : 0.75), alignment: .center)
                        .background(Clr.darkWhite)
                        .cornerRadius(32)
                        Spacer()
                    }
                    Spacer()
                }
            }
        } .onAppear {
            Purchases.shared.offerings { [self] (offerings, error) in
                if let offerings = offerings {
                    let freeze = offerings["potion"]?.availablePackages[0]
                    let potion = offerings["streak_freeze"]?.availablePackages[0]
                    let chest = offerings["chest"]?.availablePackages[0]
                    
                    guard freeze != nil else { return }
                    guard potion != nil else { return }
                    guard chest != nil else { return }
        
                    let consumables = [freeze,potion, chest]
                    
                    
                    for i in 0...consumables.count - 1 {
                        let package = consumables[i]!
                        self.packagesAvailableForPurchase.append(package)
                        let product = package.product
                        let price = product.price
                        let name = product.productIdentifier
                        
                        if name == "io.bytehouse.mindgarden.freeze" {
                            freezePrice = round(100 * Double(truncating: price))/100
                        } else if name == "io.bytehouse.mindgarden.potion" {
                            potionPrice = round(100 * Double(truncating: price))/100
                        } else if name == "io.bytehouse.mindgarden.chest" {
                            chestPrice = round(100 * Double(truncating: price))/100
                        }
                    }
                }
            }

        }
    }
    
    private func onSuccess(type:IAPType) {
        isLoading = false
        switch type {
        case .freeze:
            userModel.streakFreeze += 2
        case .potion:
            userModel.potion = Date().getdateAfterweek(week: 1)?.toString() ?? ""
        case .chest:
            userModel.chest = Date().getdateAfterweek(week: 3)?.toString() ?? ""
        }
        userModel.saveIAP()
        userModel.updateSelf()
        showAlert = true
    }
    
    private func onPurchase(type:IAPType){
        isLoading = true
        let package = packagesAvailableForPurchase.last { (package) -> Bool in
            return package.product.productIdentifier == type.productId
        }!
        Purchases.shared.purchasePackage(package) { [self] (transaction, purchaserInfo, error, userCancelled) in
            if purchaserInfo != nil {
                onSuccess(type: type)
            }
        }
    }
    
    private func unlockPurchase(selectedBox: String) {
        var price = 0.0
        var package = packagesAvailableForPurchase[0]
        var event2 = "_started_from_all"
        var event3 = "cancelled_"
        switch selectedBox {
        case "freeze":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.bytehouse.mindgarden.freeze"
            }!
            price = freezePrice
            event2 = "freeze" + event2
            event3 += "freeze"
        case "potion":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.bytehouse.mindgarden.potion"
            }!
            price = potionPrice
            event2 = "potion" + event2
            event3 += "potion"
        case "chest":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.bytehouse.mindgarden.monthly"
            }!
            price = chestPrice
            event2 = "chest" + event2
            event3 += "chest"
        default: break
        }

        Purchases.shared.purchasePackage(package) { [self] (transaction, purchaserInfo, error, userCancelled) in
            let event = logEvent(selectedBox: selectedBox)
            let revenue = AMPRevenue().setProductIdentifier(event)
            revenue?.setPrice(NSNumber(value: price))

            if purchaserInfo?.entitlements.all["freeze"]?.isActive == true {
                logRevenue(event: event, event2: event2, price: price)
                userModel.streakFreeze += 2
//                userIsPro()
            } else if purchaserInfo?.entitlements.all["potion"]?.isActive == true  {
                logRevenue(event: event, event2: event2, price: price)
            } else if purchaserInfo?.entitlements.all["potion"]?.isActive == true  {
                logRevenue(event: event, event2: event2, price: price)
            } else if userCancelled {
                AppsFlyerLib.shared().logEvent(name: event3, values:
                                                [
                                                    AFEventParamContent: "true"
                                                ])
                Amplitude.instance().logEvent(event3)
            }
        }
    }
    
    private func logRevenue(event: String, event2: String, price: Double) {
        AppsFlyerLib.shared().logEvent(name: event, values:
                                                        [
                                                            AFEventParamContent: "true"
                                                        ])
        Amplitude.instance().logEvent(event2, withEventProperties: ["revenue": "\(price)"])
        Amplitude.instance().logEvent(event, withEventProperties: ["revenue": "\(price)"])

    AppsFlyerLib.shared().logEvent(name: event2, values:
                                                    [
                                                        AFEventParamContent: "true"
                                                    ])
    }
    
    private func logEvent(selectedBox: String) -> String {
            var event = ""

            switch selectedBox {
            case "freeze":
                event = "freeze_started_from_"
            case "potion":
                event = "potion_started_from_"
            case "chest":
                event = "chest_started_from_"
            default: break
            }
            event += fromPage
            return event
    }
    
    struct PurchaseBox: View {
        @EnvironmentObject var userModel: UserViewModel
        var isEnabled = true
        let width, height: CGFloat
        let img: Image
        let title: String
        let subtitle: String
        let price: Double
        let type: IAPType
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        var body: some View {
            ZStack(alignment: .center){
                Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(16)
                    .neoShadow()
                Capsule()
                    .fill(Clr.yellow)
                    .frame(width: 75, height: 25)
                    .neoShadow()
                    .opacity(isEnabled ? 1.0 : 0.5)
                    .overlay(HStack(spacing: 5) {
                        if (type == .potion && userModel.isPotion) || (type == .chest && userModel.isChest) {
                            Text("\(userModel.timeRemaining.stringFromTimeInterval())")
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.fredoka(.medium, size: 16))
                                .minimumScaleFactor(0.05)
                                .lineLimit(1)
                                
                        } else {
                            Img.moneybag
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12)
                                .opacity(isEnabled ? 1.0 : 0.5)
                            Text("\(price,  specifier: "%.2f")")
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.fredoka(.medium, size: 16))
                                .opacity(isEnabled ? 1.0 : 0.5)
                        }
                    })
                    .position(x: width * 0.635, y: height * 0.03)
                HStack(spacing: 10){
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(title)
                                .foregroundColor(title == "Freeze Streak (2x)" ? Clr.freezeBlue : Clr.sunshine)
                                .font(Font.fredoka(.bold, size: K.isSmall() ? 16 : 18))
                        }
                        Text(subtitle)
                            .foregroundColor(Clr.black2)
                            .font(Font.fredoka(.medium, size: 14))
                            .lineLimit(2)
                            .minimumScaleFactor(0.05)
                    }.frame(width: width * 0.5)
                        .padding(.trailing)
                        .multilineTextAlignment(.leading)
                }.frame(width: width * 0.75)
                    .opacity(isEnabled ? 1.0 : 0.5)
            }
            .onReceive(timer) { time in
                if userModel.timeRemaining > 0 {
                    userModel.timeRemaining -= 1
                }
            }
            .frame(width: width * 0.75, height: UIScreen.screenHeight * 0.125)
            .padding(.horizontal)
        }
    }
}

struct IAPModal_Previews: PreviewProvider {
    static var previews: some View {
        IAPModal(shown: .constant(false), fromPage: "home", showAlert: .constant(false))
    }
}
