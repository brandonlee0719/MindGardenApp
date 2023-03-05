//
//  FloatingMenu.swift
//  MindGarden
//
//  Created by Vishal Davara on 06/09/22.
//

import SwiftUI


enum MenuType: String, CaseIterable {
    case bonus, profile,recent,favorites, plantselect
    var id: String { return self.rawValue }
    
    var image:Image {
        switch self {
        case .profile:
            return Img.menuProfile
        case .bonus:
            return Img.coin
        case .favorites:
            return Img.menuFavourite
        case .recent:
            return Img.menuRecent
        case .plantselect:
            return Img.menuPlantSelect
        }
    }
    
    var delay:Double {
        switch self {
        case .profile:
            return 2.0
        case .bonus:
            return 1.0
        case .favorites:
            return 4.0
        case .recent:
            return 3.0
        case .plantselect:
            return 5.0
        }
    }
}

struct FloatingMenu: View {
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    @Binding var showModal : Bool
    @Binding var activeSheet: Sheet?
    @Binding var totalBonuses : Int
    
    @State var isOpen = false
    @State var width = 60.0
    @State var scale = 0.0
    @State var offset = 0
    @State var rotation = 0.0
    @State var sheetTitle: String = ""
    @State var showRecFavs = false
    @State var sheetType: [Int] = []
    @State var offsetY = 160
    @State var isOpenAnimation = false
    
    let animation = Animation.spring()
    var body: some View {
        ZStack(alignment:.top) {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                DispatchQueue.main.async {
                    isOpen.toggle()
                }
            } label: {
                if isOpen {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height:20)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Capsule().fill(Clr.redGradientBottom).opacity(0.85))
                        .overlay(Capsule().stroke(.black, lineWidth: 1))
                } else {
                    Group {
                        if totalBonuses > 0 {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height:20)
                                .foregroundColor(.black)
                                .padding(12)
                                .background(Capsule().fill(Clr.yellow))
                                .overlay(Capsule().stroke(.black, lineWidth: 1))
                                .overlay(badgeIcon)
                                .wiggling1()
                        } else {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height:20)
                                .foregroundColor(.black)
                                .padding(12)
                                .background(Capsule().fill(Clr.yellow))
                                .overlay(Capsule().stroke(.black, lineWidth: 1))
                                .overlay(badgeIcon)
                        }
                    }
                }
            }.rotationEffect(Angle(degrees: rotation))
            .buttonStyle(ScalePress())
        }
        .onChange(of: isOpen) { newVal in
            if newVal {
                offset = -50
                rotation = 0.0
                isOpenAnimation = false
                DispatchQueue.main.async {
                    withAnimation(animation) {
                        offset = 0
                        rotation = 90
                        isOpenAnimation = true
                    }
                }
            } else {
                rotation = 0.0
                scale = 1.0
                isOpenAnimation = true
                DispatchQueue.main.async {
                    withAnimation(animation) {
                        isOpenAnimation = false
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    scale = 0.0
                }
            }
        }
        .background(
            ZStack {
                if isOpen {
                    Color.black.opacity(0.4)
                        .onTapGesture {
                            isOpen = false
                        }
                }
            }
                .frame(width: UIScreen.screenWidth*2.5, height: UIScreen.screenHeight*3.5, alignment: .center)
        )
        .overlay(menuItem)
        .sheet(isPresented: $showRecFavs) {
            ShowRecsScene(meditations: sheetType, title: $sheetTitle)
        }
        
    }
    var badgeIcon: some View {
        ZStack {
            if totalBonuses > 0, !isOpen {
                HStack(spacing:0) {
                    ZStack {
                        Circle()
                            .frame(width:20, height: 20)
                            .foregroundColor(Clr.redGradientBottom)
                            .overlay(Capsule().stroke(.black, lineWidth: 1))
                        Text("\(totalBonuses)")
                            .font(Font.fredoka(.medium, size: 12))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.005)
                            .frame(width: 10)
                    }.frame(width: 15)
                }
            }
        }.offset(x:width/3.5,y:-width/3.5)
    }
    
    var menuItem: some View {
        VStack(alignment:.leading, spacing:10) {
            ForEach(MenuType.allCases, id: \.id) { state in
                if (state != .favorites || (state == .favorites && !medModel.favoritedMeditations.isEmpty)) && (state != .recent || (state == .recent && !userModel.completedMeditations.isEmpty)) {
                    Button {
                        if isOpen {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            DispatchQueue.main.async {
                                buttonAction(type: state)
                            }
                        }
                    } label: {
                        MenuView(state: state, totalBonuses: $totalBonuses)
                    }
                    .buttonStyle(ScalePress())
                    .scaleEffect(isOpen ? 1.0 : scale, anchor: .leading)
                    .offset(y:isOpenAnimation ? 0 : -((state.delay) * 40))
                } else {
                    EmptyView()
                        .frame(height:0)
                }
            }
        }.frame(width: 300, alignment: .leading)
            .opacity(isOpenAnimation ? 1.0 : 0.0)
            .offset(x:(width*2)+10,y: CGFloat(offsetY))
            .onAppear {
                if userModel.completedMeditations.isEmpty && medModel.favoritedMeditations.isEmpty {
                    offsetY = 105
                } else if userModel.completedMeditations.isEmpty || medModel.favoritedMeditations.isEmpty {
                    offsetY = 130
                }
            }
    }
    
    private func buttonAction(type:MenuType) {
        isOpen.toggle()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        switch type {
        case .profile:
            Analytics.shared.log(event: .home_tapped_profile)
            activeSheet = .profile
        case .bonus:
            Analytics.shared.log(event: .home_tapped_bonus)
            withAnimation {
                DispatchQueue.main.async {
                    showModal = true
                }
            }
        case .favorites:
            Analytics.shared.log(event: .home_tapped_favorites)
            withAnimation {
                sheetTitle = "Your Favorites"
                sheetType = medModel.favoritedMeditations.reversed()
                showRecFavs = true
            }
  
            break
        case .recent:
            Analytics.shared.log(event: .home_tapped_recents)
            withAnimation {
                sheetTitle = "Your Recents"
                sheetType = userModel.completedMeditations.compactMap({ Int($0)}).reversed().unique()
                showRecFavs = true
            }
            break
        case .plantselect:
            Analytics.shared.log(event: .home_tapped_plant_select)
            activeSheet = .plant
        }
    }
    
    struct MenuView: View {
        var state:MenuType
        @Binding var totalBonuses : Int
        @EnvironmentObject var userModel: UserViewModel
        @EnvironmentObject var medModel: MeditationViewModel
        @EnvironmentObject var bonusModel: BonusViewModel
        
        var body: some View {
            HStack {
                if totalBonuses > 0, state == .bonus {
                    HStack(spacing:0) {
                        ZStack {
                            Circle().frame(width:20,height: 20)
                                .foregroundColor(Clr.redGradientBottom)
                                .overlay(Capsule().stroke(.black, lineWidth: 1))
                            Text("\(totalBonuses)")
                                .font(Font.fredoka(.medium, size: 12))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.005)
                                .frame(width: 10)
                        }.frame(width: 15)
                            .padding([.leading,.vertical],10)
                            .padding(.trailing,10)
                        Text(getTitle(type:state))
                            .font(Font.fredoka(.medium, size: 16))
                            .foregroundColor(Clr.redGradientBottom)
                            .padding([.trailing,.vertical],10)
                    }
                    .background(
                        Rectangle()
                            .fill(Clr.yellow)
                            .addBorder(.black, cornerRadius: 25)
                            .frame(height: 35)
                    ).wiggling1()
                }
                else {
                    HStack(spacing:0) {
                        state.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:20)
                            .padding([.leading,.vertical],10)
                            .padding(.trailing,10)
                        Group {
                            if state == .bonus {
                                Text("\(userModel.coins)")
                            } else {
                                Text(getTitle(type:state))
                            }
                        }
                        .font(Font.fredoka(.medium, size: 16))
                        .foregroundColor( Clr.black2)
                        .padding([.trailing,.vertical],10)
                    }
                    .background(
                        Rectangle()
                            .fill(Clr.yellow)
                            .addBorder(.black, cornerRadius: 25)
                            .frame(height: 35)
                    )
                }
            }
        }
        
        private func getTitle(type:MenuType) -> String {
            switch type {
            case .profile:
                return "Profile"
            case .bonus:
                return "Bonus!"
            case .favorites:
                return "Favorites"
            case .recent:
                return "Recent"
            case .plantselect:
                return "Plant Select"
            }
        }
    }
}
