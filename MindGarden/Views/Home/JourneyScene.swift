//
//  JourneyScene.swift
//  MindGarden
//
//  Created by Vishal Davara on 01/06/22.
//

import SwiftUI

struct JourneyScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @State var userModel: UserViewModel
    @State var isAward = false
    let width = UIScreen.screenWidth
    let height = UIScreen.screenHeight - 100
    
    var body: some View {
        VStack {
            
            if userModel.journeyFinished {
                Text("✅ Journey Complete!")
                    .foregroundColor(Clr.black2)
                    .font(Font.fredoka(.semiBold, size: 28))
                    .padding(.top, 30)
                    .frame(width: abs(width * 0.825), alignment: .leading)
                VStack {
                    LottieView(fileName: "sloth")
                        .offset(x: -65)
                }.frame(width: 100, height: 100)
                Text("Only 1% complete the roadmap.\n Email team@mindgarden.io with  a screenshot, we'd like to give you gift.\n-💚 MindGarden Team")
                    .font(Font.fredoka(.medium, size: 20))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 140)
                    .frame(width: abs(width * 0.825), alignment: .center)
            } else {
                VStack {
                    if model.roadMaplevel == 6 {
                        ( Text("🧭 Roadmap ")
                            .foregroundColor(Clr.black2)
                          + Text("Final Level")
                            .foregroundColor(Clr.darkgreen))
                        .font(Font.fredoka(.semiBold, size: 28))
                        .padding(.top, 30)
                        .frame(width: abs(width * 0.825), alignment: .leading)
                    } else {
                        ( Text("🧭 Roadmap Level: ")
                            .foregroundColor(Clr.black2)
                          + Text("\(model.roadMaplevel)")
                            .foregroundColor(Clr.darkgreen))
                        .font(Font.fredoka(.semiBold, size: 28))
                        .padding(.top, 30)
                        .frame(width: abs(width * 0.825), alignment: .leading)
                    }
                    ForEach(model.roadMapArr.indices) { idx in
                        if idx != model.roadMapArr.count && idx < model.roadMapArr.count {
                            HStack(spacing: 10) {
                                let item = model.roadMapArr[idx]
                                let isPlayed = userModel.shouldBeChecked(id: item, roadMapArr: model.roadMapArr, idx: idx)
                                let isLocked = !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(item)
                                VStack(spacing:5) {
                                    DottedLine()
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                        .opacity((idx == 0) ? 0 : 0.5)
                                        .frame(width:2)
                                    if isLocked {
                                        Img.lockIcon
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                    } else {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(isPlayed ? Clr.darkgreen : Clr.lightGray)
                                    }
                                    DottedLine()
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                        .opacity((idx == model.roadMapArr.count - 1) ? 0 : 0.5)
                                        .frame(width:2)
                                }
                                JourneyRow(width: width * 0.85, meditation: Meditation.allMeditations.first { $0.id == item } ?? Meditation.allMeditations[0], meditationModel: model, viewRouter: viewRouter)
                                    .padding([.horizontal, .bottom])
                                    .opacity(isLocked ? 0.5 : 1.0)
                            }.frame(width: width * 0.9, alignment: .trailing)
                            
                        }
                    }
                    
                    Text("Level Completion Award")
                        .foregroundColor(Clr.black2)
                        .font(Font.fredoka(.medium, size: 12))
                    Button {
                        if model.roadMaplevel <= 6 && isAward {
                            userModel.updateCoins(plusCoins: model.roadMaplevel < 2 ? 1000 : model.roadMaplevel > 4 ? 1500 :  1250)
                            if model.roadMaplevel == 6 {
                                userModel.journeyFinished = true
                                userModel.finishedJourney()
                                isAward = false
                            } else {
                                model.getUserMap()
                                isAward = false
                            }
                            MGAudio.sharedInstance.stopSound()
                            MGAudio.sharedInstance.playSound(soundFileName: "plantUnlock.mp3")
                        }
                    } label: {
                        HStack {
                            Img.tripleCoins
                                .resizable()
                                .foregroundColor(Color.black)
                                .font(.system(size: 28, weight: .bold))
                                .aspectRatio(contentMode: .fill)
                                .frame(width:30)
                            Text(model.roadMaplevel < 2 ? "1000" : model.roadMaplevel > 4 ? "1500" : "1250")
                                .foregroundColor(Clr.black2)
                                .font(Font.fredoka(.bold, size: 22))
                                .padding(5)
                        }
                        .padding()
                        .background(Clr.yellow)
                    }.opacity(isAward ? 1.0 : 0.4)
                        .frame(height: 44, alignment: .center)
                        .buttonStyle(BonusPress())
                        .cornerRadius(15)
                        .neoShadow()
                }.frame(width: width)
            }
        }.onAppear(){
            model.getUserMap()
            let completedMeditations = userModel.completedMeditations
            model.roadMapArr.forEach { id in
                let startingIdx = model.roadMapArr.firstIndex(of: id) ?? 0
                let endingIdx = model.roadMapArr.lastIndex(of: id) ?? 0
                let comMedCount = completedMeditations.filter { med in (med) == String(id)}.count
                if !completedMeditations.contains(String(id)) {
                    isAward = false
                    return
                } else if comMedCount < endingIdx - startingIdx + 1 {
                    isAward = false
                    return
                } else {
                    isAward = true
                }
            }
        }
    }
}


struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}
