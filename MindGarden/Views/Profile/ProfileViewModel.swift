//
//  ProfileViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 8/31/21.
//

import Swift
import Combine
import Firebase
import FirebaseAuth
import Purchases
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = true
    @Published var signUpDate: String = ""
    @Published var totalMins: Int = 0
    @Published var totalSessions: Int = 0
    @Published var name: String = ""
    @Published var showWidget: Bool = false

    init() {}

    func update(userModel: UserViewModel, gardenModel: GardenViewModel) {
        self.signUpDate = userModel.joinDate
        self.name = userModel.name
        self.totalMins = gardenModel.allTimeMinutes
        self.totalSessions = gardenModel.allTimeSessions
    }

    func signOut() {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        
        UserDefaults.deleteAll()
        UserDefaults.standard.setValue(false, forKey: K.defaults.loggedIn)
        UserDefaults.standard.setValue("White Daisy", forKey: K.defaults.selectedPlant)
        UserDefaults.standard.setValue(false, forKey: "isPro")
        UserDefaults.standard.setValue("", forKey: K.defaults.onboarding)
        UserDefaults.standard.setValue("432hz", forKey: "sound")
        UserDefaults.standard.setValue(50, forKey: "coins")
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        UserDefaults.standard.setValue(formatter.string(from: Date()), forKey: "joinDate")
    }
}
