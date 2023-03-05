//
//  OnboardingModal.swift
//  MindGarden
//
//  Created by Dante Kim on 9/17/21.
//

import SwiftUI

struct OnboardingModal: View {
    @Binding var shown: Bool
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    var isUnlocked: Bool = false

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        VStack(spacing: 10) {
                            if isUnlocked {
                                Text("🍓 Congrats, you just unlocked the strawberry plant!")
                                    .font(Font.fredoka(.semiBold, size: 26))
                                    .foregroundColor(Color.black)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.05)
                            } else {
                                Text("1️⃣ This is Your Overview for a Single Day")
                                    .font(Font.fredoka(.semiBold, size: 24))
                                    .foregroundColor(Clr.black2)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.05)
                                (Text("🎉 That's it for the tutorial! Complete the intro to meditation course to unlock a free strawberry plant for a ")                                    .font(Font.fredoka(.semiBold, size: 18))
                                 + Text("limited time")                                    .font(Font.fredoka(.bold, size: 18)))
                                    .foregroundColor(Clr.black2)
                                    .lineLimit(4)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.05)
                                    .padding(.top, 5)
                            }

                            Img.strawberryPacket
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.height * 0.3)
                                .padding()
                            HStack(spacing: 10) {
                                if isUnlocked {
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        withAnimation {
                                            shown = false
                                        }
                                    } label: {
                                        Capsule()
                                            .fill(Clr.brightGreen)
                                            .overlay(
                                                Text("Got it!")
                                                    .font(Font.fredoka(.bold, size: 18))
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                            )
                                            .frame(width: g.size.width * 0.4, height: g.size.height * 0.07)
                                    }.buttonStyle(NeumorphicPress())
                                } else {
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        withAnimation {
                                            shown = false
                                            Analytics.shared.log(event: .onboarding_finished_single_okay)
                                            UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
                                        }
                                    } label: {
                                        Capsule()
                                            .fill(Color.gray)
                                            .overlay(
                                                Text("Not now")
                                                    .font(Font.fredoka(.bold, size: 18))
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                            )
                                            .frame(width: g.size.width * 0.3, height: g.size.height * 0.06)
                                    }.buttonStyle(NeumorphicPress())
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        withAnimation {
                                            shown = false
                                            Analytics.shared.log(event: .onboarding_finished_single_course)
                                            UserDefaults.standard.setValue(false, forKey: "introLink")
                                            UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
                                            meditationModel.selectedMeditation = Meditation.allMeditations.first(where: { $0.id == 6 })
                                            viewRouter.currentPage = .middle
                                        }
                                    } label: {
                                        Capsule()
                                            .fill(Clr.brightGreen)
                                            .overlay(
                                                Text("Go to course!")
                                                    .font(Font.fredoka(.bold, size: 18))
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                            )
                                            .frame(width: g.size.width * 0.4, height: g.size.height * 0.06)
                                    }.buttonStyle(NeumorphicPress())
                                }

                            }
                        }.frame(width: g.size.width * 0.65, height: g.size.height * (isUnlocked ? 0.55 : 0.75), alignment: .center)
                    }.frame(width: g.size.width * 0.85, height: g.size.height * (isUnlocked ? 0.6 : 0.80), alignment: .center)
                    .background(Clr.darkWhite)
                    .cornerRadius(12)
                    Spacer()
                }
                if isUnlocked {
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct OnboardingModal_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingModal(shown: .constant(true))
    }
}
