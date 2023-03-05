//
//  JourneyModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 06/07/22.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

enum Mood: String, CaseIterable {
    var options: [String] {
    switch self {
        case .veryGood: return ["😃 Excited", "😊 happy", "🎨 Inspired",  "💪 Confident", "🌱 Hopeful", "💚 Loved", "👏 Proud", "🙏 Grateful",  "☀️ Joyful"]
        case .good: return ["🌱 Hopeful", "😌 Calm",  "🙂 Good",  "🏃 Busy", "😃 Excited", "✊ Fulfilled", "🙏 Grateful", "😊 happy", "🎨 Inspired"]
        case .okay: return ["😐 Fine", "🥱 Bored", "🙃 Unsure", "🏃 Busy", "😌 Calm", "🤨 Confused", "😠 Frustrated", "😴 Tired", "✈️ Distant"]
        case .bad: return ["😰 anxious", "😩 stressed", "🏎️ Impatient", "😤 Frustrated", "😒 annoyed", "😴 Tired", "😟 Nervous", "😨 Scared", "😓 Insecure", "🥲 Sad", "🥱 Bored", "😞 Disappointed"]
        case .veryBad: return ["😰 anxious", "😩 stressed", "😡 Angry",  "😨 Scared", "😢 Depressed", "😓 Judged", "😖 Disrespected", "😞 Disappointed", "💔 Hurt", "🤢 Sick", "😭 Grief"]
        default: return [""]
        }
    }
    
    static func allMoodCases() -> [Mood] {
        return [veryBad, bad, okay, good,veryGood]
    }

    case happy
    case okay
    case sad
    case angry
    case stressed
    case veryGood
    case good
    case bad
    case veryBad
    case none

    var id: String { return self.rawValue }
    
    var title: String {
        switch self {
        case .happy: return "happy"
        case .okay: return "okay"
        case .sad: return "sad"
        case .angry: return "angry"
        case .stressed: return "stressed"
        case .veryGood: return "very good"
        case .good: return "good"
        case .bad: return "bad"
        case .veryBad: return "very bad"
        case .none: return "none"
        }
    }

    static func getMood(str: String) -> Mood {
        switch str {
        case "happy": return .happy
        case "okay": return .okay
        case "sad":  return .sad
        case "angry": return .angry
        case "stressed":  return .stressed
        case "very good": return .veryGood
        case "good": return .good
        case "bad": return .bad
        case "very bad": return .veryBad
        case "none":
            return .none
        default:
            return .none
        }
    }

    var color: Color {
        switch self {
        case .happy: return Clr.gardenGreen
        case .okay: return Clr.okay
        case .sad: return Clr.gardenBlue
        case .angry: return Clr.gardenRed
        case .stressed: return Clr.purple
        case .veryGood: return Clr.veryGood
        case .good: return Clr.good
        case .bad: return Clr.bad
        case .veryBad: return Clr.veryBad
        case .none: return Clr.dirtBrown
        }
    }
    static func getMoodImage(mood: Mood) -> Image {
        switch mood {
        case .happy:
            return Image("veryGood")
        case .sad:
            return Image("sadPot")
        case .angry:
            return Image("angryPot")
        case .okay:
            return Image("okay")
        case .stressed:
            return Image("stressedPot")
        case .bad: return Image("bad")
        case .veryBad: return Image("veryBad")
        case .good: return Image("good")
        case .veryGood: return Image("veryGood")
        default:
            return Image("okay")
        }
    }
    
    static func getMoodImageWidget(mood: Mood) -> Image {
        switch mood {
        case .happy:
            return Image("widget_happyPot")
        case .sad:
            return Image("widget_sadPot")
        case .angry:
            return Image("widget_angryPot")
        case .okay:
            return Image("widget_okayPot")
        case .stressed:
            return Image("widget_stressedPot")
        case .bad: return Image("bad")
        case .veryBad: return Image("veryBad")
        case .good: return Image("good")
        case .veryGood: return Image("veryGood")
        default:
            return Image("okay")
        }
    }
    
}
struct MoodData: Codable,Identifiable {
    var id: String = UUID().uuidString
    let date: String
    let mood: String
    let subMood: String
}

class MoodModel: ObservableObject {
    @Published var moodList: [MoodData] = []
    let db = Firestore.firestore()
    
    func getAllMoods(){
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.mood).document(email).collection(K.defaults.moods).getDocuments { [weak self] (querySnapshot, error) in
                if let err = error {
                    print("Error getting documents \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        var ids = ""
                        var date = ""
                        var mood = ""
                        var subMood = ""
                        
                        if let idx = document["id"] as? String {
                            ids = idx
                        }
                        if let dt = document["date"] as? String {
                            date = dt
                        }
                        if let ind = document["mood"] as? String {
                            mood = ind
                        }
                        if let subMd = document["subMood"] as? String {
                            subMood = subMd
                        }
                        let moodObj = MoodData(id:ids, date: date, mood: mood, subMood: subMood)
                        self?.moodList.append(moodObj)
                    }
                }
            }
        } else {
            if let data = UserDefaults.standard.data(forKey: K.defaults.moods) {
                do {
                    let decoder = JSONDecoder()
                    let moods = try decoder.decode([MoodData].self, from: data)
                    self.moodList = moods
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
        }
    }
    
    func addMood(mood:MoodData){
        self.moodList.append(mood)
        if let email = Auth.auth().currentUser?.email {
            self.db.collection(K.mood).document(email).collection(K.defaults.moods).addDocument(data:[
                "id":mood.id,
                "date": mood.date,
                "mood": mood.mood,
                "subMood": mood.subMood,
            ]) { (err) in
                if err != nil {
                    print(err?.localizedDescription as Any)
                    return
                }
                print("mood saved successfully")
            }
        } else {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(self.moodList)
                UserDefaults.standard.set(data, forKey: K.defaults.moods)
            } catch {
                print("Unable to Encode Array of moods (\(error))")
            }
        }
    }
}

