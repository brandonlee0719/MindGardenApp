//
//  Garden.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI


var gardenSettings = false

struct Garden: View {
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var isMonth: Bool = true
    @State private var showSingleModal = false
    @State private var day: Int = 0
    @State private var topThreePlants: [FavoritePlant] = [FavoritePlant]()
    @State private var isOnboarding = false
    @State private var tileOpacity = 1.0
    @State private var gotItOpacity = 1.0
    @State private var forceRefresh = false
    @State private var color = Clr.yellow
    @Environment(\.sizeCategory) var sizeCategory
    @State var activeSheet: Sheet?
    @State private var showStreak: Bool = false
    @EnvironmentObject var bonusModel: BonusViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showImages = false
    @State private var plant: Plant?
    @State private var mood: Mood?
    
    var currentStreak : String {
        return "\(bonusModel.streakNumber)"
    }

    
    var longestStreak : Int {
        (UserDefaults.standard.value(forKey: "longestStreak")) as? Int ?? 1
    }
    
    var tappedTile : Bool {
        UserDefaults.standard.bool(forKey: "tappedTile")
    }
    
    @State private var playEntryAnimation = false
    private let animation = Animation.interpolatingSpring(stiffness: 50, damping: 26)
    
    
    enum MonthlyState: String, CaseIterable {
        var id: String { return self.rawValue }
        
        case currentStreak
        case breathwork
        case meditations
        case reflections
        case totaltime
        
        var color:Color {
            switch self {
            case .currentStreak:
                return Clr.redGradientBottom
            case .breathwork:
                return Clr.brightGreen
            case .meditations:
                return Clr.brightGreen
            case .reflections:
                return Clr.brightGreen
            case .totaltime:
                return Clr.black2
            }
        }
        
        var image:Image {
            switch self {
            case .currentStreak:
                return Img.streak
            case .breathwork:
                return Img.breathIcon
            case .meditations:
                return Img.meditatingTurtle
            case .reflections:
                return Img.streakPencil
            case .totaltime:
                return Img.alarmClock
            }
        }
        
        var title:String {
            switch self {
            case .currentStreak:
                return "Current Streak"
            case .breathwork:
                return "Breathwork"
            case .meditations:
                return "Meditations"
            case .reflections:
                return "Reflections"
            case .totaltime:
                return "Total Time"
            }
        }
    }
    
    var body: some View {
        GeometryReader { gp in
            ZStack {
                Img.gardenBackground
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 32)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 20) {
                        //Version 2
                        //                    HStack(spacing: 40) {
                        //                        Button {
                        //                            isMonth = true
                        //                        } label: {
                        //                            MenuButton(title: "Month", isMonth: isMonth)
                        //                        }
                        //                        Button {
                        //                            isMonth = false
                        //                        } label: {
                        //                            MenuButton(title: "Year", isMonth: !isMonth)
                        //                        }
                        //                    }
                        HStack {
                            Text("Your Garden")
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(Color.white)
                                .padding()
                            Spacer()
                            HStack {
                                Button {
                                    Analytics.shared.log(event: .garden_tapped_plant_select)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                                    showPlant = true
                                    activeSheet = .plant
                                } label: {
                                    HStack {
                                        userModel.selectedPlant?.head
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25)

                                    }
                                    .frame(width: 30, height: 20)
                                    .roundedCapsule()
                                }.buttonStyle(ScalePress())
                                Button {
                                    Analytics.shared.log(event: .garden_tapped_settings)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        gardenSettings = true
                                        activeSheet = .profile
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "gearshape.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Clr.black2)
                                            .frame(width: 20, height: 20)
                                    }      .frame(width: 30, height: 20)
                                        .roundedCapsule()
                                }
                                .buttonStyle(ScalePress())
                                Button {
                                    Analytics.shared.log(event: .garden_tapped_settings)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        if UserDefaults.standard.bool(forKey: "isPro") {
                                            showImages.toggle()
                                            UserDefaults.standard.setValue(showImages, forKey: "showImages")
                                        } else {
                                            fromPage = "garden"
                                            viewRouter.currentPage = .pricing
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "photo.on.rectangle.angled")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(showImages ? .white : Clr.black2)
                                            .frame(width: 20, height: 20)
                                    }.frame(width: 30, height: 20)
                                    .roundedCapsule(color: showImages ? Clr.brightGreen : Clr.yellow)
                                }
                                .buttonStyle(ScalePress())
                            }
                        }.frame(width: gp.size.width * 0.875)
                        .padding(.bottom, -10)
                        .offset(x: -10)
                        .padding(.top)
                        

//                        Text("Calendar/Garden")
//                            .foregroundColor(.black)
//                            .font(Font.fredoka(.semiBold, size: forceRefresh ? 20 : 20.1))
//                            .offset(x: UIScreen.screenWidth * -0.25 + 10, y: playEntryAnimation ? 10 : 400)
//                            .animation(animation.delay(0.4), value: playEntryAnimation)
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Clr.darkWhite)
//                                .addBorder(Clr.brightGreen, width: 1.5, cornerRadius: 20)
                            VStack(spacing:0) {
                                GridStack(rows: Date.needsExtraRow(month: gardenModel.selectedMonth, year: gardenModel.selectedYear) ? 6 : 5, columns: 7) { row, col in
                                    let c = gardenModel.placeHolders
                                    let currentDate = col + (row * 7) + 1 - c
                                    let maxDate = Date().getNumberOfDays(month: String(gardenModel.selectedMonth),year:String(gardenModel.selectedYear))
                                    
                                    let plant = gardenModel.monthTiles[row]?[currentDate]?.0
                                    let mood = gardenModel.monthTiles[row]?[currentDate]?.1
                                    ZStack {
                                        Rectangle()
                                            .fill(mood != nil ? gardenModel.monthTiles[row]?[currentDate]?.1?.color ?? Clr.calenderSquare : Clr.calenderSquare)
                                            .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                            .border(.white, width: 1)
                                            .opacity((plant != nil && mood != nil ) ? (!tappedTile ? tileOpacity : 1) : 1 )
                                            .animation(Animation.easeInOut(duration:0.5).repeatForever(autoreverses:true), value: tileOpacity)
                                            .overlay(
                                                PhotoCalender(showImages: $showImages, tileOpacity: $tileOpacity, tappedTile: .constant(tappedTile), row: row, currentDate: currentDate,plant: plant, mood: mood, maxDate: maxDate)
                                            )
                                    }
                                    .onTapGesture {
                                        Analytics.shared.log(event: .garden_tapped_single_day)
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        day = col + (row * 7) + 1  - gardenModel.placeHolders
                                        if gardenModel.monthTiles[row]?[col + (row * 7) + 1 - gardenModel.placeHolders]?.0?.title != "Ice Flower" {
                                            if !tappedTile {
                                                if (gardenModel.monthTiles[row]?[col + (row * 7) + 1 - gardenModel.placeHolders]?.0 != nil || gardenModel.monthTiles[row]?[col + (row * 7) + 1 - gardenModel.placeHolders]?.1 != nil)  {
                                                    Analytics.shared.log(event: .onboarding_finished_single)
                                                    if (plant != nil || mood != nil) {
                                                        self.plant = plant
                                                        self.mood = mood
                                                        showSingleModal = true
                                                        isOnboarding = false
                                                    }
                                                    UserDefaults.standard.setValue(true, forKey: "tappedTile")
                                                }
                                            } else {
                                                if day <= 31 && day >= 1 {
                                                    if (plant != nil || mood != nil) {
                                                        self.plant = plant
                                                        showSingleModal = true
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(3)
                                .zIndex(-1000)
                                
                                HStack {
                                    Text("\(Date().getMonthName(month: String(gardenModel.selectedMonth))) \(String(gardenModel.selectedYear).withReplacedCharacters(",", by: ""))")
                                        .font(Font.fredoka(.semiBold, size: 20))
                                        .foregroundColor(Clr.black2)
                                        .padding(.leading, 12)
                                    Spacer()
                                    Button {
                                        withAnimation {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            Analytics.shared.log(event: .garden_previous_month)
                                            if gardenModel.selectedMonth == 1 {
                                                gardenModel.selectedMonth = 12
                                                gardenModel.selectedYear -= 1
                                            } else {
                                                gardenModel.selectedMonth -= 1
                                            }
                                            gardenModel.populateMonth()
                                            getFavoritePlants()
                                        }
                                    } label: {
                                        OperatorButton(imgName: "lessthan")
                                            .neoShadow()
                                    }
                                    Button {
                                        withAnimation {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            Analytics.shared.log(event: .garden_next_month)
                                            if gardenModel.selectedMonth == 12 {
                                                gardenModel.selectedMonth = 1
                                                gardenModel.selectedYear += 1
                                            } else {
                                                gardenModel.selectedMonth += 1
                                            }
                                            gardenModel.populateMonth()
                                            getFavoritePlants()
                                        }
                                    } label: {
                                        OperatorButton(imgName: "greaterthan")
                                            .neoShadow()
                                    }
                                }
                                .padding(10)
                                .padding(.bottom)
                            }.frame(width:UIScreen.screenWidth*0.85, alignment: .center)
                        }
                        .background(Clr.darkWhite)
                        .cornerRadius(16)
//                        .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                        .rightShadow()
                        .offset(y: playEntryAnimation ? 0 : 200)
                        .animation(animation.delay(0.1), value: playEntryAnimation)
                        .padding(5)
                        .padding(.vertical)
                        
                        monthlyStateView
                            .padding(.vertical)
                            .offset(x: playEntryAnimation ? 0 : 200)
                            .animation(animation.delay(0.1), value: playEntryAnimation)
                        
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(16)
                                .rightShadow()
                                .frame(maxWidth: gp.size.width * 0.85)
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Favorite Plants")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.semiBold, size: forceRefresh ? 20 : 20.1))
                                    .padding(.leading, gp.size.width * 0.075 - 25)
                                    .padding(.top, 8)
                                    .padding(.leading, 24)
                                
                                if topThreePlants.isEmpty {
                                    Spacer()
                                }
                                
                                HStack(spacing: 5){
                                    Spacer()
                                    if topThreePlants.isEmpty {
                                        Text("You have no favorite plants")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.fredoka(.regular, size: 20))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.05)
                                            .padding()
                                    } else {
                                        if !topThreePlants.isEmpty, let favPlant1 = topThreePlants[0] {
                                            favPlant1
                                        }
                                        if topThreePlants.count > 1, let favPlant2 = topThreePlants[1] {
                                            favPlant2
                                        }
                                        if topThreePlants.indices.contains(2), let favPlant3 = topThreePlants[2] {
                                            favPlant3
                                        }
                                    }
                                    Spacer()
                                }
                                if topThreePlants.isEmpty {
                                    Spacer()
                                }
                                
                            }.frame(width: gp.size.width * (sizeCategory > .large ? 1 : 0.85), height: 200)
                        }.padding(.top, 8)
                            .offset(y: playEntryAnimation ? 0 : 400)
                            .animation(animation.delay(0.4), value: playEntryAnimation)
                            .padding(.top)
                            .padding(.bottom, 48)
                    }.padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .padding(.top, 32)
                    if isOnboarding && (UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" ) {
                        VStack(spacing: 0) {
                            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" {
                                Triangle()
                                    .fill(Clr.yellow)
                                    .frame(width: 40, height: 20)
                            }
                            Rectangle()
                                .fill(Clr.yellow)
                                .frame(width: 250, height: 140)
                                .overlay(
                                    VStack {
                                        Text(UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate"  ? "📅 This is your calendar view of the month (color of the tile = your mood)" : "📊 These are your monthly statistics")
                                            .font(Font.fredoka(.semiBold, size: 18))
                                            .lineLimit(3)
                                            .minimumScaleFactor(0.05)
                                            .multilineTextAlignment(.center)
                                            .padding(.bottom, 5)
                                            .foregroundColor(Color.black)
                                        Text("Got it")
                                            .foregroundColor(Color.white)
                                            .colorMultiply(self.color)
                                            .font(Font.fredoka(.bold, size: 18))
                                            .onAppear {
                                                withAnimation {
                                                    self.color = Clr.darkgreen
                                                }
                                            }
                                            .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses:true), value: self.color)
                                            .onTapGesture {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                withAnimation {
                                                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" {
                                                        Analytics.shared.log(event: .onboarding_finished_calendar)
                                                        UserDefaults.standard.setValue("calendar", forKey: K.defaults.onboarding)
                                                    } else if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" {
                                                        UserDefaults.standard.setValue("stats", forKey: K.defaults.onboarding)
                                                        Analytics.shared.log(event: .onboarding_finished_stats)
                                                    }
                                                    forceRefresh.toggle()
                                                }
                                            }
                                    }.padding()
                                )
                                .cornerRadius(16)
                            
                            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" {
                                Triangle()
                                    .fill(Clr.yellow)
                                    .frame(width: 40, height: 20)
                                    .rotationEffect(.radians(.pi))
                            }
                        }.offset(y: UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" ? K.isSmall() ? -175 : -125 : -75)
                    }
                    if isOnboarding {
                        switch UserDefaults.standard.string(forKey: K.defaults.onboarding) {
                        case "meditate":
                            Img.calendarRacoon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 125)
                                .position(x: gp.size.width/2, y: gp.size.height/1.3)
                        case "calendar":
                            Img.statRacoon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 125)
                                .position(x: gp.size.width/2, y: gp.size.height/3.25)
                        case "stats":
                            Img.calendarRacoon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 125)
                                .position(x: gp.size.width - 100, y:  gp.size.height/1.75)
                        default: EmptyView()
                        }
                    }
                    // TODO  fix day4 being set to true on launch
                }.padding(.bottom ,50)
            }.fullScreenCover(isPresented: $userModel.triggerAnimation) {
                PlantGrowing()
            }
            .popover(isPresented: $showSingleModal) {
                SingleDay(showSingleModal: $showSingleModal, day: $day, month: gardenModel.selectedMonth, year: gardenModel.selectedYear, plant: $plant, mood: $mood, grid: $gardenModel.grid)
                    .environmentObject(gardenModel)
                    .navigationViewStyle(StackNavigationViewStyle())
            }.onAppear {
               
                viewRouter.previousPage = .garden
                DispatchQueue.main.async {
                    withAnimation {
                        playEntryAnimation = true
                    }
                    getFavoritePlants()
                    if !tappedTile {
                        isOnboarding = true
                        tileOpacity = 0.2
                        if let onboardingNotif = UserDefaults.standard.value(forKey: "onboardingNotif") as? String {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [onboardingNotif])
                        }
                    }
                }
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
                    EmptyView()
                case .streak:
                    StreakScene(showStreak: $showStreak)
                case .mood:
                    EmptyView()
                }
            }
            .onAppearAnalytics(event: .screen_load_garden)
        }
    }
    
    var monthlyStateView: some View {
        VStack(spacing:5) {
            VStack(spacing:5) {
                HStack {
                    Text("Monthly Stats")
                        .foregroundColor(Clr.black2)
                        .font(Font.fredoka(.semiBold, size: forceRefresh ? 20 : 20.1))
                        .padding(.leading,25)
                    Spacer()

                    Image(systemName: "chevron.forward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:10)
                        .foregroundColor(Clr.black2)
                        .padding(.trailing,20)
                        .opacity(0.5)
                        .neoShadow()
                }
                .padding(.top,20)
                HStack(spacing: 15) {
                    ZStack {
                        Rectangle()
                            .fill(Clr.darkWhite)
//                            .addBorder(.black, width: 1.5, cornerRadius: 16)
                            .cornerRadius(8)
                            .neoShadow()
                            .frame(width:UIScreen.screenWidth * 0.46)
                        VStack(spacing:0) {
                            ForEach(MonthlyState.allCases, id: \.id) { state in
                                HStack(spacing:15) {
                                    state.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:20)
                                    Text(state.title)
                                        .foregroundColor(Clr.black2)
                                        .font(Font.fredoka(.medium, size: 12))
                                        .frame(maxWidth:.infinity,alignment:.leading)
                                    Text(getStateValue(type:state))
                                        .foregroundColor(state.color)
                                        .font(Font.fredoka(.semiBold, size: 16))
                                }
                                .padding(.vertical,3)
                                .padding(.horizontal)
                            }
                        }
                    }
                    ZStack {
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .cornerRadius(8)
                            .neoShadow()
                            
                        VStack(spacing:0) {
                            MoodImage(mood: .veryGood, value: gardenModel.totalMoods[.veryGood] ?? 0)
                            MoodImage(mood: .good, value: gardenModel.totalMoods[.good] ?? 0)
                            MoodImage(mood: .okay, value: gardenModel.totalMoods[.okay] ?? 0)
                            MoodImage(mood: .bad, value: gardenModel.totalMoods[.bad] ?? 0)
                            MoodImage(mood: .veryBad, value: gardenModel.totalMoods[.veryBad] ?? 0)
                        }.padding(.vertical, 12)
                    }.padding(.trailing,20)
                }
                .padding([.horizontal,.bottom],20)
            }.frame(width:UIScreen.screenWidth*0.85)
        }.background(
            Rectangle()
                .fill(Clr.darkWhite)
                .cornerRadius(16)
                .rightShadow()
        ).onTapGesture {
            withAnimation {
                Analytics.shared.log(event: .garden_tapped_monthly_stats)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                activeSheet = .profile
            }
        }
    }
    
    private func getStateValue(type:MonthlyState) -> String {
        switch type {
        case .currentStreak:
            return self.currentStreak
        case .breathwork:
            return "\(gardenModel.monthlyBreaths)"
        case .meditations:
            return "\(gardenModel.monthlyMeds)"
        case .reflections:
            return "\(gardenModel.gratitudes)"
        case .totaltime:
            return "\(Helper.minuteandhours(seconds: Double(gardenModel.totalMins), isNewLine: false))"
        }
    }
    
    private func getFavoritePlants() {
        topThreePlants = [FavoritePlant]()
        let topThreeStrings = gardenModel.favoritePlants.sorted { $0.value > $1.value }.prefix(3)
        for str in topThreeStrings {
            if let plnt = Plant.allPlants.first(where: { plt in
                plt.title == str.key
            }) {
                topThreePlants.append(FavoritePlant(title: str.key, count: str.value,
                                                    img: plnt.coverImage))
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}


//MARK: - preview
struct Garden_Previews: PreviewProvider {
    static var previews: some View {
        Garden().environmentObject(GardenViewModel())
    }
}

//MARK: - components
struct PhotoCalender: View {
    @Binding var showImages:Bool
    @Binding var tileOpacity:Double
    @Binding var tappedTile:Bool
    @EnvironmentObject var gardenModel: GardenViewModel
    var row: Int
    var currentDate: Int
    var plant:Plant?
    var mood:Mood?
    let maxDate:Int
    
    var showTileDate : Bool {
        UserDefaults.standard.bool(forKey: "tileDates")
    }
    
    var body: some View {
        ZStack {
            if let imgUrl = gardenModel.getImagePath(month: String(gardenModel.selectedMonth), day:"\(currentDate)"), showImages {
                UrlImageView(urlString: imgUrl)
                    .padding(1)
            }
            
            if !showImages {
                if plant != nil,!showImages {
                    PlantHead(row:row, currentDate:currentDate, month: String(gardenModel.selectedMonth))
                        .opacity((plant != nil && mood != nil ) ? (!tappedTile ? tileOpacity : 1) : 1 )
                        .animation(Animation.easeInOut(duration:0.5).repeatForever(autoreverses:true), value: tileOpacity)
                }
            } else {
                VStack {
                    Spacer()
                    HStack {
                        ZStack {
                            HStack(spacing: 0) {
                                if let mood = mood {
                                    ZStack {
                                        Mood.getMoodImage(mood: mood)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(.vertical, 3)
                                            .padding(.leading, plant != nil ? 3 : 0)
                                    }.frame(width: 16, height: 16)
                                }
                                if plant != nil {
                                    PlantHead(row:row, currentDate:currentDate, month: String(gardenModel.selectedMonth))
                                        .opacity((plant != nil && mood != nil ) ? (!tappedTile ? tileOpacity : 1) : 1 )
                                        .animation(Animation.easeInOut(duration:0.5).repeatForever(autoreverses:true), value: tileOpacity)
                                        .frame(width:16,height:16)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius:8)
                                    .fill(Clr.darkWhite)
                            )
                            .padding(4)
                        }
                        Spacer()
                    }
                }
            }
            
            Text((currentDate <= maxDate && currentDate > 0 ) ? "\(currentDate)" : "").offset(x: 5, y: 15)
                .font(Font.fredoka(.semiBold, size: 8))
                .foregroundColor(Color.black)
                .padding(.leading)
                .opacity(showTileDate ? 1.0 : 0)
        }
    }
}
struct MoodImage: View {
    let mood: Mood
    let value: Int
    @Environment(\.sizeCategory) var sizeCategory
    var isStressed: Bool {
        return mood == .stressed
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Mood.getMoodImage(mood: mood)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24)
                .padding(.leading, 2)
            Text(String(value))
                .font(Font.fredoka(.semiBold, size: 16))
                .foregroundColor(mood.color)
                .lineLimit(1)
                .frame(width: 15)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .padding(.leading, 10)
        }.frame(height:30)
    }
}

struct MenuButton: View {
    var title: String
    var isMonth: Bool
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(isMonth ? Clr.gardenGreen : Clr.darkWhite)
                .frame(width: 100, height: 35)
                .rightShadow()
            Text(title)
                .font(Font.fredoka(.regular, size: 16))
                .foregroundColor(isMonth ? .white : Clr.black1)
        }
    }
}

struct OperatorButton: View {
    let imgName: String
        
    var body: some View {
            ZStack {
                Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(8)
                    .frame(width: 36, height: 36)
                Image(systemName: imgName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Clr.darkgreen)
                    .frame(height: 15)
                    .font(Font.title.weight(.bold))
            }
    }
}

struct FavoritePlant: View {
    let title: String
    let count: Int
    let img: Image
    
    var body: some View {
        VStack(spacing: 0) {
            img
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(8)
                .frame(height: 90)
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Clr.darkgreen))
            HStack {
                Text("\(title)")
                    .font(Font.fredoka(.regular, size: 12))
                    .lineLimit(2)
                    .minimumScaleFactor(0.05)
                Text("\(count)").bold()
                    .font(Font.fredoka(.bold, size: 20))
            }.padding(.top, 8)
            .frame(width: 70, height: 30)
        }.frame(height: 120)
            .padding(10)
    }
}



struct PlantHead: View {
    @EnvironmentObject var gardenModel: GardenViewModel
    @State var row: Int
    @State var currentDate: Int
    @State var month: String
    @State private var isOnboarding = false
    @State private var tileOpacity = 1.0
    @State private var showImage = true

    var body: some View {
        ZStack {
            gardenModel.monthTiles[row]?[currentDate]?.0?.head
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(3)
        }
    }
}
