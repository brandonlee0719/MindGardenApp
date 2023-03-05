//
//  TabView.swift
//  MindGarden
//
//  Created by Vishal Davara on 23/02/22.
//

import SwiftUI

struct TabButtonView: View {
    @Binding var selectedTab: TabType
    @State var color: Color = .white
    @Binding var isOnboarding: Bool
    @State private var currentTab: TabType?
    @State var tag = 2
    
    var body: some View {
        ZStack(alignment:.center) {
            HStack {
                ForEach(tabList) { item in
                    Button {
                        if !isOnboarding || UserDefaults.standard.bool(forKey: "review") {
                            DispatchQueue.main.async {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    middleToSearch = ""
                                    selectedTab = item.tabName
                                    color = item.color
                                }
                            }
                        }
                    } label: {
                        VStack(spacing: 0) {
                            item.image
                                .resizable()
                                .renderingMode(.template)
                                .font(.body.bold()).aspectRatio(contentMode: .fit)
                                .frame(height: 22)
                            Text(item.name())
                                .minimumScaleFactor(0.5)
                                .font(Font.fredoka(.semiBold, size: 10))
                                .padding(.top, 5)
                        }
                        .foregroundColor(currentTab == item.tabName ? .black : .white)
                        .frame(maxWidth: .infinity)
                    }
                    .background(PositionReader(tag: item.index))
                    if item.tabName == .meditate {
                        Spacer().frame(maxWidth: .infinity)
                    }
                }
            }
            .backgroundPreferenceValue(Positions.self) { preferences in
                GeometryReader { proxy in
                    Capsule().fill(Clr.yellow).overlay(Capsule().stroke(.black, lineWidth: 1.5)).frame(width: 70, height: 50).position( self.getPosition(proxy: proxy, tag: self.tag, preferences: preferences))
                }
            }
            
        }
        .onChange(of: selectedTab) { val in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                setTab()
            }
        }
        .frame(height: 50, alignment: .center)
        .padding(8)
        .background(
            Capsule()
                .fill(Clr.brightGreen)
                .shadow(color:Clr.darkShadow.opacity(0.5), radius: 3 , x: 3, y: 3)
        )
        .overlay(
            Capsule()
                .stroke(.black, lineWidth: 1)
        )
        .onAppear(){
            setTab()
        }
    }
    
    private func setTab() {
        currentTab = selectedTab
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            switch selectedTab {
            case .garden:
                tag = 1
            case .meditate:
                tag = 2
            case .shop:
                tag = 3
            case .search:
                tag = 4
            }
        }
    }
    
    func getPosition(proxy: GeometryProxy, tag: Int, preferences: [PositionData])->CGPoint {
        let p = preferences.filter({ (p) -> Bool in
            p.id == tag
        })[0]
        return proxy[p.center]
    }
}


struct PositionData: Identifiable {
    let id: Int
    let center: Anchor<CGPoint>
}
struct Positions: PreferenceKey {
    static var defaultValue: [PositionData] = []
    static func reduce(value: inout [PositionData], nextValue: () -> [PositionData]) {
        value.append(contentsOf: nextValue())
    }
}

struct PositionReader: View {
    let tag: Int
    var body: some View {
        Color.clear.anchorPreference(key: Positions.self, value: .center) { (anchor)  in
                [PositionData(id: self.tag, center: anchor)]
        }
    }
}
