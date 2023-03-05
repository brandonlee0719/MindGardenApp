//
//  NewUpdateModal.swift
//  MindGarden
//
//  Created by Dante Kim on 10/4/21.
//

import SwiftUI

struct ChallengeModal: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @Binding var shown: Bool
    @State var challengeDate = ""
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    var body: some View {
        GeometryReader { g in
            let width = g.size.width
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Button {
                                Analytics.shared.log(event: .challenge_tapped_x)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    shown = false
                                }
                                UserDefaults.standard.setValue(challengeDate, forKey: "challengeDate")
                                UserDefaults.standard.setValue(true, forKey: "showedChallenge")
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.title)
                                    .padding(10)
                            }
                            Text("💪 \(Date().getMonthName(month: (Date().get(.month)))) Challenge")
                                .multilineTextAlignment(.center)
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(Clr.black2)
                                .frame(height: g.size.height * 0.1)
                                .minimumScaleFactor(0.5)
                                .lineLimit(2)
                            Image(systemName: "xmark")
                                .font(.title)
                                .padding(10)
                                .opacity(0)
                        }.padding([.horizontal])
                            .frame(width: g.size.width * 0.85)
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(20)
                                .neoShadow()
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Clr.darkgreen, lineWidth: 3)
                            HStack(spacing: 5) {
                                VStack(alignment: .leading){
                                    HStack {
                                        Text("Complete the Intro to Meditation Course before ")
                                            .font(Font.fredoka(.semiBold, size: 18))
                                            .foregroundColor(Clr.black2)
                                        + Text(challengeDate)
                                            .font(Font.fredoka(.semiBold, size: 18))
                                            .foregroundColor(Clr.brightGreen)
                                       +  Text(" and unlock a limited edition ")
                                            .font(Font.fredoka(.semiBold, size: 18))
                                            .foregroundColor(Clr.black2)
                                        + Text("Cherry Blossom")
                                            .font(Font.fredoka(.bold, size: 18))
                                            .foregroundColor(Clr.cherryPink)
                                    } .multilineTextAlignment(.leading)
                                    .padding()
                                }
                            }
                        }.frame(width: width * 0.75, height: g.size.height * 0.18)
                   
                        Img.cherryBlossomPacket
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:  g.size.height * 0.3)
                            .padding(50)
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                shown = false
                                Analytics.shared.log(event: .challenge_tapped_accept)
                                meditationModel.selectedMeditation = Meditation.allMeditations.first(where: { $0.id == 6 })
                                UserDefaults.standard.setValue(challengeDate, forKey: "challengeDate")
                                viewRouter.currentPage = .middle
                                UserDefaults.standard.setValue(true, forKey: "showedChallenge")
                                if let oneId = UserDefaults.standard.value(forKey: "oneDayNotif") as? String {
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oneId])
                                    NotificationHelper.addOneDay()
                                }
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.yellow)
                                .overlay(
                                    Text("Accept Challenge!")
                                        .font(Font.fredoka(.bold, size: 18))
                                        .foregroundColor(Clr.darkgreen)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                )
                                .frame(width: g.size.width * 0.75, height: g.size.height * 0.065)
                        }.buttonStyle(NeumorphicPress())
                        .offset(y: -20)
                        Spacer()
                    }
                    .font(Font.fredoka(.regular, size: 18))
                    .frame(width: g.size.width * 0.85, height: g.size.height * 0.8, alignment: .center)
                    .minimumScaleFactor(0.05)
                    .background(Clr.darkWhite)
                    .neoShadow()
                    .cornerRadius(12)
                    .offset(y: -50)
                    Spacer()
                }
                Spacer()
            }
        }.onAppear {
            let cal = NSCalendar.current
            var date = cal.startOfDay(for: Date())
            date = cal.date(byAdding: Calendar.Component.day, value: 7, to: date) ?? Date()
            
            challengeDate = formatter.string(from: date)
        }
    }
}

struct ChallengeModalPreview: PreviewProvider {
    static var previews: some View {
        ChallengeModal(shown: .constant(true))
            .environmentObject(ViewRouter())
    }
}
