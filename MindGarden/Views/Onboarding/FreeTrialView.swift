//
//  FreeTrialView.swift
//  MindGarden
//
//  Created by Vishal Davara on 20/06/22.
//

import SwiftUI
import OneSignal


struct FreeTrialView: View {
    
    @State private var isReminderOn : Bool = false
    @State private var showAlert = false
    @Binding var trialLength: Int
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 20) {
                    ZStack {
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 0)
                                .fill(
                                    .linearGradient(
                                        colors: [
                                            Clr.yellow,
                                            Clr.yellow.opacity(0.8),Clr.yellow.opacity(0.8),.white.opacity(0.1)],
                                        startPoint: .top,
                                        endPoint: .bottom)
                                )
                                .frame(width: 30,height:50)
                        }
                        Capsule()
                            .fill(Clr.darkgreen)
                            .frame(width: 30)
                            .overlay(
                                VStack {
                                    Spacer()
                                        .frame(height:10)
                                    Image(systemName: "lock.open.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:18)
                                        .foregroundColor(.white)
                                        .padding(3)
                                    Spacer()
                                    Image(systemName: "bell.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:16)
                                        .foregroundColor(.white)
                                        .padding(3)
                                    Spacer()
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:18)
                                        .foregroundColor(.white)
                                        .padding(3)
                                    Spacer()
                                        .frame(height:10)
                                }
                            ).padding(.bottom,40)
                    }
                        
                    VStack(alignment:.leading) {
                        let maxDay = (trialLength == 7 || trialLength == 1 ) ? 7 : 14
                        VStack(alignment:.leading) {
                            Text("Today")
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(Clr.black2)
                            Text("Get instant access and see how MindGarden changes your life.")
                                .lineLimit(2)
                                .font(Font.fredoka(.regular, size: 16))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(5)
                        VStack(alignment:.leading) {
                            Text(maxDay == 7 ? "Day 5" : "Day 12")
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(Clr.black2)
                            Text("We'll remind you with a notification that your trial is ending.")
                                .lineLimit(2)
                                .font(Font.fredoka(.regular, size: 16))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(5)
                        VStack(alignment:.leading) {
                            Text( maxDay == 7 ? "Day 7" : "Day 14")
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(Clr.black2)
                            Text("You will be charged on \((Date().getdateAfterdays(days: maxDay)?.toString(withFormat: "MMM dd")) ?? ""), cancel anytime before.")
                                .lineLimit(2)
                                .font(Font.fredoka(.regular, size: 16))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(5)
                    }
                }
                .padding(.horizontal,40)
                ZStack {
                    Clr.darkWhite
                        .cornerRadius(16)
                        .neoShadow()
                    HStack {
                        Toggle(" Remind me when my trial ends", isOn: $isReminderOn)
                            .onChange(of: isReminderOn) { val in
                                if val {
                                    if UserDefaults.standard.bool(forKey: "isNotifOn") == true {
                                        MGAudio.sharedInstance.playBubbleSound()
                                        NotificationHelper.freeTrial()
                                    } else {
                                        showAlert = true
                                    }
                                }
                            }
                            .font(Font.fredoka(.medium, size: 16))
                            .foregroundColor(Clr.black2)
                    }
                    .padding()
                }
                .padding()
                .padding(.horizontal,30)
                
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("You'll need to turn on Push"),
                message: Text("In order to fully experience MindGarden you'll need to turn on notifications"),
                primaryButton: Alert.Button.default(Text("Not now"), action: {
                    withAnimation {
                        isReminderOn = false
                    }
                    Analytics.shared.log(event: .experience_tapped_not_now)
                }),
                secondaryButton: .default(Text("Ok"), action: {
                    Analytics.shared.log(event: .experience_tapped_okay_push)
                    promptNotif()
                })
            )
        }
    }
    
    func promptNotif() {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            if accepted {
                Analytics.shared.log(event: .pricing_notif_accepted)
                NotificationHelper.addOneDay()
                NotificationHelper.addThreeDay()
                NotificationHelper.freeTrial()
            } else {
                Analytics.shared.log(event: .pricing_notif_denied)
                let current = UNUserNotificationCenter.current()
                current.getNotificationSettings(completionHandler: { permission in
                    switch permission.authorizationStatus  {
                    case .authorized:
                        withAnimation {
                            isReminderOn = true
                        }
                    case .denied:
                        isReminderOn = false
                        Analytics.shared.log(event: .notification_go_to_settings)
                        DispatchQueue.main.async {
                            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                                UIApplication.shared.open(appSettings)
                            }
                        }
                    case .notDetermined:
                        isReminderOn = false
                        UserDefaults.standard.setValue(false, forKey: "isNotifOn")
                        Analytics.shared.log(event: .notification_go_to_settings)
                        DispatchQueue.main.async {
                            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                                UIApplication.shared.open(appSettings)
                            }
                        }
                    default:
                        print("Unknow Status")
                    }
                })
            }
        })
    }
}
