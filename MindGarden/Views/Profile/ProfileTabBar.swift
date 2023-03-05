//
//  StoreTabView.swift
//  MindGarden
//
//  Created by Dante Kim on 7/7/22.
//

import SwiftUI

struct ProfileTab: View {
    @Binding var selectedTab: TopTabType
    
    var body: some View {
        ZStack (alignment:.center) {
            HStack {
                if selectedTab == .settings { Spacer() }
                if selectedTab == .profile { Spacer() }
                Capsule()
                    .fill(.white.opacity(0.4))
                    .frame(width:UIScreen.screenWidth*0.27)
                    .padding(.vertical,3)
                    .addBorder(.black, width: 1.5, cornerRadius: 16)
                    .offset(x: selectedTab == .settings ? 2 : -2)
                if selectedTab == .profile { Spacer() }
                if selectedTab == .referral { Spacer() }
            }.padding(.horizontal,3)
            HStack(alignment:.center) {
                ForEach(profileTabList) { item in
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        DispatchQueue.main.async {
                            withAnimation {
                                selectedTab = item.tabName
                                if selectedTab == .profile {
                                    Analytics.shared.log(event: .profile_tapped_profile)
                                } else if selectedTab == .settings {
                                    Analytics.shared.log(event: .profile_tapped_settings)
                                } else if selectedTab == .referral {
                                    Analytics.shared.log(event: .profile_tapped_refer)
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
        ).addBorder(.black, width: 1.5, cornerRadius: 16)
         .shadow(color: Clr.blackShadow.opacity(0.4), radius: 2, x: 2, y: 2)
    }
}

struct ProfileTabPreview: PreviewProvider {
    static var previews: some View {
        StoreTab(selectedTab: .constant(.profile))
    }
}
