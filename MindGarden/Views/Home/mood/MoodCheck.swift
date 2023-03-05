//
//  MoodCheck.swift
//  MindGarden
//
//  Created by Dante Kim on 6/29/21.
//

import SwiftUI
import Amplitude

struct MoodCheck: View {
    @Binding var shown: Bool
    @Binding var showPopUp: Bool
    @State var moodSelected: Mood = .none
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var viewRouter: ViewRouter

    ///Ashvin : Binding variable for pass animation flag
    @Binding var PopUpIn: Bool
    @Binding var showPopUpOption: Bool
    @Binding var showItems: Bool
    @State private var notifOn: Bool = false

    var body: some View {
        GeometryReader { g in
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 10) {
                        HStack {
                            Text("\(Date().toString(withFormat: "EEEE, MMM dd"))")
                                .font(Font.fredoka(.medium, size: 20))
                                .foregroundColor(Clr.darkGray)
                                .padding(.top, 35)
                            Spacer()
                            if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "signedUp" {
            
                            Image(systemName: "xmark")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Clr.black1)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height:12)
                                .background(
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .frame(width:30,height:30)
                                        .cornerRadius(17)
                                        .neoShadow()
                                ).onTapGesture {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    moodFromFinished = false
                                    withAnimation { shown.toggle() }
                                }.offset(x: -5, y: 10)
                                .disabled(UserDefaults.standard.bool(forKey: "signedUp"))
                                
                            }
                        }.frame(width: g.size.width * 0.85, alignment: .leading)
     
                        Text("How are you feeling right now?")
                            .font(Font.fredoka(.semiBold, size: K.isPad() ? 40 : 28))
                            .foregroundColor(Clr.black2)
                            .frame(width: g.size.width * 0.85, alignment: .leading)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.bottom, 15)                    
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(LinearGradient(colors: [Clr.veryBad, Clr.bad, Clr.okay, Clr.good, Clr.veryGood], startPoint: .leading, endPoint: .trailing))
                            .addBorder(Color.black, width: 1.5, cornerRadius: 32)
                            .neoShadow()
                        HStack {
                            SingleMood(moodSelected: $moodSelected, mood: .veryBad, save: save)
                            SingleMood(moodSelected: $moodSelected, mood: .bad, save: save)
                            SingleMood(moodSelected: $moodSelected, mood: .okay, save: save)
                            SingleMood(moodSelected: $moodSelected, mood: .good, save: save)
                            SingleMood(moodSelected: $moodSelected, mood: .veryGood, save: save)
                        }.padding(.horizontal, 10)
                    }.frame(width: g.size.width * 0.9, height: g.size.height/(3.25), alignment: .center)
                        Spacer()
                        if K.isPad() {
                            Spacer()
                        }
                    }
                    Spacer()
                    Spacer()
                }
        }.onAppear {
            notifOn = UserDefaults.standard.bool(forKey: "moodRecsToggle")
        }
    }

    ///Ashvin : Show popup with animation method
    func save() {
        withAnimation(.easeOut(duration: 0.25)) {
            shown = false
            userModel.selectedMood = moodSelected
            viewRouter.currentPage = .mood
        }
        Analytics.shared.log(event: .plus_selected_mood)
            }

        private func showPopupWithAnimation(completion: @escaping () -> ()) {
            withAnimation(.easeIn(duration:0.14)){
                showPopUp = true
            }
            withAnimation(.easeIn(duration: 0.08).delay(0.14)) {
                PopUpIn = true
            }
            withAnimation(.easeIn(duration: 0.14).delay(0.22)) {
                showPopUpOption = true
            }
            withAnimation(.easeIn(duration: 0.4).delay(0.36)) {
                showItems = true
                completion()
            }
        }
}

struct MoodCheck_Previews: PreviewProvider {
    static var previews: some View {
        MoodCheck(shown: .constant(true), showPopUp: .constant(false), PopUpIn: .constant(false), showPopUpOption: .constant(false), showItems: .constant(false))
            .frame(width: UIScreen.main.bounds.width, height: 250)
            .background(Clr.darkWhite)
            .cornerRadius(12)
    }
}

struct SingleMood: View {
    @Binding var moodSelected: Mood
    var mood: Mood
    var save: () -> ()

    var body: some View {
        ZStack {
            VStack(spacing: 2) {
                Button {
                    Analytics.shared.log(event: .mood_tapped_done)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    switch mood {
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
                    if moodSelected == mood {
                        moodSelected = .none
                    } else {
                        moodSelected = mood
                    }
                    save()
                    moodSelected = .none
                } label: {
                    Mood.getMoodImage(mood: mood)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(5)
                        .opacity(moodSelected == mood ? 0.3 : 1)
                }
//                Text(mood.title)
//                    .font(Font.fredoka(.semiBold, size: 14))
//                    .foregroundColor(.gray)
//                    .minimumScaleFactor(0.05)
//                    .lineLimit(1)
            }
            if moodSelected == mood {
                Image(systemName: "checkmark")
                    .font(Font.title.weight(.bold))
            }
        }
    }
}

struct DoneCancel: View {
    @Binding var showPrompt: Bool
    @Binding var shown: Bool
    var width, height: CGFloat
    var mood: Bool
    var save: () -> ()
    var moodSelected: Mood?
    @Binding var showRecs: Bool

    var body: some View {
        HStack {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if moodSelected != Mood.none {
                    save()
                    withAnimation {
//                        selectedMood = moodSelected ?? Mood.none
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        showPrompt = false
                        shown = false
                    }
                }
            } label: {
                Text("Done")
                    .foregroundColor(.white)
                    .font(Font.fredoka(.semiBold, size: 20))
            }
            .frame(width:  width * 0.3, height: min(height/6, 40))
            .background(Clr.brightGreen)
            .cornerRadius(12)
            .neoShadow()
            .padding()
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "garden" {
                    withAnimation {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        showPrompt = false
                        shown = false
                    }
                }
            } label: {
                Text("Cancel")
                    .foregroundColor(.white)
                    .font(Font.fredoka(.semiBold, size: 20))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .frame(width: width * 0.3, height: min(height/6, 40))
            .background(Color.gray)
            .cornerRadius(12)
            .neoShadow()
            .padding()
        }
    }
}

