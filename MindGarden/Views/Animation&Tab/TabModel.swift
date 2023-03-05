//
//  TabModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 22/02/22.
//

import SwiftUI

enum TabType: String {
    case garden
    case meditate
    case shop
    case search
}

var tabList = [
    TabMenuItem(image: Img.plantIcon, tabName: .garden, color: .white),
    TabMenuItem(image: Image(systemName: "house"), tabName: .meditate, color: .white),
    TabMenuItem(image: Img.search, tabName: .search, color: .white),
    TabMenuItem(image: Img.shopIcon, tabName: .shop, color: .white)
]

struct TabMenuItem: Identifiable {
    var id = UUID()
    var image: Image
    var tabName: TabType
    var color: Color
    
    func name() -> String {
        switch self.tabName {
        case .garden: return "Garden"
        case .meditate: return "Home"
        case .shop: return "Shop"
        case .search: return "Search"
        }
    }
    
    var index: Int {
        switch self.tabName {
        case .garden: return 1
        case .meditate: return 2
        case .shop: return 3
        case .search: return 4
        }
    }
    
}




