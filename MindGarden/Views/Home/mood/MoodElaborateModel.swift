//
//  MoodElaborateModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 21/09/22.
//

import SwiftUI

struct MoodList: Codable,Identifiable {
    var id: String = UUID().uuidString
    let date: String
    let mood: String
    var subMood: String
    
    mutating func editMood(newvalue:String) {
        self.subMood = newvalue
    }
}

class MoodElaborateModel: ObservableObject {
    
    @Published var submoodList: [MoodList] = []
    let moodKey = "subMoods"
    func getAllSubMoods() {
        if let data = UserDefaults.standard.data(forKey: moodKey) {
            do {
                let decoder = JSONDecoder()
                let moods = try decoder.decode([MoodList].self, from: data)
                self.submoodList = moods
            } catch {
                print("Unable to Decode submoodList (\(error))")
            }
        } else {
            Mood.allCases.forEach { mood in
                for i in 0..<mood.options.count {
                    let item = MoodList(date: Date().toString(), mood: mood.title, subMood: "\(mood.options[i])")
                    self.submoodList.append(item)
                }
            }
            
            updateData()
        }
    }
    
    func addSubMood(submood: MoodList) {
        submoodList.append(submood)
        updateData()
    }
    
    func deleteSubmood(submood: MoodList){
        submoodList.removeAll { $0.id == submood.id }
        updateData()
    }
    
    func updateData() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.submoodList)
            UserDefaults.standard.set(data, forKey: moodKey)
        } catch {
            print("Unable to Encode Array of moods (\(error))")
        }
    }
}
