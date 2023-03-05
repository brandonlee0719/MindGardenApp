//
//  MindfulScene.swift
//  MindGarden
//
//  Created by Dante Kim on 12/21/21.
//

import SwiftUI

struct MindfulScene: View {
    @State private var breathing = false
    @State private var smiling = false
    @State private var gratitude = false
    @State private var present = false
    @State private var loving = false
    @State private var showSheet = false
    @State private var frequency = 2
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            GeometryReader { g in
                let width = g.size.width
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Img.topBranch
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenWidth * 0.6)
                                .padding(.leading, -20)
                                .offset(y: -10)
                            Spacer()
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 22))
                                .foregroundColor(Clr.darkgreen)
                                .padding()
                                .onTapGesture {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                        }
                        Spacer()
                        Text("Mindful Reminders")
                            .font(Font.fredoka(.bold, size: 30))
                            .padding(.top)
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                showSheet = true
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.darkWhite)
                                        .cornerRadius(14)
                                    HStack {
                                        Text("\(frequency) \(frequency == 1 ? "time" : "times") per day")
                                            .font(Font.fredoka(.semiBold, size: 26))
                                            .foregroundColor(Clr.darkgreen)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .font(Font.title)
                                    }.padding(.horizontal)
                                }.frame(width: width * 0.8, height: 65)
                            }.frame(width: width * 0.8)
                                .padding(.vertical)
                        }.buttonStyle(NeumorphicPress())
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(14)
                                .neoShadow()
                            VStack {
                                Row(title: "Breathing", notifType: $breathing)
                                Row(title: "Gratitude", notifType: $gratitude)
                                Row(title: "Smiling", notifType: $smiling)
                                Row(title: "Loving", notifType: $loving)
                                Row(title: "Being Present", notifType: $present)
                            }
                        }.frame(width: width * 0.8, height: 280)
                        Spacer()
                        Spacer()
                        Button {
                            var notifTypes = [String]()
                            if gratitude { notifTypes.append("gratitude") }
                            if breathing { notifTypes.append("breathing") }
                            if smiling { notifTypes.append("smiling") }
                            if loving  { notifTypes.append("loving") }
                            if present { notifTypes.append("present") }
                            UserDefaults.standard.setValue(notifTypes, forKey: "notifTypes")
                            UserDefaults.standard.setValue(frequency, forKey: "frequency")
                            NotificationHelper.createMindfulNotifs()
                            withAnimation {
                                presentationMode.wrappedValue.dismiss()
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()

                        } label: {
                            Capsule()
                                .fill(Clr.yellow)
                                .overlay(
                                    Text("Save")
                                        .foregroundColor(Clr.darkgreen)
                                        .font(Font.fredoka(.bold, size: 20))
                                )
                        }.frame(height: 50)
                            .padding(40)
                            .buttonStyle(NeumorphicPress())
                        }
                    Spacer()
                }
            }
        }.actionSheet(isPresented: $showSheet) {
            ActionSheet(title: Text("Frequency"),
                        buttons: [
                            .default(
                                Text("1 time"),
                                action: {
                                    frequency = 1
                                    showSheet = false
                                }
                            ),
                            .default(
                                Text("2 times"),
                                action: {
                                    frequency = 2
                                    showSheet = false
                                }
                            ),
                            .default(
                                Text("3 times"),
                                action: {
                                    frequency = 3
                                    showSheet = false
                                }
                            ),
                            .default(
                                Text("4 times"),
                                action: {
                                    frequency = 4
                                    showSheet = false
                                }
                            ),
                            .default(
                                Text("5 times"),
                                action: {
                                    frequency = 5
                                    showSheet = false
                                }
                            ),
                            .default(
                                Text("6 times"),
                                action: {
                                    frequency = 6
                                    showSheet = false
                                }
                            ),
                            .default(
                                Text("7 times"),
                                action: {
                                    frequency = 7
                                    showSheet = false
                                }
                            ),
                            .default(
                                Text("8 times"),
                                action: {
                                    frequency = 8
                                    showSheet = false
                                }
                            )
                        ]
            )
        }
        .onAppear {
            if let notifTypes = UserDefaults.standard.array(forKey: "notifTypes") as? [String] {
                for notif in notifTypes {
                    if notif == "gratitude" { gratitude = true }
                    if notif == "breathing" { breathing = true }
                    if notif == "loving" { loving = true }
                    if notif == "present" { present = true }
                    if notif == "smiling" { smiling = true }
                }
            }
            // TODO: toggle switches
        }
    }

    struct Row: View {
        var title: String
        @Binding var notifType: Bool
        var body: some View {
            HStack {
                Text("\(title) Reminders")
                Spacer()
                Toggle("", isOn: $notifType)
                    .onChange(of: notifType) { val in
                        if val {
                            notifType = true
                        } else { //turned off
                            notifType = false
                        }
                    }.toggleStyle(SwitchToggleStyle(tint: Clr.gardenGreen))
                    .frame(width: UIScreen.main.bounds.width * 0.08)
                    .padding(.trailing)
            }.frame(width: UIScreen.main.bounds.width * 0.7, height: 35, alignment: .center)
            if title != "Being Present" {
                Divider().frame(width: UIScreen.main.bounds.width * 0.7)
            }
        }
    }
}

struct MindfulScene_Previews: PreviewProvider {
    static var previews: some View {
        MindfulScene()
    }
}
