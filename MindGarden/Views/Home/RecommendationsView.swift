//
//  RecommendationsView.swift
//  MindGarden
//
//  Created by Vishal Davara on 06/07/22.
//

import SwiftUI

struct RecommendationsView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @State private var playAnim = false
    let width = UIScreen.screenWidth
    @State private var playEntryAnimation = false
    @Binding var recs: [Int]
    @Binding var coin: Int
    @State private var isOnboarding = false
    @State private var moodCoins = 1
    @State private var rowOpacity = 1.0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Clr.darkWhite.ignoresSafeArea()
            ScrollView(.vertical,showsIndicators: false) {
                VStack {
                    Spacer()
                        .frame(height:20)
                    VStack(spacing:0) {
                        HStack {
                            Text("Hooray!")
                                .foregroundColor(Clr.brightGreen)
                                .font(Font.fredoka(.semiBold, size: 28))
                            Spacer()
                            if !isOnboarding {
                                CloseButton() {
                                    withAnimation {
                                        Analytics.shared.log(event: .recommendations_tapped_x)
                                        if !isOnboarding {
                                            viewRouter.currentPage = .meditate
                                        }
                                    }
                                }
                            }
           
                        }.padding(5)
                            .padding(.bottom,10)
                            .zIndex(2)
                        ZStack {
                            Rectangle()
                                .fill(LinearGradient(colors: [Clr.brightGreen.opacity(0.8), Clr.yellow], startPoint: .leading, endPoint: .trailing))
                                .font(Font.fredoka(.medium, size: 20))
                                .overlay(LottieAnimationView(filename: "party", loopMode: .playOnce, isPlaying: $playAnim)
                                .scaleEffect(2))
                            VStack(alignment:.leading, spacing: 0) {
                                HStack {
                                    ( Text("You earned")  .foregroundColor(.white) + Text("  +\(moodCoins + coin)  ").foregroundColor(Clr.brightGreen) + Text("coins")  .foregroundColor(.white))
                                        .font(Font.fredoka(.semiBold, size: 20))
                                        .padding()
                                        .offset(x: 24)
                                    Spacer()
                                }
                                HStack(spacing:20) {
                                    Img.coinBunch
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(.leading,16)
                                        .frame(width: 100)
                                        .offset(x: 24, y: -8)
                                    Spacer()
                                    VStack(alignment: .leading, spacing:10) {
                                        HStack {
                                            Mood.getMoodImage(mood: userModel.selectedMood)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30)
                                            Text("+\(moodCoins)")
                                                .foregroundColor(Clr.brightGreen)
                                                .font(Font.fredoka(.semiBold, size: 20)) +
                                            Text(" Mood Check")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.fredoka(.regular, size: 20))
                                        }
                                        HStack {
                                            Img.streakPencil
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30)
                                            Text("+\(coin)")
                                                .foregroundColor(Clr.brightGreen)
                                                .font(Font.fredoka(.semiBold, size: 20)) +
                                            Text(" Journaling")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.fredoka(.regular, size: 20))
                                        }
                                        Spacer()
                                    }
                                    .frame(width: width * 0.5)
                                    .padding(.trailing,30)
                                    .padding(.top)
                                }
                                Spacer()
                            }
                        }
                        .frame(width: width * 0.875, height:175)
                        .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                    }
                    
                    TodaysMeditation
                        .padding(.top,30)
                    Spacer()
                }
                .padding(.horizontal,32)
            }
        }.onAppear() {
            if let moods = gardenModel.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?["moods"]  as? [[String: String]] {
                if moods.count == 1 {
                    moodCoins = 20
                } else {
                    moodCoins = max(20/((moods.count - 1) * 3), 1)
                }
            } else {
                moodCoins = 20
            }
            withAnimation(.spring()) {
                playAnim = true
                playEntryAnimation = true
            }

            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" && !UserDefaults.standard.bool(forKey: "review") {
                if UserDefaults.standard.integer(forKey: "numMeds") == 0 {
                    Analytics.shared.log(event: .onboarding_load_recs)
                    isOnboarding = true
                    var count = 0
                    let _  = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        count += 1
                        if count == 1 {
                            timer.invalidate()
                            withAnimation {
                                rowOpacity = 0.2
                            }
                        }
                    }
                }
            } else {
                Analytics.shared.log(event: .screen_load_recs)
            }
        }
    }
    
    var TodaysMeditation: some View {
        VStack(alignment:.leading) {
            HStack {
                Text("Today’s Meditations")
                    .foregroundColor(Clr.brightGreen)
                    .font(Font.fredoka(.semiBold, size: 20))
                    .padding(.leading, 10)
                Spacer()
            }.frame(width: UIScreen.screenWidth * 0.875)
            HStack(spacing:16) {
                Mood.getMoodImage(mood: userModel.selectedMood)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:50)
                Text("Based on how you're feeling, we chose these for you:")
                    .foregroundColor(Clr.black2)
                    .font(Font.fredoka(.regular, size: 20))
                    .multilineTextAlignment(.leading)
            }.frame(width: UIScreen.screenWidth * 0.875, height:50)
            .padding(.bottom,20)
            ForEach(0..<3) { idx in
                if isOnboarding && idx == 0  { // onboarding
                    MeditationRow(id: 22, isBreathwork: false)
                        .padding(.vertical,5)
                        .offset(y: playEntryAnimation ? 0 : 100)
                        .opacity(rowOpacity)
                        .animation(Animation.easeInOut(duration:0.5).repeatForever(autoreverses:true), value: rowOpacity)
                } else {
                    MeditationRow(id: recs[idx], isBreathwork: idx == 0)
                        .padding(.vertical,5)
                        .offset(y: playEntryAnimation ? 0 : 100)
                        .opacity(playEntryAnimation ? 1 : 0)
                        .animation(.spring().delay(Double((idx+1))*0.3), value: playEntryAnimation)
                        .disabled(isOnboarding)
                        .opacity(isOnboarding ? 0.15 : 1)
                }
            }
            if !isOnboarding {
            HStack {
                Spacer()
                Text("OR")
                    .foregroundColor(Clr.black2)
                    .font(Font.fredoka(.medium, size: 16))
                Spacer()
            }
            
                Button {
                    Analytics.shared.log(event: .recs_tapped_see_more)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation {
                        viewRouter.currentPage = .learn
                    }
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Clr.yellow)
                            .frame(height: 44)
                            .addBorder(Color.black, width: 1.5, cornerRadius: 22)
                        HStack {
                            Text("See More")
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.bold, size: 16))
                            Image(systemName: "arrow.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:16)
                        }
                    }
                }.buttonStyle(NeoPress())
                    .frame(width: UIScreen.screenWidth * 0.875, alignment: .center)
                    .offset(x: 5)
                .disabled(isOnboarding)
            }
  
        }
    }
}

struct MeditationRow: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var medModel: MeditationViewModel
    var id:Int
    var isBreathwork: Bool
    @State var meditation: Meditation = Meditation.allMeditations[0]
    @State var breathwork: Breathwork = Breathwork.breathworks[0]
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation {
                viewRouter.previousPage = .meditate
                presentationMode.wrappedValue.dismiss()
                if isBreathwork {
                    medModel.selectedBreath = breathwork
                    viewRouter.currentPage = .breathMiddle
                    Analytics.shared.log(event: .recommendations_tapped_breath)
                } else {
                    if id != 22 {
                        Analytics.shared.log(event: .recommendations_tapped_med)
                    }
                    medModel.selectedMeditation = meditation
                    if meditation.type == .course {
                        viewRouter.currentPage = .middle
                    } else {
                        if id == 22 {
                            Analytics.shared.log(event: .onboarding_tapped_30_second)
                        }
                        viewRouter.currentPage = .play
                    }
                }
            }
        } label: {
            ZStack {
                Rectangle()
                    .fill(Clr.darkWhite)
                    .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                    .frame(width: UIScreen.screenWidth * 0.875)
                HStack(spacing:0) {
                    VStack(alignment:.leading,spacing:3) {
                        Text(isBreathwork ? breathwork.title : meditation.title)
                            .font(Font.fredoka(.semiBold, size: 20))
                            .frame(width: UIScreen.screenWidth * ( meditation.title == "30 Second Meditation" ? 0.525 : 0.5), height: !isBreathwork
                                   && meditation.title.count > 20 ? 55 : 25, alignment: .leading)
                            .foregroundColor(Clr.black2)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 5)
                            .offset(y:!isBreathwork && meditation.title.count > 19 ? 5 : 0)
                            .lineLimit(2)
                        HStack(spacing: 7) {
                            Image(systemName: isBreathwork ? "wind" : "speaker.wave.3.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:12)
                                .padding(.vertical,0)
                            Text(isBreathwork ? "Breathwork" : " Meditation")
                                .font(Font.fredoka(.medium, size: 16))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                            .frame(width: UIScreen.screenWidth/2.25, alignment: .leading)
                            .offset(x: 5)

                        HStack(spacing: 5){
                                Image(systemName: isBreathwork ? breathwork.color.image : "timer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height:13)
                                    .padding(.vertical,0)
                                Text(isBreathwork ? breathwork.color.name.capitalized : Int(meditation.duration) == 0 ? "Course" : (Int(meditation.duration/60) == 0 ? "1/2" : "\(Int(meditation.duration/60))") + " mins")
                                    .font(Font.fredoka(.medium, size: 16))
                                    .foregroundColor(Clr.black2.opacity(0.5))
                                    .padding(.vertical,0)
                                Text(" • ")
                                    .font(Font.fredoka(.bold, size: 16))
                                    .foregroundColor(Clr.black2.opacity(0.5))
                                    .padding(.vertical,0)
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height:12)
                                    .padding(.vertical,0)
                                Text(isBreathwork ? "Visual" : "\(meditation.instructor)")
                                    .font(Font.fredoka(.medium, size: 16))
                                    .foregroundColor(Clr.black2.opacity(0.5))
                                    .padding(.vertical,0)
                            }.padding(.vertical,0)
                            .frame(width: UIScreen.screenWidth/2.1, alignment: .leading)
                            .offset(x: 5)
                    }
                    Spacer()
                    Group {
                        if isBreathwork {
                            breathwork.img
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            if meditation.imgURL != "" {
                                UrlImageView(urlString: meditation.imgURL)
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                meditation.img
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
        
                        }
                    }.frame(width: 80, height: 80)
                        .offset(y: 2)
                }
                .frame(height: 95, alignment: .center)
                .offset(y: -7)
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
            }
        }.buttonStyle(BonusPress())
      .onAppear {
            if isBreathwork {
                if let breath = Breathwork.breathworks.first(where: { $0.id == id }) {
                    breathwork = breath
                }
                
                
            } else {
                if let med = Meditation.allMeditations.first(where: { $0.id == id }) {
                    meditation = med
                }
            }
        }
    }
}



struct RecommendationsView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationsView(recs: .constant([-1,1,2]), coin: .constant(3))
    }
}
