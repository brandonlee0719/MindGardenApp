//
//  DiscoverModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 26/05/22.
//

import SwiftUI

enum TopTabType: String {
    case journey,quickStart, learn, store, badge, realTree, referral, settings, profile
}

var discoverTabList = [
    MenuItem(tabName: .journey),
    MenuItem(tabName: .quickStart),
    MenuItem(tabName: .learn)
]
var storeTabList = [
    MenuItem(tabName: .store),
    MenuItem(tabName: .badge),
    MenuItem(tabName: .realTree)
]
var profileTabList = [
    MenuItem(tabName: .referral),
    MenuItem(tabName: .profile),
    MenuItem(tabName: .settings)
]


struct MenuItem: Identifiable {
    var id = UUID()
    var tabName: TopTabType
    
    var name: String {
        switch self.tabName {
        case .journey: return "Journey"
        case .quickStart: return "Quick Start"
        case .learn: return "Library"
        case .store: return "Store"
        case .badge: return "Badge"
        case .realTree: return "Real Tree"
        case .referral: return "Referral"
        case .profile: return "Profile"
        case .settings: return "Settings"
        }
    }
}
