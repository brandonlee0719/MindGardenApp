//
//  PromptsModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 30/06/22.
//

import SwiftUI

enum PromptsTabType: String {
    case gratitude,mentalHealth,evening,morning, bigPicture
}

var promptsTabList = [
    PromptsMenuItem(tabName: .gratitude),
    PromptsMenuItem(tabName: .morning),
    PromptsMenuItem(tabName: .mentalHealth),
    PromptsMenuItem(tabName: .evening),
    PromptsMenuItem(tabName: .bigPicture)
]

struct PromptsMenuItem: Identifiable {
    var id = UUID()
    var tabName: PromptsTabType
    
    var name: String {
        switch self.tabName {
        case .gratitude:
            return "🙏 Gratitude"
        case .mentalHealth:
            return "🎗️ Mental Health"
        case .evening:
            return "🌙 Evening"
        case .morning:
            return "☀️ Morning"
        case .bigPicture:
            return "🖼️ Big Picture"
        }
    }
}
