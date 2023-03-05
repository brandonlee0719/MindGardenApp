//
//  StartDayView.swift
//  MindGarden
//
//  Created by Vishal Davara on 04/07/22.
//

import SwiftUI
import Lottie
import Amplitude


struct StartDayView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    
    @State private var tileOpacity = 1.0
    @State private var playEntryAnimation = false
    
    var body: some View {
        let width = UIScreen.screenWidth
        let height = UIScreen.screenHeight
        let hour = Calendar.current.component( .hour, from:Date() )
        VStack {
            HStack {
                Text(hour > 16 ? "Relfect on your day" : gardenModel.isMeditationDone ? "Well Done! Let's Reflect Later" : "Start your day" )
                    .foregroundColor(Clr.brightGreen)
                    .font(Font.fredoka(.bold, size: 20))
                    .minimumScaleFactor(0.05)
                    .lineLimit(1)
                    .padding(.bottom, 32)
                Spacer()
            }
            
            HStack(spacing: 0) {
                VStack(spacing:0) {
                    Spacer()
                    if !userModel.completedEntireCourse {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(userModel.completedIntroDay ? Clr.brightGreen : Clr.darkWhite)
                            .frame(width:24,height: 24)
                            .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 12)
                            .zIndex(1)
                        Group {
                            if userModel.completedIntroDay {
                                Rectangle()
                                    .fill(Clr.brightGreen)
                                    .frame(width: 4)
                            } else {
                                DottedLine()
                                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [12]))
                                    .fill(Clr.black2)
                                    .opacity(0.5)
                                    .offset(x:1)
                                    .frame(width: 2)
                            }
                        }
                        .frame(maxHeight:.infinity)
                        .padding(.top, userModel.completedIntroDay ? 0 : 12)
                        .padding(.bottom, userModel.completedIntroDay ? 0 : 4)
                    }
              
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(!gardenModel.isMoodDone ? Clr.darkWhite : Clr.brightGreen)
                        .frame(width:24,height: 24)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 12)
                        .zIndex(1)
                    Group {
                        if !gardenModel.isMoodDone  {
                            DottedLine()
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [12]))
                                .fill(Clr.black2)
                                .opacity(0.5)
                                .offset(x:1)
                                .frame(width: 2)
                        } else {
                            Rectangle()
                                .fill(Clr.brightGreen)
                                .frame(width: 4)
                        }
                    }
                    .frame(maxHeight:.infinity)
                    .padding(.top, !gardenModel.isMoodDone  ? 12 : 0)
                    .padding(.bottom,!gardenModel.isMoodDone  ? 4 : 0)
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(gardenModel.isGratitudeDone ? Clr.brightGreen : Clr.darkWhite)
                        .frame(width:24,height: 24)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 12)
                        .zIndex(1)
                    Group {
                        if gardenModel.isGratitudeDone {
                            Rectangle()
                                .fill(Clr.brightGreen)
                                .frame(width: 4)
                        } else {
                            DottedLine()
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [12]))
                                .fill(Clr.black2)
                                .opacity(0.5)
                                .offset(x:1)
                                .frame(width: 2)
                        }
                    }
                    .frame(maxHeight:.infinity)
                    .padding(.top,gardenModel.isGratitudeDone ? 0 : 12)
                    .padding(.bottom,gardenModel.isGratitudeDone ? 0 : 4)
                           
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(gardenModel.isMeditationDone ? Clr.brightGreen : Clr.darkWhite)
                        .frame(width:24,height: 24)
                        .addBorder(Color.black.opacity(0.2), width: 1.5, cornerRadius: 12)
                    Spacer()
                    Spacer()
                        .frame(height:30)
                }.padding(.vertical,60)
                    .neoShadow()
                VStack(spacing:30) {
                    if !userModel.completedEntireCourse {
                        Button {
                      
                        } label: {
                            ZStack {
                                Img.shortVideoBG
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 190)
                                    .opacity(0.9)
                                if !userModel.completedIntroDay {
                                    HStack {
                                        Spacer()
                                        ZStack {
                                            Rectangle().fill(Clr.yellow)
                                            Text("📸 Watch")
                                                .foregroundColor(Clr.black2)
                                                .font(Font.fredoka(.semiBold, size: 16))
                                        }.frame(width:100, height: 40)
                                            .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                                    }
                                    .frame(height: 85)
                                    .position(x: 130, y: 140)
                                }
                                VStack(spacing:0) {
                                    HStack(spacing:0) {
                                        VStack(alignment:.leading) {
                                            if userModel.completedIntroDay {
                                                Text(userModel.completedDayTitle == "10" ? "✅ Final Day" : ("✅ Intro/Day " + userModel.completedDayTitle))
                                                    .foregroundColor(Color.black)
                                                    .font(Font.fredoka(.bold, size: 24))
                                                    .padding([.top],16)
                                            } else {
                                                Text(userModel.completedDayTitle == "10" ? "Final Day" : ("Intro/Day " + userModel.completedDayTitle))
                                                    .foregroundColor(Color.black)
                                                    .font(Font.fredoka(.bold, size: 24))
                                                    .padding([.top],16)
                                            }
                                            
                                            Text("Understanding \nMeditation")
                                                .foregroundColor(Color.black)
                                                .font(Font.fredoka(.medium, size: 16))
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.05)
                                        }.padding([.leading, .top], 24)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal,35)
                            }.frame(width: UIScreen.screenWidth * 0.75, height: 170)
                                .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                                .padding(.horizontal, 12)
                                .offset(y: playEntryAnimation ? 0 : 100)
                                .opacity(playEntryAnimation ? 1 : 0)
                                .animation(.spring().delay(0.275), value: playEntryAnimation)
                                .opacity(userModel.completedIntroDay ? 0.5 : 1)
                                .onTapGesture {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        if !userModel.completedIntroDay {
                                            let _ = storylyViewProgrammatic.openStory(storyGroupId: 58519 + (Int(userModel.completedDayTitle) ?? 0), play: .StoryGroup)
                                            print(userModel.completedDayTitle, "reviver")
                                            storylyViewProgrammatic.resume()
                                            Analytics.shared.log(event: .home_tapped_introDay)
                                            Amplitude.instance().logEvent("intro/day", withEventProperties: ["day" : userModel.completedDayTitle])
                                        }
                                    }
                                }
                        }.buttonStyle(ScalePress() )
                            .opacity(userModel.completedIntroDay ? 1 : tileOpacity)
                            .animation(Animation.easeInOut(duration: 0.75).repeatForever(autoreverses:true), value: tileOpacity)
                    }
                    Button {
                        
                    } label: {
                        ZStack {
                            Img.whiteClouds
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height:170)
                                .opacity(0.95)
                            VStack(alignment:.leading,spacing:0) {
                                VStack(alignment:.leading) {
                                    Text("Mood Check")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.fredoka(.bold, size: 24))
                                        .padding([.top],16)
                                    Text("How are you feeling?")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.fredoka(.medium, size: 16))
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.05)
                                }.padding(.leading,16)
                                if !gardenModel.isMoodDone {
                                    SelectMood.frame(height: 85)
                                } else {
                                    DailyMood
                                }
                            }.padding(.horizontal, 35)
                        }
                        .frame(width: UIScreen.screenWidth * 0.75)
                        .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                        .padding(.horizontal, 12)
                        .opacity(!gardenModel.isMoodDone ? 1 : 0.5)
                        .offset(y: playEntryAnimation ? 0 : 100)
                        .opacity(playEntryAnimation ? 1 : 0)
                        .animation(.spring().delay(0.3), value: playEntryAnimation)
                        .onTapGesture {
                            Analytics.shared.log(event: .home_tapped_mood)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                NotificationCenter.default.post(name: Notification.Name("mood"), object: nil)
                            }
                        }
                    }.buttonStyle(ScalePress())
                    Button {
                        
                    } label: {
                        ZStack {
                            Img.journelBG
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 170)
                            VStack(spacing:0) {
                                HStack(spacing:0) {
                                    VStack(alignment:.leading) {
                                        Text("Journal")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.fredoka(.bold, size: 24))
                                            .padding([.top],16)
                                        Text(gardenModel.isWeekStreakDone ? "Wow! Perfect this week!" : gardenModel.isGratitudeDone ? "Great work!" : "Answer today’s Prompt")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.fredoka(.medium, size: 16))
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.05)
                                    }.padding(.leading,16)
                                    Spacer()
                                }
                                if gardenModel.isGratitudeDone {
                                    VStack {
                                        HStack(alignment:.top, spacing: -3) {
                                            ForEach(gardenModel.streakList, id: \.id) { item in
                                                VStack(spacing:5) {
                                                    Text(item.title)
                                                        .foregroundColor(Clr.black2)
                                                        .font(Font.fredoka(.semiBold, size: 12))
                                                    VStack(spacing:0) {
                                                        if item.streak {
                                                            Img.streakPencil
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(height: 30)
                                                        } else {
                                                            Img.streakPencilUnselected
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(height: 30)
                                                        }
                                                    }
                                                }
                                                .padding(.horizontal,3)
                                                .frame(maxWidth:.infinity)
                                            }
                                        }
                                    }.frame(height: 85)
                                } else {
                                    HStack {
                                        Spacer()
                                        ZStack {
                                            Rectangle().fill(Clr.yellow)
                                            HStack {
                                                Img.streakPencil
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(height: 20)
                                                Text("Write")
                                                    .foregroundColor(Clr.black2)
                                                    .font(Font.fredoka(.semiBold, size: 16))
                                            }
                                        }.frame(width:100, height: 40)
                                            .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                                    }
                                    .frame(height: 85)
                                    .padding(.trailing, 12)
                                }
                            }
                            .padding(.horizontal,35)
                        }.frame(width: UIScreen.screenWidth * 0.75, height: 170)
                            .addBorder(Color.black, width: 1.5, cornerRadius: 16)
                            .padding(.horizontal, 12)
                            .offset(y: playEntryAnimation ? 0 : 100)
                            .opacity(playEntryAnimation ? 1 : 0)
                            .animation(.spring().delay(0.275), value: playEntryAnimation)
                            .onTapGesture {
                                Analytics.shared.log(event: .home_tapped_journal)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    userModel.elaboration = ""
                                    viewRouter.currentPage = .journal
                                }
                            }
                            .opacity(gardenModel.isGratitudeDone ? 0.5 : 1)
                    }.buttonStyle(ScalePress() )
                   
                    ZStack {
                        VStack(spacing:5) {
                            HStack(spacing: 15) {
                                Button {
                                    Analytics.shared.log(event: .home_tapped_featured_breath)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        medModel.selectedBreath = medModel.featuredBreathwork
                                        viewRouter.currentPage = .breathMiddle
                                    }
                                } label: {
                                    HomeSquare(width: width - 50, height: height * 0.7, meditation: Meditation.allMeditations.first(where: { $0.id == 67 }) ?? Meditation.allMeditations[0], breathwork: medModel.featuredBreathwork)
                                        .offset(y: playEntryAnimation ? 0 : 100)
                                        .opacity(playEntryAnimation ? 1 : 0)
                                        .animation(.spring().delay(0.3), value: playEntryAnimation)
                                }.buttonStyle(ScalePress())
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .home_tapped_featured_meditation)
                                    withAnimation {
                                        if !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains( medModel.featuredMeditation?.id ?? 0) {
                                            viewRouter.currentPage = .pricing
                                        } else {
                                            medModel.selectedMeditation = medModel.featuredMeditation
                                            if medModel.featuredMeditation?.type == .course {
                                                viewRouter.currentPage = .middle
                                            } else {
                                                viewRouter.currentPage = .play
                                            }
                                        }
                                    }
                                } label: {
                                    HomeSquare(width: width - 50, height: height * 0.7, meditation: medModel.featuredMeditation ?? Meditation.allMeditations[0], breathwork: nil)
                                        .offset(y: playEntryAnimation ? 0 : 100)
                                        .opacity(playEntryAnimation ? 1 : 0)
                                        .animation(.spring().delay(0.3), value: playEntryAnimation)
                                }.buttonStyle(ScalePress())
                            }.opacity(gardenModel.isMeditationDone ? 0.5 : 1)
                            HStack {
                                Spacer()
                                Text("Breathwork")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.regular, size: 16))
                                Spacer()
                                Text("OR")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.medium, size: 16))
                                Spacer()
                                Text("Meditation")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.regular, size: 16))
                                Spacer()
                            }
                            .frame(height:30)
                            .offset(x: -5)
                            .padding(.top, 10)
                        }
                    }
                    .frame(width: UIScreen.screenWidth * 0.75)
                    .offset(y: playEntryAnimation ? 0 : 100)
                    .opacity(playEntryAnimation ? 1 : 0)
                    .animation(.spring().delay(0.3), value: playEntryAnimation)
                }.padding(.leading, 12)
            }
        }
        .onReceive(gardenModel.$grid){ grid in
            if let gratitudes = gardenModel.grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?[K.defaults.journals]  as? [[String: String]] {
                if let gratitude = gratitudes[gratitudes.count-1]["gratitude"], !gratitude.isEmpty  {
                    gardenModel.isGratitudeDone = true
                }
            }
        }
        .padding(.horizontal, 26)
        .onAppear() {
            if !userModel.completedIntroDay && UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "garden" && userModel.completedDayTitle == "1"  {
                tileOpacity = 0.35
            }
            gardenModel.updateStartDay()
            gardenModel.getAllGratitude(weekDays: gardenModel.getAllDaysOfTheCurrentWeek())
            updateStartDay()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("updateStart"))) { _ in
            updateStartDay()
        }
    }
    
    private func updateStartDay() {
        withAnimation {
            playEntryAnimation = true
        }
        
        if let newSegments = UserDefaults.standard.array(forKey: "storySegments") as? [String] {
//            UserDefaults.standard.setValue(newSegments, forKey: "oldSegments")
            
        }
    }
    
    var SelectMood: some View {
        VStack {
            //                Text("How are you feeling?")
            //                    .foregroundColor(Clr.brightGreen)
            //                    .font(Font.fredoka(.semiBold, size: 16))
            //                    .offset(y: 8)
            HStack(alignment:.top) {
                ForEach(Mood.allMoodCases(), id: \.id) { item in
                    Button {
                        Analytics.shared.log(event: .home_selected_mood)
                        switch item {
                        case .angry: Analytics.shared.log(event: .mood_tapped_angry)
                        case .sad: Analytics.shared.log(event: .mood_tapped_sad)
                        case .stressed: Analytics.shared.log(event: .mood_tapped_stress)
                        case .okay: Analytics.shared.log(event: .mood_tapped_okay)
                        case .happy: Analytics.shared.log(event: .mood_tapped_happy)
                        case .bad: Analytics.shared.log(event: .mood_tapped_bad)
                        case .veryBad: Analytics.shared.log(event: .mood_tapped_veryBad)
                        case .good: Analytics.shared.log(event: .mood_tapped_good)
                        case .veryGood: Analytics.shared.log(event: .mood_tapped_veryGood)
                        case .none: Analytics.shared.log(event: .mood_tapped_x)
                        }
                        withAnimation {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            userModel.selectedMood = item
                            viewRouter.currentPage = .mood
                        }
                    } label: {
                        VStack(spacing:0) {
                            Mood.getMoodImage(mood: item)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 85)
                        }
                    }
                }
            }.padding(10)
        }
    }
    
    var DailyMood: some View {
        VStack {
            HStack(alignment:.top) {
                ForEach(gardenModel.dailyMoodList, id: \.id) { item in
                    VStack(spacing:5) {
                        Text(item.title)
                            .foregroundColor(Clr.black2)
                            .font(Font.fredoka(.semiBold, size: 12))
                            .padding(.bottom, 4)
                        VStack(spacing:0) {
                            item.dailyMood
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .padding(.horizontal,2)
                    .frame(maxWidth:.infinity)
                }
            }.padding(10)
                .padding(.vertical, 10)
        }
    }
}


struct HomeMeditationRow: View {
    
    @State var title:String
    
    var body: some View {
        ZStack(alignment:.top) {
            Rectangle()
                .fill(Clr.darkWhite)
                .padding(.vertical,10)
                .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                .background(Clr.darkWhite.cornerRadius(14).neoShadow())
            
            VStack(spacing:0) {
                HStack {
                    Text(title)
                        .font(Font.fredoka(.medium, size: 16))
                        .foregroundColor(Clr.black2)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                HStack(spacing:0) {
                    VStack(alignment:.leading,spacing:3) {
                        HStack {
                            Image(systemName: "speaker.wave.3.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:8)
                                .padding(.vertical,0)
                            Text("Meditation")
                                .font(
                                    .fredoka(.medium, size: 10))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                        HStack {
                            Image(systemName: "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:8)
                                .padding(.vertical,0)
                            Text("10 mins")
                                .font(Font.fredoka(.medium, size: 10))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height:8)
                                .padding(.vertical,0)
                            Text("Bijan")
                                .font(Font.fredoka(.medium, size: 10))
                                .foregroundColor(Clr.black2.opacity(0.5))
                                .padding(.vertical,0)
                        }.padding(.vertical,0)
                    }
                    Img.happySunflower
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                }
                
            }
            .padding(10)
        }
    }
}
