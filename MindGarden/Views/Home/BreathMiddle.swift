//
//  BreathMiddle.swift
//  MindGarden
//
//  Created by Dante Kim on 7/2/22.
//

import SwiftUI

struct BreathMiddle: View {
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var viewRouter:ViewRouter
    @State private var showPlay = false
    @State private var showPlant = false
    @State private var duration: Int = 60
    @State private var isFavorited: Bool = false
    @State private var breathWork: Breathwork = Breathwork.breathworks[0]

    
    var body: some View {
        if showPlay {
            BreathworkPlay(totalTime:$duration, showPlay:$showPlay, breathWork: medModel.selectedBreath)
                .environmentObject(userModel)
                .transition(.opacity)
        } else  {
            breathMiddle
        }
    }
    
    var breathMiddle: some View {
        ZStack {
            Clr.darkWhite
                .edgesIgnoringSafeArea(.all)
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                VStack {
                    HStack {
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            Analytics.shared.log(event: .breathwrk_middle_tapped_back)
                            withAnimation {
                                viewRouter.currentPage = viewRouter.previousPage
                            }
                        } label: {
                            Circle()
                                .fill(Clr.darkWhite)
                                .frame(width: 40)
                                .overlay(
                                    Image(systemName: "arrow.left")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15)
                                )
                        }.buttonStyle(NeoPress())
                        .offset(x: -5, y: 5)
                        Spacer()
                        HStack {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    showPlant = true
                                }
                            } label: {
                                HStack {
                                    userModel.selectedPlant?.head
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    Text("\(userModel.selectedPlant?.title ?? "none")")
                                        .font(Font.fredoka(.medium, size: 16))
                                        .foregroundColor(Clr.black2)
                                        .font(.footnote)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.05)
                                }
                                .frame(width: g.size.width * 0.3, height: 20)
                                .padding(8)
                                .background(Clr.yellow)
                                .cornerRadius(24)
                            }
                            .buttonStyle(BonusPress())
                        }
                        heart
                    }.frame(width: width - 60, height: 35)
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center, spacing: 30) {
                            HStack(spacing: 15) {
                                breathWork.img
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                VStack(alignment: .leading) {
                                    Text(breathWork.title)
                                        .font(Font.fredoka(.semiBold, size: 28))
                                    Text(breathWork.description)
                                        .font(Font.fredoka(.regular, size: 16))
                                }.foregroundColor(Clr.black2)
                                    .frame(width: width * 0.575, alignment: .leading)
                            }.frame(width: width - 60, height: height * 0.175)
                            HStack() {
                                Spacer()
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .breathwrk_middle_duration_1)
                                    withAnimation {
                                        duration = 30
                                    }
                                } label: {
                                    DurationButton(selected: $duration, duration: 30)
                                }.buttonStyle(NeoPress())
                                Spacer()
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .breathwrk_middle_duration_3)
                                    withAnimation {
                                        duration = 60
                                    }
                                } label: {
                                    DurationButton(selected: $duration, duration: 1)
                                }.buttonStyle(NeoPress())
                                Spacer()
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .breathwrk_middle_duration_5)
                                    withAnimation {
                                        duration = 180
                                    }
                                } label: {
                                    DurationButton(selected: $duration, duration: 3)
                                }.buttonStyle(NeoPress())
                                Spacer()
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    Analytics.shared.log(event: .breathwrk_middle_duration_10)
                                    withAnimation {
                                        duration = 300
                                    }
                                } label: {
                                    DurationButton(selected: $duration, duration: 5)
                                }.buttonStyle(NeoPress())
                                Spacer()
                            }.frame(width: width - 15)
                            
                            HStack {
                                Spacer()
                                BreathSequence(sequence: breathWork.sequence, width: width, height: height, color: breathWork.color.secondary)
                                Spacer()
                            }
                            
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.linear) {
                                        showPlay = true
                                    }
                                }
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .fill(Clr.yellow)
                                        .addBorder(Color.black, width: 1.5, cornerRadius: 32)
                                    HStack {
                                        Text("Start Breathwork")
                                            .font(Font.fredoka(.bold, size: 20))
                                        Image(systemName: "arrow.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .font(Font.title.weight(.bold))
                                            .frame(width: 20)
                                    }.foregroundColor(Clr.black2)
                                    
                                }.frame(width: width - 45, height: 50)
                            }.buttonStyle(NeoPress())
                            
                            (Text("💡 Tip: ").bold() + Text(breathWork.tip))
                                .font(Font.fredoka(.medium, size: 16))
                                .foregroundColor(Clr.darkGray)
                                .frame(width: width - 60, height: 70, alignment: .leading)
                            //MARK: - Recommended Use
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Recommended Use")
                                    .font(Font.fredoka(.semiBold, size: 20))
                                    .foregroundColor(Clr.black2)
                                VStack {
                                    WrappingHStack(list: breathWork.recommendedUse, geometry: g)
                                        .offset(x: -7)
                                }
                            }.frame(width: width - 60, alignment: .leading)
                                .offset(y: -15)
                            Spacer()
                        }
                    }
                }.padding(.top, K.hasNotch() ? 50 : 25)
            }.sheet(isPresented: $showPlant) {
                Store(isShop: false)
            }
        }.onAppear {
            medModel.updateSelf()
            if let breath = medModel.selectedBreath {
                breathWork = breath
            }
        }
    }
    
    var heart: some View {
        ZStack {
            LikeButton(isLiked: medModel.favoritedMeditations.contains(medModel.selectedBreath?.id ?? 0)) {
                likeAction()
            }
        }
    }
    
    private func likeAction(){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        Analytics.shared.log(event: .breathwrk_middle_favorited)
        medModel.favorite(id: breathWork.id)
        isFavorited.toggle()
    }
    
    struct DurationButton: View {
        @Binding var selected: Int
        let duration: Int
        
        var body: some View {
            ZStack {
                let width = UIScreen.screenWidth
                Rectangle()
                    .fill((duration * 60 == selected || selected == duration) ? Clr.yellow : Clr.darkWhite)
                    .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                    .frame(width: width/5.5, height: width/5.5)
                VStack(spacing: -5) {
                    Text(String(duration))
                        .font(Font.fredoka(.medium, size: 32))
                    Text(duration == 30 ? "sec" : "min")
                        .font(Font.fredoka(.regular, size: 20))
                }.foregroundColor(Clr.black2)
            }
        }
    }
    //MARK: - Breath Sequence
    struct BreathSequence:  View {
        let sequence: [(Int,String)]
        let width, height: CGFloat
        let color: Color
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(color)
                    .frame(height: height * 0.175)
                    .opacity(0.4)
                    .addBorder(Color.black, width: 1.5, cornerRadius: 14)
                    .padding(.horizontal, 15)
                VStack {
                    Text("Breath Sequence")
                        .font(Font.fredoka(.semiBold, size: 16))
                    HStack {
                        // inhale
                        VStack(spacing: 3) {
                            Image(systemName: "nose")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                            HStack(spacing: 15) {
                                Image(systemName: "line.diagonal.arrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 12)
                                    .rotationEffect(sequence[0].1 == "e" ? .degrees(180) : .degrees(0))
                                    .foregroundColor(.black)
                                Image(systemName: "line.diagonal.arrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 12)
                                    .rotationEffect(.degrees(270))
                                    .rotationEffect(sequence[0].1 == "e" ? .degrees(180) : .degrees(0))
                                    .foregroundColor(.black)
                            }.foregroundColor(Clr.calmsSecondary)
                            VStack(spacing: -3) {
                                Text(String(sequence[0].0))
                                    .font(Font.fredoka(.semiBold, size: 16))
                                Text(sequence[0].1 == "i" ? "Inhale" : "Exhale")
                                    .font(Font.fredoka(.regular, size: 16))
                            }.offset(y: -7)
                        }
                        if sequence[1].0 != 0 {
                            Spacer()
                            // hold
                            VStack(spacing: 3) {
                                Image(systemName: "pause.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35)
                                    .offset(y: -5)
                                
                                VStack(spacing: -3) {
                                    Text(String(sequence[1].0))
                                        .font(Font.fredoka(.semiBold, size: 16))
                                    Text("Hold")
                                        .font(Font.fredoka(.regular, size: 16))
                                }
                            }
                        }
                        Spacer()
                        VStack(spacing: 3) {
                            mouth
                            HStack(spacing: 15) {
                                Image(systemName: "line.diagonal.arrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 12)
                                    .rotationEffect(sequence[2].1 == "e" ? .degrees(180) : .degrees(0))
                                    .foregroundColor(.black)
                                Image(systemName: "line.diagonal.arrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 12)
                                    .rotationEffect(.degrees(270))
                                    .rotationEffect(sequence[2].1 == "e" ? .degrees(180) : .degrees(0))
                                    .foregroundColor(.black)
                            }.foregroundColor(Clr.calmsSecondary)
                            VStack(spacing: -3) {
                                Text(String(sequence[2].0))
                                    .font(Font.fredoka(.semiBold, size: 16))
                                Text(sequence[2].1 == "i" ? "Inhale" : "Exhale")
                                    .font(Font.fredoka(.regular, size: 16))
                            }.offset(y: -7)
                        }
                    }.frame(width: width * 0.5)
                }.foregroundColor(Clr.black2)
            }
            
        }
        
        var mouth: some View {
            Image(systemName: "mouth")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .offset(y: 5)
        }
    }
    
}

struct BreathMiddle_Previews: PreviewProvider {
    static var previews: some View {
        BreathMiddle()
    }
}

struct WrappingHStack: View {
    let list: [String]
    let geometry: GeometryProxy
    
    var body: some View {
        self.generateContent(in: geometry)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.list, id: \.self) { platform in
                self.item(for: platform)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width - 40)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if platform == self.list.first! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if platform == self.list.first! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }
    
    func item(for text: String) -> some View {
        Text(text)
            .font(Font.fredoka(.medium, size: 16))
            .foregroundColor(Clr.black2)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.black, lineWidth: 1.5)
            )
    }
}
