//
//  JourneyRow.swift
//  MindGarden
//
//  Created by Dante Kim on 5/27/22.
//

import SwiftUI

struct JourneyRow: View {
    
    let width: CGFloat
    let meditation: Meditation
    var meditationModel: MeditationViewModel
    var viewRouter: ViewRouter
    @Environment(\.sizeCategory) var sizeCategory
    @State var isLocked = false

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            meditationModel.selectedMeditation = meditation
            if viewRouter.currentPage == .learn {
                Analytics.shared.log(event: .discover_tapped_journey_med)
            } else {
                Analytics.shared.log(event: .home_tapped_journey_med)
            }
            withAnimation {
                if isLocked {
                    if viewRouter.currentPage == .learn {
                        fromPage = "discover"
                    } else {
                        fromPage = "home"
                    }
                    viewRouter.currentPage = .pricing
                } else {
                    withAnimation {
                        if meditation.type == .course {
                            viewRouter.currentPage = .middle
                        } else {
                            viewRouter.currentPage = .play
                        }
                    }
                }
            }
        } label: {
            ZStack {
                Rectangle()
                    .fill(Clr.darkWhite)
                    .cornerRadius(16)
                    .frame(width: width * 0.825, height: UIScreen.screenHeight * 0.225, alignment: .leading)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Clr.yellow, lineWidth: 3)
                    .frame(width: width * 0.825 - 4, height: UIScreen.screenHeight * 0.225 - 4, alignment: .leading)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                            Text(meditation.title)
                                .lineLimit(3)
                                .minimumScaleFactor(0.05)
                                .foregroundColor(Clr.brightGreen)
                                .font(Font.fredoka(.bold, size: 20))
                            HStack(spacing: 3) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(Clr.black2)
                                    .font(.system(size: 12))
                                Text(meditation.type.toString())
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.semiBold, size: 12))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                if Int(meditation.duration) != 0 {
                                    Circle()
                                        .fill(Clr.black2)
                                        .frame(width: 4, height: 4)
                                        .padding(.horizontal, 4)
                                    Image(systemName: "clock")
                                        .foregroundColor(Clr.black2)
                                        .font(.system(size: 12))
                                    Text((Int(meditation.duration/60) == 0 ? "1/2" : "\(Int(meditation.duration/60))") + " mins")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.fredoka(.semiBold, size: 12))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                }
                            }
                            HStack(spacing: 3) {
                                Image(systemName: "person.fill")
                                    .foregroundColor(Clr.black2)
                                    .font(.system(size: 12))
                                Text("Instructor:")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.regular, size: 12))
                                    .padding(.leading, 4)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                Text("\(meditation.instructor)")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.semiBold, size: 12))
                            }
                        }.frame(width: width * 0.4, height: UIScreen.screenHeight * 0.2, alignment: .leading)
                            .padding()
                            .padding(.leading, 10)
                        if meditation.imgURL != "" {
                            UrlImageView(urlString: meditation.imgURL)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.25, height: UIScreen.screenHeight * 0.2)
                                .padding()
                                .offset(x: -30)
                        } else {
                            meditation.img
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.25, height: UIScreen.screenHeight * 0.2)
                                .padding()
                                .offset(x: -30)
                        }

                }.frame(width: width * 0.825, height: UIScreen.screenHeight * 0.225, alignment: .leading)
            }
        }.buttonStyle(BonusPress())
        .cornerRadius(16)
        .neoShadow()
        .onAppear {
            isLocked = !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(meditation.id)
        }

    }
}

struct JourneyRow_Previews: PreviewProvider {
    static var previews: some View {
        JourneyRow(width: UIScreen.screenWidth, meditation: Meditation.allMeditations[0], meditationModel: MeditationViewModel(), viewRouter: ViewRouter())
    }
}
