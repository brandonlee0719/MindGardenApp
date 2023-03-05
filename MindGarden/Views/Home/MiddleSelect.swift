//
//  MiddleSelect.swift
//  MindGarden
//
//  Created by Dante Kim on 7/19/21.
//

import SwiftUI

@available(iOS 14.0, *)

//FONTs Used
// Plant Select:.semibold,16
// Title: 28 semibold, description: 16, regular
// Row titles: 16 semibold
//HomeSquares
//Title: 28, semibold
//subscript: 12, regular

struct MiddleSelect: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var userModel: UserViewModel
    @State private var tappedMeditation: Bool = false
    @State private var lastPlayed: Int = -1
    @State private var showPlant = false
    enum currentState {
        case locked,checked,playable
    }
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                VStack {
                    ZStack {
                        Img.morningSun
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.screenWidth * 0.9)
                        backButton.padding(.trailing, UIScreen.main.bounds.width/1.35)
                        heart
                            .padding(.leading, UIScreen.main.bounds.width/1.2)
                    }.frame(width: g.size.width)
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Clr.darkWhite)
                            .frame(width: g.size.width, height: g.size.height)
                            .cornerRadius(44)
                            .neoShadow()
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                HStack {
                                    Text("Selected Plant:")
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        showPlant = true
                                    } label: {
                                        HStack {
                                            userModel.selectedPlant?.head
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                            Text("\(userModel.selectedPlant?.title ?? "none")")
                                                .font(Font.fredoka(.semiBold, size: 16))
                                                .foregroundColor(Clr.black2)
                                                .font(.footnote)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.05)
                                        }
                                        .frame(width: g.size.width * 0.3, height: 20)
                                        .padding(8)
                                        .background(Clr.yellow)
                                        .cornerRadius(24)
                                        .addBorder(.black, width: 1.5, cornerRadius: 24)
                                    }
                                    .buttonStyle(BonusPress())
                                }
                            }.foregroundColor(Clr.black2)
                                .font(Font.fredoka(.semiBold, size: 16))
                                .padding(.top)
                                .padding(.bottom, -10)
                            HStack(spacing: 0) {
                                if model.selectedMeditation?.imgURL != "" {
                                    UrlImageView(urlString: model.selectedMeditation?.imgURL ?? "")
                                        .frame(width: g.size.width/3.5, height: g.size.height/(K.isSmall() ? 4 : 5))
                                        .padding(.horizontal, 10)
                                } else {
                                    model.selectedMeditation?.img
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: g.size.width/3.5, height: g.size.height/(K.isSmall() ? 4 : 5))
                                        .padding(.horizontal, 10)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(model.selectedMeditation?.title ?? "")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.fredoka(.semiBold, size: 28))
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.05)
                                    Text(model.selectedMeditation?.description ?? "")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.fredoka(.regular, size: 16))
                                        .lineLimit(5)
                                        .minimumScaleFactor(0.05)
                                }.frame(width: g.size.width/1.7)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .offset(x: -15)
                            }
                            .padding(15)
                            .frame(width: g.size.width)
                            Divider().padding([.bottom, .horizontal])
                            VStack {
                                ForEach(Array(zip(model.selectedMeditations.indices, model.selectedMeditations)), id: \.0) { (idx,meditation) in
                                    MiddleRow(width: g.size.width/1.2, meditation: meditation, viewRouter: viewRouter, model: model, didComplete: ((meditation.type == .lesson || meditation.type == .single_and_lesson) && userModel.completedMeditations.contains(String(meditation.id)) && meditation.belongsTo != "Timed Meditation" && meditation.belongsTo != "Open-ended Meditation"), tappedMeditation: $tappedMeditation, idx: idx, lastPlayed: $lastPlayed)
                                }
                            }
                            
                            Divider().padding()
                            HStack(spacing: 15) {
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    if !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(model.recommendedMeds[0].id) {
                                        Analytics.shared.log(event: .middle_tapped_locked_recommended)
                                        fromPage = "middle"
                                        withAnimation {
                                            viewRouter.currentPage = .pricing
                                        }
                                    } else {
                                        Analytics.shared.log(event: .middle_tapped_recommended)
                                        model.selectedMeditation = model.recommendedMeds[0]
                                        if model.selectedMeditation?.type == .course {
                                            viewRouter.currentPage = .middle
                                        } else {
                                            viewRouter.currentPage = .play
                                        }
                                    }
                                } label: {
                                    HomeSquare(width: g.size.width, height: g.size.height * 0.8, meditation: model.recommendedMeds[0], breathwork: nil)
                                }.buttonStyle(NeumorphicPress())
                                
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    if !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(model.recommendedMeds[1].id) {
                                        Analytics.shared.log(event: .middle_tapped_locked_recommended)
                                        fromPage = "middle"
                                        withAnimation {
                                            viewRouter.currentPage = .pricing
                                        }
                                    } else {
                                        Analytics.shared.log(event: .middle_tapped_recommended)
                                        model.selectedMeditation = model.recommendedMeds[1]
                                        if model.selectedMeditation?.type == .course {
                                            viewRouter.currentPage = .middle
                                        } else {
                                            viewRouter.currentPage = .play
                                        }
                                    }
                                } label: {
                                    HomeSquare(width: g.size.width, height: g.size.height * 0.8, meditation: model.recommendedMeds[1], breathwork: nil)
                                }
                            }
                            .frame(width: g.size.width - 60)
                            .padding([.vertical, .horizontal], 15)
                            .padding(.bottom, g.size.height * (K.hasNotch() ? 0.25 : 0.4))
                        }
                    }
                }
            }.zIndex(25)
        }.sheet(isPresented: $showPlant) {
            Store(isShop: false)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
            leading: ZStack {
                
            }.offset(x: -10)
        )
        .edgesIgnoringSafeArea(.bottom)
        .transition(.scale)
        .animation(tappedMeditation ? nil : .default)
        .onAppear {
            model.selectedBreath = nil
            model.updateSelf()
            if let id =  model.selectedMeditations.lastIndex(where: { ($0.type == .lesson || $0.type == .single_and_lesson) && userModel.completedMeditations.contains(String($0.id)) && $0.belongsTo != "Timed Meditation" && $0.belongsTo != "Open-ended Meditation"}) {
                lastPlayed = id
            }
        }
        .onAppearAnalytics(event: .screen_load_middle)
    }
    
    var backButton: some View {
        Button {
            Analytics.shared.log(event: .middle_tapped_back)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation {
                viewRouter.currentPage = viewRouter.previousPage
            }
        } label: {
            Image(systemName: "arrow.backward")
                .font(.title)
                .foregroundColor(Clr.brightGreen)
        }.offset(x: -10)
    }
    
    var heart: some View {
        ZStack {
            LikeButton(isLiked: model.favoritedMeditations.contains(model.selectedMeditation?.id ?? 0)) {
                likeAction()
            }
        }
    }
    
    private func likeAction(){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if let med = model.selectedMeditation {
            Analytics.shared.log(event: .middle_tapped_favorite)
            model.favorite(id: med.id)
        }
    }
    
    struct MiddleRow: View {
        let width: CGFloat
        let meditation: Meditation
        let viewRouter: ViewRouter
        let model: MeditationViewModel
        let didComplete: Bool
        @State var state: currentState = .playable
        @Binding var tappedMeditation: Bool
        @State var isFavorited: Bool = false
        let idx: Int
        @Binding var lastPlayed: Int
        
        var body: some View {
            Button {
                if state == .locked {return}
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                Analytics.shared.log(event: .middle_tapped_row)
                tappedMeditation = true
                model.selectedMeditation = meditation
                withAnimation {
                    viewRouter.currentPage = .play
                }
            } label: {
                HStack {
                    Text("\(idx + 1).")
                        .foregroundColor(Clr.darkgreen)
                        .font(Font.fredoka(.semiBold, size: 16))
                        .padding(.trailing, 3)
                    Text(meditation.title)
                        .foregroundColor(state == .checked ? Clr.darkgreen : Clr.black2)
                        .font(Font.fredoka(.semiBold, size: 16))
                        .strikethrough(state == .checked)
                        .lineLimit(2)
                        .minimumScaleFactor(0.05)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    switch state {
                    case .locked:
                        Image(systemName: "lock.fill")
                            .renderingMode(.template)
                            .foregroundColor(Clr.darkgreen)
                            .font(.system(size: 20))
                            .padding(.horizontal, 10)
                    case .checked:
                        Image(systemName: "checkmark.circle.fill")
                            .renderingMode(.template)
                            .foregroundColor(Clr.darkgreen)
                            .font(.system(size: 20))
                            .padding(.horizontal, 10)
                    case .playable:
                        Image(systemName: "play.fill")
                            .foregroundColor(Clr.darkgreen)
                            .font(.system(size: 20))
                            .padding(.trailing, 15)
                    }
                    
                    LikeButton(isLiked: isFavorited, size:25.0) {
                        if state != .locked {
                            Analytics.shared.log(event: .middle_tapped_row_favorite)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            model.favorite(id: meditation.id)
                            isFavorited.toggle()
                        }
                    }
                }.opacity(state == .locked ? 0.5 : 1)
            }
            .padding(5)
            .frame(width: width)
            .onAppear {
                model.selectedBreath = nil
                if didComplete && meditation.belongsTo != "Timed Meditation" && meditation.belongsTo != "Open-ended Meditation" {
                    state = .checked
                } else if  meditation.belongsTo == "Timed Meditation" || meditation.belongsTo == "Open-ended Meditation" {
                    state =  .playable
                } else {
                    state =  (idx - 1 == lastPlayed) ? .playable : .locked
                }
                
                isFavorited = model.favoritedMeditations.contains { $0 == meditation.id }
            }
        }
    }
}

@available(iOS 14.0, *)
struct MiddleSelect_Previews: PreviewProvider {
    static var previews: some View {
        MiddleSelect()
            .environmentObject(MeditationViewModel())
            .environmentObject(ViewRouter())
    }
}
