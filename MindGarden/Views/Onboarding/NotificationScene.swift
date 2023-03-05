//
//  NotificationScene.swift
//  MindGarden
//
//  Created by Dante Kim on 9/5/21.
//

import SwiftUI
import OneSignal
import Amplitude
import Lottie

struct NotificationScene: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var dateTime = Date()
    @State private var frequency = "Everyday"
    @State private var bottomSheetShown = false
    @State private var showAlert = false
    @State private var showActionSheet = false
    var fromSettings: Bool

    var displayedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: dateTime)
    }

    init(fromSettings: Bool = false) {
        self.fromSettings = fromSettings
        //        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        //        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        ZStack {
            GeometryReader { g in
                let width = g.size.width
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack(spacing: -5) {
                        HStack {
                            Img.topBranch
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenWidth * 0.6)
                                .padding(.leading, -20)
                                .offset(y: -10)
                            Spacer()
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 20))
                                .foregroundColor(Clr.darkgreen)
                                .padding()
                                .onTapGesture {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        viewRouter.progressValue -= 0.2
                                        if fromSettings {
                                            presentationMode.wrappedValue.dismiss()
                                        } else if tappedTurnOn {
                                            viewRouter.currentPage = .review
                                            tappedTurnOn = false
                                        } else {
                                            viewRouter.currentPage = .name
                                        }
                                    }
                                }
                                .opacity(fromSettings ? 0 : 1)
                                .disabled(fromSettings)
                        }
                        VStack {
                            Text("🔔 Set a Reminder")
                                .font(Font.fredoka(.semiBold, size: 28))
                                .foregroundColor(Clr.black1)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .offset(y: -20)
                            (Text("Users who set a reminder are")
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.medium, size: 20))
                             + Text(" 4x more likely ")
                                .foregroundColor(Clr.darkgreen)
                                .font(Font.fredoka(.bold, size: 20))
                             + Text("to stick with meditation")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.fredoka(.medium, size: 20)))
                                .multilineTextAlignment(.center)
                                .frame(height: 50)
                                .offset(y: -20)
                                .lineLimit(3)
                                .minimumScaleFactor(0.05)
                                .frame(width: width * 0.85)
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    bottomSheetShown.toggle()
                                }
                            } label: {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(12)
                                    .frame(width: width * 0.6, height: 75)
                                    .overlay(
                                        HStack {
                                            Text("\(displayedTime)")
                                                .font(Font.fredoka(.bold, size: 40))
                                                .foregroundColor(Clr.black2)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .font(Font.title)
                                                .foregroundColor(Clr.black2)
                                        }.padding(.horizontal)
                                    )
                            }.buttonStyle(NeumorphicPress())
                                .padding()
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                showActionSheet = true
                            } label: {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(12)
                                    .frame(width: width * 0.6, height: 50)
                                    .overlay(
                                        HStack {
                                            Text("\(frequency)")
                                                .font(Font.fredoka(.bold, size: 26))
                                                .foregroundColor(Clr.black2)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .font(Font.title)
                                                .foregroundColor(.black)
                                        }.padding([.horizontal])
                                    )
                            }.buttonStyle(NeumorphicPress())
                            Spacer()
                            Img.turtleLetter
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: g.size.width * 0.4)

//                            LottieAnimationView(filename: "turtleNotif", loopMode: LottieLoopMode.autoReverse, isPlaying: .constant(true))
//                                .frame(width: g.size.width * 0.6)
                            Spacer()
                            Button {
                                Analytics.shared.log(event: .notification_tapped_turn_on)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    OneSignal.promptForPushNotifications(userResponse: { accepted in
                                        if accepted {
                                            Analytics.shared.log(event: .onboarding_notification_on)
                                            promptNotification()
                                        } else {
                                            promptNotification()
                                        }
                                    })
                                }
                            } label: {
                                Capsule()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text(fromSettings ? "Turn On" : "🔔 Set Reminder")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.fredoka(.bold, size: 20))
                                    )
                                    .addBorder(.black, width: 1.5, cornerRadius: 24)
                            }.frame(height: 50)
                                .padding(5)
                                .buttonStyle(NeumorphicPress())
                            if !fromSettings {
                                Text("Skip")
                                    .foregroundColor(.gray)
                                    .padding()
                                    .onTapGesture {
                                        let identify = AMPIdentify()
                                            .set("reminder_set", value: NSNumber(0))
                                        Amplitude.instance().identify(identify ?? AMPIdentify())
                                        UserDefaults.standard.setValue(false, forKey: "isNotifOn")
                                        Analytics.shared.log(event: .notification_tapped_skip)
                                        withAnimation {
                                            withAnimation(.easeOut(duration: 0.5)) {
                                                DispatchQueue.main.async {
                                                    if tappedTurnOn {
                                                        viewRouter.currentPage = .review
                                                    } else {
                                                        viewRouter.progressValue = 1.0
                                                        viewRouter.currentPage = .review
                                                    }
                                                }
                                            }
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        }
                                    }
                            }
                        }.frame(width: width * 0.85)
                        .padding(.top, 5)
                    }

                    if bottomSheetShown  {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        Spacer()
                    }
                }
                BottomSheetView(
                    dateSelected: $dateTime,
                    isOpen: self.$bottomSheetShown,
                    maxHeight: g.size.height * 0.6
                ) {
                    DatePicker("", selection: $dateTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .offset(y: -25)
                }.offset(y: g.size.height * 0.3)
            }
        }
        .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Frequency"),
                            buttons: [
                                .default(
                                    Text("Everyday"),
                                    action: {
                                        frequency = "Everyday"
                                        showActionSheet = false
                                    }
                                ),
                                .default(
                                    Text("On Weekends"),
                                    action: {
                                        frequency = "Weekends"
                                        showActionSheet = false
                                    }
                                ),
                                .default(
                                    Text("On Weekdays"),
                                    action: {
                                        frequency = "Weekdays"
                                        showActionSheet = false
                                    }
                                )
                            ]
                )
            }
        .transition(.move(edge: .trailing))
        .onAppearAnalytics(event: .screen_load_notification)
//            .alert(isPresented: $showAlert) {
//                Alert(title: Text("Turn on Notifications"), message: Text("We'll do our best not to annoy you"), dismissButton: .default(Text("Go to Settings"), action: {
//                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
//                        UIApplication.shared.open(appSettings)
//                    }
//                    showAlert = false
//                }))
//            }

    }
    
    private func promptNotification() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                let identify = AMPIdentify()
                    .set("reminder_set", value: NSNumber(1))
                Amplitude.instance().identify(identify ?? AMPIdentify())
                
                UserDefaults.standard.setValue(true, forKey: "isNotifOn")
                UserDefaults.standard.setValue(dateTime, forKey: K.defaults.meditationReminder)
                if UserDefaults.standard.value(forKey: "oneDayNotif") == nil {
                    NotificationHelper.addOneDay()
                }
                
                if UserDefaults.standard.value(forKey: "threeDayNotif") == nil {
                    NotificationHelper.addThreeDay()
                }
                if UserDefaults.standard.value(forKey: "onboardingNotif") == nil {
                    NotificationHelper.addOnboarding()
                }

                if fromSettings && UserDefaults.standard.bool(forKey: "freeTrial")  {
                    NotificationHelper.freeTrial()
                }
                
                UserDefaults.standard.setValue(dateTime, forKey: "notif")
                UserDefaults.standard.setValue(true, forKey: "notifOn")

                if frequency == "Everyday" {
                    for i in 1...7 {
                        let datee = NotificationHelper.createDate(weekday: i, hour: Int(dateTime.get(.hour)) ?? 0, minute: Int(dateTime.get(.minute)) ?? 0)
                        NotificationHelper.scheduleNotification(at: datee,  weekDay: i)
                    }
                } else if frequency == "Weekdays" {
                    for i in 2...6 {
                        NotificationHelper.scheduleNotification(at: NotificationHelper.createDate(weekday: i, hour: Int(dateTime.get(.hour)) ?? 0, minute: Int(dateTime.get(.minute)) ?? 0), weekDay: i)
                    }
                } else { // weekend
                    NotificationHelper.scheduleNotification(at: NotificationHelper.createDate(weekday: 1, hour: Int(dateTime.get(.hour)) ?? 0, minute: Int(dateTime.get(.minute)) ?? 0), weekDay: 1)
                    NotificationHelper.scheduleNotification(at: NotificationHelper.createDate(weekday: 7, hour: Int(dateTime.get(.hour)) ?? 0, minute: Int(dateTime.get(.minute)) ?? 0), weekDay: 7)
                }
             
                DispatchQueue.main.async {
                    if fromSettings {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        if !tappedTurnOn {
                            viewRouter.progressValue += 0.2
                        }
                        viewRouter.currentPage = .review
                    }
                }
            case .denied:
                    Analytics.shared.log(event: .notification_go_to_settings)
                    DispatchQueue.main.async {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                            UIApplication.shared.open(appSettings)
                        }
                    }
            case .notDetermined:
                if fromSettings || tappedTurnOn {
                    UserDefaults.standard.setValue(false, forKey: "isNotifOn")
                    Analytics.shared.log(event: .notification_go_to_settings)
                    DispatchQueue.main.async {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                            UIApplication.shared.open(appSettings)
                        }
                    }
                }
            default:
                print("Unknow Status")
            }
        })
    }
}



struct NotificationScene_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScene()
    }
}

enum Constants {
    static let radius: CGFloat = 24
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetView<Content: View>: View {
    @GestureState private var translation: CGFloat = 0
    @Binding var dateSelected: Date
    @Binding var isOpen: Bool
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        HStack {
            Text("Done").padding().foregroundColor(Clr.darkWhite)
            Spacer()
            RoundedRectangle(cornerRadius: Constants.radius)
                .fill(Color.secondary)
                .frame(
                    width: Constants.indicatorWidth,
                    height: Constants.indicatorHeight
                )
            Spacer()
            Text("Done")
                .font(Font.fredoka(.bold, size: 18))
                .foregroundColor(Clr.darkgreen)
                .onTapGesture {
                    Analytics.shared.log(event: .notification_tapped_done)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    self.isOpen.toggle()
                }
                .padding(.horizontal)
        }
    }

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    init(dateSelected: Binding<Date>, isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
        self._dateSelected = dateSelected
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(), value: isOpen)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else { return }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}
