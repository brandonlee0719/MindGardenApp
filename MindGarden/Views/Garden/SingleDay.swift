//
//  SingleDay.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI
import StoreKit
//TODO - fix iphone 8 bug, selectedplant bug.
struct SingleDay: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @Binding var showSingleModal: Bool
    @Binding var day: Int
    var month: Int
    var year: Int
    @State var moods: [[String: String]]?
    @State var journals: [[String:String]]?
    @State var sessions: [[String: String]]?
    @State var totalTime: Int = 0
    @State var totalSessions: Int = 0
    @State var minutesMeditated: Int = 0
    @Binding var plant: Plant?
    @State var sessionCounter: Int = 0
    @State var showOnboardingModal = false
    @State private var showLoading = false
    @Binding var mood: Mood?
    @Binding var grid: [String : [String : [String : [String : Any]]]]
    init(showSingleModal: Binding<Bool>, day: Binding<Int>, month: Int, year: Int, plant: Binding<Plant?>, mood: Binding<Mood?>, grid: Binding<[String : [String : [String : [String : Any]]]]>) {
        self._showSingleModal = showSingleModal
        self._day = day
        self.month = month 
        self.year = year
        self._plant = plant
        self._mood = mood
        self._grid = grid
    }

    var body: some View {
            NavigationView {
                LoadingView(isShowing: $showLoading) {
                GeometryReader { g in
                    ZStack {
                        Clr.darkWhite.edgesIgnoringSafeArea(.all)
                        VStack(alignment: .leading) {
                            ZStack {
                                Img.greenBlob
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: g.size
                                        .width/1, height: g.size.height/1.6)
                                    .offset(x: g.size.width/6, y: -g.size.height/4)
                                if plant != nil {
                                    HStack {
                                        if sessionCounter - 1 >= 0 {
                                            Button {
                                                Analytics.shared.log(event: .garden_tapped_single_previous_session)
                                                withAnimation {
                                                    if sessionCounter > 0 {
                                                        sessionCounter -= 1
                                                        updateSession()
                                                    }
                                                }
                                            } label: {
                                                Image(systemName: "chevron.left")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .aspectRatio(contentMode: .fit)
                                                    .font(Font.title.weight(.bold))
                                                    .frame(width: 30)
                                                    .foregroundColor(Clr.darkWhite)
                                                    .padding()
                                                    .offset(y: -25)
                                            }.buttonStyle(NeumorphicPress())
                                        }
                                        Spacer()
                                        plant?.coverImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: g.size.width/2.2, height: g.size.height/2)
                                            .offset(y: -35)
                                        Spacer()
                                        if sessionCounter + 1 < totalSessions {
                                            Button {
                                                Analytics.shared.log(event: .garden_tapped_single_next_session)
                                                withAnimation {
                                                    if sessionCounter < totalSessions - 1 {
                                                        sessionCounter += 1
                                                        updateSession()
                                                    }
                                                }
                                            } label: {
                                                Image(systemName: "chevron.right")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .aspectRatio(contentMode: .fit)
                                                    .font(Font.title.weight(.bold))
                                                    .frame(width: 30)
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .offset(y: -25)
                                                    .shadow(radius: 10)
                                            }
                                        }
                                    }
                                } else {
                                    Text("No sessions for \nthis day :(")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.fredoka(.semiBold, size: 28))
                                        .multilineTextAlignment(.center)
                                        .padding(24)
                                        .background(
                                            RoundedRectangle(cornerRadius:8)
                                                .fill(Clr.darkWhite)
                                                .rightShadow()
                                        )
                                        .offset(y: -65)
                                    
                                }
                            }.padding(.bottom, -95)
                            Text("Stats For the Day: ")
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.semiBold, size: 26))
                                .padding(.leading, g.size.width * 0.1)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            HStack(spacing: 15) {
                                VStack(spacing: 10) {
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(Clr.darkWhite)
                                            .addBorder(.black, width: 1.5, cornerRadius: 14)
                                            .neoShadow()
                                        VStack(alignment:.center, spacing:5){
                                            Text("Total Mins")
                                                .font(Font.fredoka(.regular, size: 16))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.horizontal, 5)
                                                .padding(.top,10)
                                            HStack(spacing:25) {
                                                Img.iconTotalTime
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 30)
                                                    .offset(x: 3)
                                                Text(totalTime/60 == 0 && totalTime != 0 ? "0.5" : "\(totalTime/60) min")
                                                    .font(Font.fredoka(.semiBold, size: 16))
                                                    .minimumScaleFactor(0.7)
                                                    .foregroundColor(Clr.black2)
                                                    .offset(x: -5)
                                            }
                                            .padding(.bottom,10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }.padding(.horizontal, 15)
                                    }.frame(width: g.size.width * 0.3)
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(Clr.darkWhite)
                                            .addBorder(.black, width: 1.5, cornerRadius: 14)
                                            .neoShadow()
                                        VStack(alignment:.leading, spacing:5){
                                            Text("Sessions")
                                                .font(Font.fredoka(.regular, size: 16))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.horizontal, 5)
                                                .padding(.top,10)
                                            HStack(spacing:15) {
                                                Img.iconSessions
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 30)
                                                    .offset(x: 3)
                                                Text("\(totalSessions)")
                                                    .font(Font.fredoka(.semiBold, size: 16))
                                                    .minimumScaleFactor(0.7)
                                                    .foregroundColor(Clr.black2)
                                            }
                                            .padding(.bottom,10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }.padding(.horizontal, 15)
                                    }.frame(width: g.size.width * 0.3)
                                    ZStack {
                                        Rectangle()
                                            .fill(Clr.darkWhite)
                                            .cornerRadius(14)
                                            .addBorder(.black, width: 1.5, cornerRadius: 14)
                                            .neoShadow()
                                        VStack(spacing: -5) {
                                            Text("Moods: ")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.fredoka(.regular, size: 16))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(5)
                                            HStack(spacing: 0) {
                                                ForEach(self.moods ?? [["mood": "none"]], id: \.self) { mood in
                                                    if mood["mood"] != "none" {
                                                        Mood.getMoodImage(mood: Mood.getMood(str: mood["mood"] ?? "okay"))
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .padding(5)
                                                    }
                                                }
                                            }.frame(maxWidth: .infinity, maxHeight: g.size.height * 0.07, alignment: .leading)
                                        }.padding(.horizontal, 15)
                                    }
                                    .frame(width: g.size.width * 0.30)
                                }
                                .frame(maxWidth: g.size.width * 0.4)
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .cornerRadius(14)
                                        .addBorder(.black, width: 1.5, cornerRadius: 14)
                                        .neoShadow()
                                    VStack(spacing: 5){
                                        Text("✏️ Reflections:")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.fredoka(.semiBold, size: 16))
                                            .offset(y: 5)
                                        ScrollView(showsIndicators: false) {
                                            ForEach(self.journals ?? [], id: \.self) { journal in
                                                Text(journal["gratitude"] ?? "No reflections written this day")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .foregroundColor(self.journals?.isEmpty ?? false ? Color.gray : Clr.black2)
                                                    .font(Font.fredoka(.regular, size: 14))
                                                    .padding(10)
                                                if let img = journal["image"], !img.isEmpty {
                                                    UrlImageView(urlString: String(img))
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width:g.size.width * 0.3)
                                                        .cornerRadius(14)
                                                        .addBorder(.black,width:1.5, cornerRadius: 14)
                                                        .neoShadow()
                                                }
                                                Divider()
                                            }
                                        }
                                    }.padding(5)
                                }.frame(width: g.size.width * 0.5)
                            }.frame(maxHeight: g.size.height * 0.40)
                                .padding(.horizontal, g.size.width * 0.1)
                            Spacer()
                        }
                    }.navigationBarItems(leading: xButton,
                                         trailing: title)
                    if showOnboardingModal {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        Spacer()
                        
                    }
                    //                OnboardingModal(shown: $showOnboardingModal)
                    //                    .offset(y: showOnboardingModal ? 0 : g.size.height)
                    //                    .animation(.default, value: showOnboardingModal)
                    
                }
            }
        }
        .onAppear {
         
            showLoading = true
            Analytics.shared.log(event: .screen_load_single)
            if !UserDefaults.standard.bool(forKey: "singleTile") {
                UserDefaults.standard.setValue(true, forKey: "singleTile")
                Analytics.shared.log(event: .screen_load_single_onboarding)
                showOnboardingModal = true
                showRating()
                if let onboardingNotif = UserDefaults.standard.value(forKey: "onboardingNotif") as? String {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [onboardingNotif])
                }
            }
            
            if let moods = gardenModel.grid[String(self.year)]?[String(self.month)]?[String(self.day)]?[K.defaults.moods] as? [[String: String]] {
                self.moods = moods
            }
            
            
            if let journals = gardenModel.grid[String(self.year)]?[String(self.month)]?[String(self.day)]?["gratitudes"] as? [String] {
                for journal in journals {
                    var journalObj = [String: String]()
                    journalObj["question"] = "None"
                    journalObj["gratitude"] = journal
                    journalObj["timeStamp"] = "12:00 AM"
                    self.journals?.append(journalObj)
                }
            } else if let grats = gardenModel.grid[String(self.year)]?[String(self.month)]?[String(self.day)]?["journals"] as? [[String: String]] {
                self.journals = grats
            }
            
            if let sessions = gardenModel.grid[String(self.year)]?[String(self.month)]?[String(self.day)]?[K.defaults.sessions] as? [[String: String]] {
                self.sessions = sessions
                self.totalSessions = sessions.count
                for session in sessions {
                    if let duration = session["duration"] {
                        self.totalTime += (Double(duration) ?? 0.0).toInt() ?? 0
                    }
                }
                if let selectedPlant = sessions[sessionCounter][K.defaults.plantSelected] {
                    for plant in Plant.allPlants {
                        if plant.title == selectedPlant {
                            self.plant = plant
                            showLoading = false
                        }
                    }
                }
                if let duration = sessions[sessionCounter][K.defaults.duration] {
                    self.minutesMeditated = (Double(duration) ?? 0.0).toInt() ?? 0
                }
            } else {
                showLoading = false
            }
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "garden" {
                if totalTime == 0 {
                    totalTime = 30
                }
                if totalSessions == 0 {
                    totalSessions = 1
                }
                if self.moods == nil {
                    if let mod = mood {
                        moods = [["mood": mod.title]]
                    }
                }
            }
        }.onDisappear {
            UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
        }
    }

    var xButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            showSingleModal = false
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 22))
                .foregroundColor(Clr.black1)
        }
    }

    var title: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(Date().getMonthName(month: String(month))) \(day), \(String(year))")
                    .font(Font.fredoka(.semiBold, size: 26))
                Text("\(plant?.title ?? "" )")
                    .font(Font.fredoka(.bold, size: 38))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text("Mindful Minutes: \(minutesMeditated/60 == 0 && minutesMeditated != 0 ? "0.5" : "\(minutesMeditated/60)")")
                    .font(Font.fredoka(.semiBold, size: 18))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .foregroundColor(.white)
            .frame(height: 80)
            .padding(.top, 60)
        }
    }
    
    private func showRating() {
        if (gardenModel.numMeds + gardenModel.numBreaths) == 1 {
            Analytics.shared.log(event: .show_onboarding_rating)
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                showOnboardingModal = false
            }
        }
    }
    
    private func updateSession() {
        plant = Plant.allPlants.first(where: { plant in
            return plant.title == sessions?[sessionCounter][K.defaults.plantSelected]
        })
        if let duration = sessions?[sessionCounter][K.defaults.duration] {
            self.minutesMeditated = (Double(duration) ?? 0.0).toInt() ?? 0
        }
    }
}

struct SingleDay_Previews: PreviewProvider {
    static var previews: some View {
        SingleDay(showSingleModal: .constant(true), day: .constant(1), month: 8, year: 2021, plant: .constant(Plant.allPlants.first!), mood: .constant(Mood.getMood(str: "good")),  grid: .constant([String : [String : [String : [String : Any]]]]()))
                .navigationViewStyle(StackNavigationViewStyle())
    }
}

