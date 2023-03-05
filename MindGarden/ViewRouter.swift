//
//  ViewRouter.swift
//  MindGarden
//
//  Created by Dante Kim on 6/7/21.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var previousPage: Page = .meditate
    @Published var currentPage: Page = 
    {
        if UserDefaults.standard.bool(forKey: K.defaults.loggedIn) {
            return .meditate
        } else if UserDefaults.standard.bool(forKey: "review") {
            return .meditate
        } else {
            switch UserDefaults.standard.string(forKey: K.defaults.onboarding) {
            case "done": return .meditate
            case "signedUp": return .meditate
            case "mood": return .meditate
            case "gratitude": return .meditate
            case "meditate": return .garden
            case "stats": return .garden
            case "calendar": return .garden
            default: return .onboarding
            }
        }
    }()
    @Published var progressValue: Float = 0.3
}

enum Page {
    case meditate
    case garden
    case shop
    case play
    case categories
    case middle
    case breathMiddle
    case authentication
    case finished
    case onboarding
    case experience
    case reason
    case notification
    case name
    case pricing
    case review
    case learn
    case mood
    case journal
}
