//
//  ReasonModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 22/04/22.
//
import SwiftUI

enum ReasonType: String {
    case morePresent
    case improveMood
    case sleep
    case focus
    case anxiety
    case tryingItOut
}

var reasonList = [
    ReasonItem(type:.morePresent),
    ReasonItem(type:.improveMood),

    ReasonItem(type:.focus),
    ReasonItem(type:.anxiety),
    ReasonItem(type:.sleep),
    ReasonItem(type:.tryingItOut),
]

struct ReasonItem: Identifiable, Hashable {
    var id = UUID()
    var type: ReasonType
    
    var img: Image {
        switch self.type {
        case .sleep: return Img.sleepingSloth
        case .focus: return Img.target
        case .anxiety: return Img.heart
        case .morePresent: return Img.meditatingRacoon
        case .improveMood: return Img.happyPandaFace
        case .tryingItOut: return Img.magnifyingGlass
        }
    }
    
//    var tag: String {
//        switch self.type {
//        case .sleep: return "sleepBetter"
//        case .focus: return "focused"
//        case .anxiety: return "anxiety"
//        case .tryingItOut: return "trying"
//        }
//    }

    var title: String {
        switch self.type {
        case .morePresent: return "Be more present"
        case .improveMood: return "Improve your mood"
        case .focus: return "Improve your focus"
        case .anxiety: return "Managing Stress & Anxiety"
        case .sleep: return "Sleep better"
        case .tryingItOut: return "Just trying it out"
        }
    }
    
    var event: AnalyticEvent {
        switch self.type {
        case .sleep: return .reason_tapped_sleep
        case .focus: return .reason_tapped_focus
        case .anxiety: return .reason_tapped_stress
        case .improveMood: return .reason_tapped_improveMood
        case .morePresent: return .reason_tapped_bePresent
        case .tryingItOut: return .reason_tapped_trying
        }
    }
    
    static func getImage(str: String) -> Image {
        switch str {
        case "Sleep better": return Img.sleepingSloth
        case "Improve your focus": return Img.target
        case "Managing Stress & Anxiety": return Img.heart
        case "Be more present": return Img.meditatingRacoon
        case "Improve mood": return Img.happyPandaFace
        case "Just trying it out": return Img.magnifyingGlass
        default: return Img.magnifyingGlass
        }
    }
}
