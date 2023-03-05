//
//  HomeTabView.swift
//  MindGarden
//
//  Created by Vishal Davara on 22/02/22.
//

import SwiftUI

struct HomeTabView: View {
    @Binding var selectedOption: PlusMenuType
    @ObservedObject var viewRouter: ViewRouter
    @Binding var selectedTab: TabType
    @Binding var showPopup : Bool
    @State var scale : CGFloat = 0.01
    @Binding var isOnboarding: Bool
    @State private var playEntryAnimation = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
                .opacity(showPopup ? 0.5 : 0)
                .onTapGesture {
                        DispatchQueue.main.async {
                            withAnimation(.spring()) {
                                    showPopup.toggle()
                            }
                        }
                }
                .offset(y: -16)
            TabButtonView(selectedTab:$selectedTab, isOnboarding:$isOnboarding)
                .padding([.bottom, .horizontal], 20)
            PlusButtonPopup(showPopup: $showPopup, scale: $scale, selectedOption: $selectedOption, isOnboarding: $isOnboarding)
        }.onChange(of: selectedTab) { value in
            showPopup = false
            DispatchQueue.main.async {
                setSelectedTab(selectedTab: value)
            }
        }
    }
    
    private func setSelectedTab(selectedTab:TabType){
        let tabName = selectedTab.rawValue.capitalized
        Analytics.shared.log(event: AnalyticEvent.getTab(tabName: tabName))
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.linear(duration: 0.4)) {
            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "garden" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "single" || UserDefaults.standard.bool(forKey: "review") {
                switch selectedTab {
                case .garden:
                    viewRouter.currentPage = .garden
                case .meditate:
                    viewRouter.currentPage = .meditate
                case .shop:
                    viewRouter.currentPage = .shop
                case .search:
                    viewRouter.currentPage = .learn
                }
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(selectedOption: .constant(.meditate), viewRouter: ViewRouter(), selectedTab: .constant(.meditate), showPopup: .constant(false), isOnboarding: .constant(false))
    }
}
