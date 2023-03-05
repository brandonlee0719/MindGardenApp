//
//  ReminderView.swift
//  demo
//
//  Created by Vishal Davara on 29/04/22.
//

import SwiftUI
import OneSignal

struct ReminderView: View {
    let reminderTitle = "1. ⏰ Remind me Tomorrow"
    @Binding var playAnim: Bool
    @State private var time = 0.0
    @State private var isToggled : Bool = false
    @State private var changeHeight = false
    var body: some View {
        ZStack {
  
            // when I give it a frame it appears on load, when I don't it doesn't, it's hidden
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Clr.darkWhite)
                        .cornerRadius(32)
                    VStack {
                        HStack {
                            Text(reminderTitle)
                                .font(Font.fredoka(.semiBold, size: 20))
                                .foregroundColor(Clr.black2)
                            Spacer()
//                            Image(systemName: "xmark")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .foregroundColor(Clr.black2)
//                                .frame(width: 15)
                        }.padding([.top, .horizontal], 24)
                        Slider(value: $time, in: 0...86399)
                            .accentColor(.gray)
                            .padding(.top,20)
                            .padding(.horizontal)
                        HStack {
                            Image(systemName: "cloud.sun")
                                .resizable()
                                .foregroundColor(Clr.brightGreen)
                                .aspectRatio(contentMode: .fit)
                            Spacer()
                            Image(systemName: "sun.max.fill")
                                .resizable()
                                .foregroundColor(Clr.dirtBrown)
                                .aspectRatio(contentMode: .fit)
                            Spacer()
                            Image(systemName: "moon.stars.fill")
                                .resizable()
                                .foregroundColor(Clr.freezeBlue)
                                .aspectRatio(contentMode: .fit)
                        }.frame(height: 20, alignment: .center)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 24)
                        ZStack {
                            Rectangle()
                                .fill(Clr.lightGray)
                                .opacity(0.4)
                                .cornerRadius(32, corners: [.bottomLeft, .bottomRight])
                            HStack {
                                if let timeInterval = TimeInterval(time) {
                                    Text(timeInterval.secondsToHourMinFormat() ?? "")
                                        .font(Font.fredoka(.bold, size: 20))
                                        .foregroundColor(Clr.black2)
                                    Toggle("", isOn: $isToggled)
                                        .onChange(of: isToggled) { val in
                                        if val {
                                            if !UserDefaults.standard.bool(forKey: "showedNotif") {
                                                OneSignal.promptForPushNotifications(userResponse: { accepted in
                                                    if accepted {
                                                        if isNextSteps {
                                                            Analytics.shared.log(event: .nextsteps_created_reminder)
                                                        } else {
                                                            Analytics.shared.log(event: .finished_set_reminder)
                                                        }
                                                        NotificationHelper.addOneDay()
                                                        NotificationHelper.addThreeDay()
                                                        // UserDefaults.standard.setValue(true, forKey: "mindful")
                                                        // NotificationHelper.createMindfulNotifs()
                                                        if UserDefaults.standard.bool(forKey: "freeTrial")  {
                                                            NotificationHelper.freeTrial()
                                                        }
                                                        withAnimation {
                                                            playAnim.toggle()
                                                        }
                                                        promptNotification()
                                                    } else {
                                                        isToggled = false
                                                    }
                                                    UserDefaults.standard.setValue(true, forKey: "showedNotif")
                                                })
                                            } else {
                                                promptNotification()
                                            }
                                        }
                                    }
                                }
                            }.padding(.horizontal, 30)
                        }.frame(height: 75)
                    }
                }
            }
        }.frame(height: UIScreen.screenHeight * (playAnim ? 0 : (K.isSmall() ? 0.325 : 0.28)))
            .opacity(playAnim ? 0 : 1)
           .animation(.spring().delay(0.25), value: playAnim)
           .addBorder(.black, width: 1.5, cornerRadius: 32)
           .shadow(color: .black.opacity(0.25), radius: 1, x:  3 , y: 3)
    }
    
    private func promptNotification() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                UserDefaults.standard.setValue(true, forKey: "isNotifOn")
                UserDefaults.standard.setValue(TimeInterval(time).secondsToHourMinFormat(), forKey: K.defaults.meditationReminder)
                if UserDefaults.standard.value(forKey: "oneDayNotif") == nil {
                    NotificationHelper.addOneDay()
                }
                if UserDefaults.standard.value(forKey: "threeDayNotif") == nil {
                    NotificationHelper.addThreeDay()
                }

                if UserDefaults.standard.bool(forKey: "freeTrial")  {
                    NotificationHelper.freeTrial()
                }
                UserDefaults.standard.setValue(true, forKey: "notifOn")
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute]
                formatter.zeroFormattingBehavior = .pad
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"

                let date = dateFormatter.date(from: formatter.string(from: time) ?? "")
                dateFormatter.dateFormat = "hh:mm a"
                let realDate = dateFormatter.string(from: date ?? Date())
                
                UserDefaults.standard.setValue(dateFormatter.date(from: realDate), forKey: "notif")
                
                for i in 1...7 {
                    let dateTime = dateFormatter.date(from: TimeInterval(time).secondsToHourMinFormat() ?? "12:54") ?? Date()
                    let datee = NotificationHelper.createDate(weekday: i, hour: Int(dateTime.get(.hour)) ?? 0, minute: Int(dateTime.get(.minute)) ?? 0)
                    NotificationHelper.scheduleNotification(at: datee,  weekDay: i)
                }
            case .notDetermined:
                UserDefaults.standard.setValue(false, forKey: "isNotifOn")
                Analytics.shared.log(event: .notification_go_to_settings)
                DispatchQueue.main.async {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
                isToggled = false
                return
            case .denied:
                UserDefaults.standard.setValue(false, forKey: "isNotifOn")
                Analytics.shared.log(event: .notification_go_to_settings)
                DispatchQueue.main.async {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
                isToggled = false
                return
            default:
                print("testing")
                break
            }
        })
    }
}
