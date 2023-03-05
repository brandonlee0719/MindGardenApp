//
//  StoreTabView.swift
//  MindGarden
//
//  Created by Dante Kim on 7/7/22.
//

import SwiftUI

struct StoreTab: View {
    @Binding var selectedTab: TopTabType
    
    var body: some View {
        ZStack (alignment:.center) {
            HStack {
                if selectedTab == .realTree { Spacer() }
                if selectedTab == .badge { Spacer() }
                Capsule()
                    .fill(.white.opacity(0.4))
                    .frame(width:UIScreen.screenWidth*0.27)
                    .padding(.vertical,3)
                    .addBorder(.black, width: 1.5, cornerRadius: 16)
                    .offset(x: selectedTab == .realTree ? 2 : -2)
                if selectedTab == .badge { Spacer() }
                if selectedTab == .store { Spacer() }
            }.padding(.horizontal,3)
            HStack(alignment:.center) {
                ForEach(storeTabList) { item in
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        DispatchQueue.main.async {
                            withAnimation {
                                selectedTab = item.tabName
                                withAnimation {
                                    if selectedTab == .store {
                                        Analytics.shared.log(event: .screen_load_store)
                                    } else if selectedTab == .badge {
                                        Analytics.shared.log(event: .screen_load_badge)
                                    } else {
                                        Analytics.shared.log(event: .screen_load_real_tree)
                                    }
                                }
                            }
                        }
                    } label: {
                        ZStack(alignment:.center) {
                            Text(item.name)
                                .minimumScaleFactor(0.5)
                                .font(Font.fredoka(.medium, size: 16))
                                .foregroundColor(selectedTab == item.tabName ? Color.white : Color.white)
                                .multilineTextAlignment(.center)
                                .padding(.leading, item.name == "Store" ? 10 : 0)
                                .padding(.trailing, item.name == "Real Tree" ? 10 : 0)
                        }
                        .foregroundColor(selectedTab == item.tabName ? Clr.black2 : Color.white)
                        .frame(maxWidth: .infinity)
                        
                    }
                }
            }
            .padding(.vertical,5)
        }
        .frame(height: 36, alignment: .top)
        .background(
            Clr.brightGreen
            .cornerRadius(18)
        )
        .addBorder(.black, width: 1.5, cornerRadius: 16)
        .shadow(color: Clr.blackShadow.opacity(0.4), radius: 2, x: 2, y: 2)
    }
}

struct StoreTabView_Previews: PreviewProvider {
    static var previews: some View {
        StoreTab(selectedTab: .constant(.realTree))
    }
}
