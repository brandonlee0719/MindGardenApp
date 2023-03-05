//
//  Sound.swift
//  MindGarden
//
//  Created by Dante Kim on 8/8/21.
//

import SwiftUI

enum Sound {
    case rain
    case night
    case nature
    case fire
    case beach
    case fourThirtyTwo
    case beta
    case alpha
    case theta
    case flute
    case guitar
    case music
    case piano1
    case piano2
    case noSound

    var img: Image {
        switch self {
        case .rain:
            return Image(systemName: "cloud.rain")
        case .night:
            return Image(systemName: "moon.stars")
        case .nature:
            return Image(systemName: "leaf")
        case .beach:
            return Image("beach")
        case .fire:
            return Image(systemName: "flame")
        case .fourThirtyTwo:
            return Img.fourThirtyTwo
        case .beta:
            return Img.beta
        case .alpha:
            return Img.alpha
        case .theta:
            return Img.theta
        case .flute:
            return Img.fluteNotes
        case .guitar:
            return Img.guitar
        case .piano1:
            return Img.piano1
        case .piano2:
            return Img.piano2
        case .music:
            return Img.music
        case .noSound:
            return Image("beach")
        }
    }
    
    var title: String {
        switch self {
        case .rain:
            return "rain"
        case .night:
            return "night"
        case .nature:
            return "nature"
        case .beach:
            return "beach"
        case .fire:
            return "fire"
        case .fourThirtyTwo:
            return "432hz"
        case .beta:
            return "beta"
        case .alpha:
            return "alpha"
        case .theta:
            return "theta"
        case .piano1:
            return "piano1"
        case .piano2:
            return "piano2"
        case .flute:
            return "flute"
        case .guitar:
            return "guitar"
        case .music:
            return "music"
        
        case .noSound:
            return "noSound"
        }
    }

    static func getSound(str: String) -> Sound {
        switch str {
        case "rain":
            return .rain
        case "night":
            return .night
        case "nature":
            return .nature
        case "beach":
            return .beach
        case "fire":
            return .fire
        case "432hz":
            return .fourThirtyTwo
        case "beta":
            return .beta
        case "alpha":
            return .alpha
        case "theta":
            return .theta
        case "piano1":
            return .piano1
        case "piano2":
            return .piano2
        case "flute":
            return .flute
        case "guitar":
            return .guitar
        case "music":
            return .music
        case "noSound":
            return .noSound
        default:
            return .noSound
        }
    }
}
