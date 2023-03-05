//
//  CategoryModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 02/08/22.
//

import SwiftUI

enum Category {
    case all
    case breathwork
    case sadness
    case unguided
    case courses
    case beginners
    case anxiety
    case focus
    case confidence
    case growth
    case sleep

    var value: String {
        switch self {
        case .all:
            return "👨‍🌾 All"
        case .unguided:
            return "⏳ Unguided"
        case .beginners:
            return "😁 Beginners"
        case .courses:
            return "👨‍🏫 Courses"
        case .anxiety:
            return "😖 Anxiety"
        case .focus:
            return "🎧 Focus"
        case .sadness:
            return "😢 Sadness"
        case .sleep:
            return "😴 Sleep"
        case .confidence:
            return "💪 Confidence"
        case .growth:
            return "🌱 Growth"
        case .breathwork:
            return "💨 Breathwork"
        }
    }
}
