//
//  DiscoverScene.swift
//  MindGarden
//
//  Created by Vishal Davara on 26/05/22.
//

import SwiftUI
import Lottie

var learnNotif = false
struct DiscoverScene: View {
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    @State private var selectedTab: TopTabType = .quickStart
    @State private var tappedSearch = false
    var body: some View {
        ZStack(alignment:.top) {
            Clr.darkWhite
            let width = UIScreen.screenWidth
            ZStack(alignment:.top) {
                Arc(startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
                    .fill(Clr.yellow)
                    .frame(width: width, height: width*0.83)
                    .offset(y:-width)
                VStack {
                    Spacer().frame(height:(width*0.13))
                    HStack {
                        Text("Discover")
                            .minimumScaleFactor(0.5)
                            .font(Font.fredoka(.bold, size: 32))
                            .foregroundColor(Clr.darkgreen)
                            .multilineTextAlignment(.center)
                        Spacer()
                        Img.discoverSearch
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                Analytics.shared.log(event: .discover_tapped_search)
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                medSearch = true
                                tappedSearch = true
                            }
                    }
                    .frame(height:36)
                    .padding(.vertical,4)
                    .padding(.horizontal,28)
                    DiscoverTab(selectedTab: $selectedTab)
                        .padding(.horizontal,24)
                        .frame(height:36)
                }
            }
            .zIndex(1)
            VStack(spacing:0) {
                Spacer().frame(height:(width/2)*0.8)
                tabView
                    .zIndex(0)
            }
        }
        .sheet(isPresented: $tappedSearch) {
            CategoriesScene(isSearch: true, showSearch: $tappedSearch, isBack: .constant(false))
                .frame(height: UIScreen.screenHeight - 90)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if learnNotif {
                selectedTab = .learn
                learnNotif = false
            }
        }
        .onAppearAnalytics(event: .screen_load_discover)
    }
    
    var tabView: some View {
        return Group {
            switch selectedTab {
            case .journey:
                ZStack {
                    ScrollView(showsIndicators: false) {
                        JourneyScene(userModel: userModel)
                        Spacer().frame(height:120)
                    }
                }
            case .quickStart:
                QuickStart()
            case .learn:
                LearnScene()
                    .environmentObject(bonusModel)
            default: EmptyView()
            }
        }
    }
}

struct DiscoverScene_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverScene()
    }
}

struct Arc: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = UIScreen.screenWidth
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: clockwise)
        return path
    }
}
