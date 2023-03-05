//
//  ExperienceScene.swift
//  MindGarden
//
//  Created by Dante Kim on 9/5/21.
//

import SwiftUI
import OneSignal
import Amplitude

//TODO fix navigation bar items not appearing in ios 15 phones
struct ExperienceScene: View {
    @State private var selected: String = ""
    @State private var showNotification = false
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel

    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        VStack {
                GeometryReader { g in
                    let width = g.size.width
                    let height = g.size.height
                    ZStack {
                        Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                        VStack {
                            if !K.isSmall() && K.hasNotch() {
                                HStack {
                                    Img.topBranch
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.screenWidth * 0.6)
                                        .padding(.leading, -20)
                                        .offset(x: -20, y: -15)
                                    Spacer()
                                }
                            } else {
                                Spacer()
                            }
                            Text("What is your experience \nwith meditation?")
                                .font(Font.fredoka(.bold, size: 28))
                                .foregroundColor(Clr.darkgreen)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding(.top, 20)
                                .padding(.horizontal)
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .frame(height: 50)
                                .padding(.bottom, 16)
                            Spacer()
                            SelectionRow(width: width, height: height, title: Experience.often.title, img: Img.redTulips3, selected: $selected)
                            SelectionRow(width: width, height: height, title: Experience.nowAndThen.title, img: Img.redTulips2, selected: $selected)
                            SelectionRow(width: width, height: height, title: Experience.never.title, img: Img.redTulips1, selected: $selected)
                            Spacer()
                            Button {
                                MGAudio.sharedInstance.playBubbleSound()
                                Analytics.shared.log(event: .experience_tapped_continue)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                if selected != "" {
                                    switch selected {
                                    case Experience.often.title:
                                        OneSignal.sendTag("often", value: "true")
                                        Analytics.shared.log(event: .experience_tapped_alot)
                                    case Experience.nowAndThen.title:
                                        OneSignal.sendTag("tried", value: "true")
                                        Analytics.shared.log(event: .experience_tapped_some)
                                    case Experience.never.title:
                                        OneSignal.sendTag("never", value: "true")
                                        Analytics.shared.log(event: .experience_tapped_none)
                                    default:
                                        break
                                    }
                                    
                                    let identify = AMPIdentify()
                                        .set("experience", value: NSString(utf8String: selected))
                                    Amplitude.instance().identify(identify ?? AMPIdentify())
                                    
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        DispatchQueue.main.async {
                                            viewRouter.currentPage = .reason
                                            viewRouter.progressValue += 0.2
                                        }
                                    }
                                } //TODO gray out button if not selected
                            } label: {
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text("Continue 👉")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.fredoka(.bold, size: 20))
                                    ).addBorder(Color.black, width: 1.5, cornerRadius: 24)
                            }.frame(height: 50)
                                .padding()
                                .buttonStyle(NeumorphicPress())
                                .offset(y: 35)
                            Spacer()
                        }.frame(width: width * 0.9)
                }
            }
        }.onDisappear {
            meditationModel.getFeaturedMeditation()
        }
        .alert(isPresented: $showNotification) {
                Alert(
                    title: Text("You'll need to turn on Push"),
                    message: Text("In order to fully experience MindGarden you'll need to turn on notifications"),
                    primaryButton: Alert.Button.default(Text("Not now"), action: {
                        Analytics.shared.log(event: .experience_tapped_not_now)
                    }),
                    secondaryButton: .default(Text("Ok"), action: {
                        Analytics.shared.log(event: .experience_tapped_okay_push)
                        promptNotif()
                    })
                )
        }
        .transition(.move(edge: .trailing))
        .onAppear {
            Analytics.shared.log(event: .screen_load_experience)
        }
    }
    
    private func promptNotif() {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            if accepted {
                UserDefaults.standard.setValue("", forKey: K.defaults.meditationReminder)
                Analytics.shared.log(event: .onboarding_notification_on)
                NotificationHelper.addOneDay()
                NotificationHelper.addThreeDay()
                NotificationHelper.addOnboarding()
            } else {
                Analytics.shared.log(event: .onboarding_notification_off)
                
            }
        })
    }

    struct SelectionRow: View {
        var width, height: CGFloat
        var title: String
        var img: Image
        @Binding var selected: String
        @Environment(\.colorScheme) var colorScheme

        var body: some View {
            Button {
                MGAudio.sharedInstance.playBubbleSound()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    selected = title
                    UserDefaults.standard.setValue(title, forKey: "experience")
                }
            } label: {
                ZStack {
                    Rectangle()
                        .fill(selected == title ? Clr.brightGreen : Clr.darkWhite)
                        .cornerRadius(20)
                        .frame(height: height * 0.15)
                        .addBorder(Color.black, width: 1.5, cornerRadius: 20)
                        .padding(.horizontal)
                        .padding(.vertical, 8)

                    HStack(spacing: 50) {
                        Text(title)
                            .font(Font.fredoka(.semiBold, size: 20, relativeTo: .subheadline))
                            .foregroundColor(selected == title ?  Color.white : Clr.black2)
                            .padding()
                            .frame(width: width * 0.5, alignment: .leading)
                            .lineLimit(2)
                            .minimumScaleFactor(0.05)
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.125, height: height * (title == Experience.never.title ? 0.04 : 0.1))
                            .offset(x: -20, y: title == Experience.never.title ? 10 : 0)
                    }
                }
            }.buttonStyle(NeumorphicPress())
        }
    }
}

struct ExperienceScene_Previews: PreviewProvider {
    static var previews: some View {
        ExperienceScene()
    }
}


