//
//  Breathwork.swift
//  MindGarden
//
//  Created by Dante Kim on 7/2/22.
//

import SwiftUI

struct Breathwork: Hashable {
    let title: String
    let sequence: [(Int,String)] // i = inhale, h = hold, e = exhale
    let duration: Int // Add up the sequence length
    let color: BreathColor
    let description: String
    let category: Category
    let img: Image
    let id: Int
    let instructor: String
    let isNew: Bool
    let recommendedUse: [String]
    let tip: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static let lockedBreaths = [-4, -5, -7]
    static func == (lhs: Breathwork, rhs: Breathwork) -> Bool {
        return lhs.id == rhs.id
    }
    static var breathworks: [Breathwork] = [
        Breathwork(title: "Waking Up", sequence: [(6, "i"),(0, "h"),(2, "e")], duration: 8,  color: .energy, description: "This exercise increases alertness, energy, and oxygen levels. Perfect for when you need to wake up or need a quick boost", category: .anxiety, img: Img.wakingup, id: -1, instructor: "none", isNew: false, recommendedUse: ["Before Exercise", "Low Energy", "Waking Up"], tip: "Sit up straight and breathe into your lower abdomen, doing your best to keep your chest and shoulders still while breathing."),
        Breathwork(title: "Energize", sequence: [(1, "i"),(0, "h"),(1, "e")], duration: 2,  color: .energy, description: "This exericse was designed to increase your energy and alertness instantly, using quick passive inhales and  active exhales, both equal in length to get you going.", category: .anxiety, img: Img.energy, id: -2, instructor: "none", isNew: false, recommendedUse: ["Before Work", "Focus", "Low Energy", "Before Exercise", "Waking Up"], tip: "Focus on breathing into your belly and ‘pumping’ the breath out as you exhale. This activates the diaphragm as you breathe forcefully through your nose."),
        Breathwork(title: "Unwind", sequence: [(4, "i"), (0, "h"), (8, "e")], duration: 12,  color: .sleep, description: "This exercise is designed to help clear the mind, reduce stress, and lower your heart rate and blood pressure", category: .anxiety, img: Img.unwind, id: -4, instructor: "none", isNew: false, recommendedUse: ["Before Bed", "To Relax", "Calm Racing Mind"], tip: "Breathe deeply into your diaphragm."),
        Breathwork(title: "Sleep", sequence: [(4, "i"), (7, "h"), (8, "e")], duration: 19,  color: .sleep, description: "This exercise is designed to help you fall asleep by activating the parasympathetic nervous system.", category: .anxiety, img: Img.sleep, id: -3, instructor: "none", isNew: false, recommendedUse: ["Before Bed", "To Relax", "Calm Racing Mind", "While Traveling"], tip: "Exhale slowly through your mouth like you’re blowing out a candle."),

        Breathwork(title: "Destress", sequence: [(4, "i"), (2, "h"), (6, "e")], duration: 12,  color: .calm, description: "Designed to calm the mind and body. By slowing down our breathing, we’re signaling our nervous system to calm down and relax.", category: .anxiety, img: Img.destress, id: -5, instructor: "none", isNew: false, recommendedUse: ["To Relax", "Stressed/Anxious", "Calm Racing Mind", "Before a Performance"], tip: "Breathe deeply into your diaphragm"),
        Breathwork(title: "Calm", sequence: [(4, "i"), (0, "h"), (6, "e")], duration: 10,  color: .calm, description: "Designed to reduce stress and calm the mind while lowering your heart rate and blood pressure..", category: .anxiety, img: Img.calm, id: -6, instructor: "none", isNew: false, recommendedUse: ["To Relax", "Stressed/Anxious", "Calm Racing Mind", "Before a Performance"], tip: "Sit or lay with your back supported and with your spine fairly straight as you breathe with the diaphragm."),
        Breathwork(title: "Pain Relief", sequence: [(4, "i"), (4, "h"), (6, "e")], duration: 14,  color: .vitality, description: " Designed to help alleviate pain throughout your body by increasing oxygenation and circulation. Great for headaches, muscle pain, and more.", category: .anxiety, img: Img.painrelief, id: -7, instructor: "none", isNew: false, recommendedUse: ["Tense Muscles", "Headache", "Hangover", "Body Ache"], tip: "Breathe with your belly and try to keep your chest and shoulders as still as possible."),
        Breathwork(title: "Vitality", sequence: [(4, "i"), (4, "h"), (4, "e")], duration: 12,  color: .vitality, description: "Practiced by the navy SEALS, benefits include reduced stress, lower blood pressure and cortisol levels, increased focus and elevated mood.", category: .anxiety, img: Img.vitality, id: -8, instructor: "none", isNew: false, recommendedUse: ["Anytime", "Low Energy", "Low Focus", "Stressed/Overwhelmed"], tip: "Try to keep your chest and shoulders as still as possible."),
    ]
}

enum BreathColor {
    case calm, vitality, energy, sleep
    
    var primary: Color {
        switch self {
        case .calm: return Clr.calmPrimary
        case .vitality: return Clr.healthPrimary
        case .energy: return Clr.energyPrimary
        case .sleep: return Clr.sleepPrimary
        }
    }
    
    var secondary: Color {
        switch self {
        case .calm: return Clr.calmsSecondary
        case .vitality: return Clr.healthSecondary
        case .energy: return Clr.energySecondary
        case .sleep: return Clr.sleepSecondary
        }
    }
    
    var image: String {
        switch self {
        case .calm:  return "leaf"
        case .energy: return "bolt.fill"
        case .vitality: return "bandage"
        case .sleep: return "moon.stars"
        }
    }
    var name: String {
        "\(self)"
    }
    
}
