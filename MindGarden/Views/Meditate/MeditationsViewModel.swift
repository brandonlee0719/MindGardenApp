//
//  MeditationsViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 7/15/21.
//

import SwiftUI
import Combine
import Firebase
import AVKit
import FirebaseFirestore
import OneSignal
import Amplitude

var medSearch = false
var middleToSearch = ""
class MeditationViewModel: ObservableObject {
    @Published var selectedMeditations: [Meditation] = []
    @Published var favoritedMeditations: [Int] = []
    @Published var newMeditations:  [Meditation] = []
    @Published var weeklyMeditation: Meditation?
    @Published var featuredMeditation: Meditation?
    @Published var selectedMeditation: Meditation? = Meditation(title: "Timed Meditation", description: "Timed unguided (no talking) meditation, with the option to turn on background noises such as rain. A bell will signal the end of your session.", belongsTo: "none", category: .unguided, img: Img.daisy3, type: .course, id: 0, duration: 0, reward: 0, url: "", instructor: "None",  imgURL: "", isNew: false)
    @Published var selectedCategory: Category? = .all
    @Published var isFavorited: Bool = false
    @Published  var isFavoritedLoaded: Bool = false
    @Published var playImage: Image = Img.seed
    @Published var recommendedMeds: [Meditation] = []
    @Published var challengeDate = ""
    var viewRouter: ViewRouter?
    var selectedPlant: Plant?
    //user needs to meditate at least 5 mins for plant
    var isOpenEnded = false
    var totalTime: Float = 0
    var bellPlayer: AVAudioPlayer?
    @Published var secondsRemaining: Float = 0
    @Published var secondsCounted: Float = 0
    //animation glitch with a picture so added this var to trigger it manually
    @Published var lastSeconds: Bool = false
    var timer: Timer?
    var forwardCounter = 0
    var shouldStreakUpdate = false
    
    @Published var roadMaplevel: Int = 1
    @Published var roadMapArr: [Int] = []
    @Published var featuredBreathwork = Breathwork.breathworks[0]
    @Published var selectedBreath: Breathwork?
    @Published var totalBreaths = 0

    private var validationCancellables: Set<AnyCancellable> = []
    let db = Firestore.firestore()

    func checkIfFavorited() {
        if let breath = selectedBreath {
            isFavorited = self.favoritedMeditations.contains(breath.id) ? true : false
        } else {
            isFavorited = self.favoritedMeditations.contains(self.selectedMeditation?.id ?? 1) ? true : false
        }
        isFavoritedLoaded = true
    }

    init() {
        timer = Timer()
        $selectedCategory
            .sink { [unowned self] value in
                if value == .all {
                    if middleToSearch != "" && !medSearch {
                        let category = QuickStartMenuItem.getName(str: middleToSearch)
                        // show timed meditations on discover search page
                        if category == .minutes3 || category == .minutes5 || category == .minutes10  || category == .minutes20 {
                            self.selectedMeditations =  Meditation.allMeditations.filter {
                                if $0.belongsTo == "Timed Meditation" {
                                    return true
                                } else {
                                    return $0.type != .lesson
                                }
                            }.reversed().unique()
                            for (idx, med) in self.selectedMeditations.enumerated() {
                                if med.belongsTo == "Timed Meditation" {
                                    selectedMeditations.remove(at: idx)
                                    selectedMeditations.insert(med, at: 0)
                                }
                            }
                        } else {
                            self.selectedMeditations =  Meditation.allMeditations.filter { $0.type != .lesson }.reversed().unique()
                        }
                    } else {
                        self.selectedMeditations =  Meditation.allMeditations.filter { $0.type != .lesson }.reversed().unique()
                    }
                } else {
                    self.selectedMeditations = Meditation.allMeditations.filter { med in
                        if value == .courses && (med.title == "Intro to Meditation" || med.title == "The Basics Course" ) {
                            return true
                        } else {
                            return med.category == value && med.type != .lesson
                        }
                    }
                }
            }
            .store(in: &validationCancellables)

        $selectedMeditation
            .sink { [unowned self] value in 
                if value?.type == .course {
                    selectedMeditations = Meditation.allMeditations.filter { med in med.belongsTo == value?.title }.sorted(by: { med1, med2 in med1.id < med2.id  }).unique()
                }
                secondsRemaining = value?.duration ?? 0
                totalTime = secondsRemaining
            }
            .store(in: &validationCancellables)
        getRecommendedMeds()
    }

    func getFeaturedMeditation()  {
        var filtedMeds = Meditation.allMeditations.filter { med in
            med.type != .lesson && med.id != 22 && med.id != 45 && med.id != 55 && med.id != 56}
        if !UserDefaults.standard.bool(forKey: "isPro") {
            filtedMeds = filtedMeds.filter { med in
                return !Meditation.lockedMeditations.contains(med.id)
            }
        }
        
        if Calendar.current.component( .hour, from:Date() ) < 11 { // morning
            featuredBreathwork = Breathwork.breathworks[0] // waking up
            filtedMeds = filtedMeds.filter { med in // day time meds only
                med.id != 27 && med.id != 54 && med.id != 39 && med.category != .sleep}
        } else if Calendar.current.component( .hour, from:Date() ) < 15 {
            filtedMeds = filtedMeds.filter { med in // day time meds only
                med.id != 27 && med.id != 54 && med.id != 39 && med.category != .sleep}
            featuredBreathwork = Breathwork.breathworks.first { $0.id == -2 }! //energize
        } else if Calendar.current.component( .hour, from:Date() ) < 20 {
            filtedMeds = filtedMeds.filter { med in
                med.id != 53 && med.id != 49 && med.id != 84
            }
            featuredBreathwork = Breathwork.breathworks.first { $0.id == -6 }! // calm
        } else{ // not morning
            filtedMeds = filtedMeds.filter { med in
                med.id != 53 && med.id != 49 && med.id != 84 && med.category == .sleep
            }
            featuredBreathwork = Breathwork.breathworks.first { $0.id == -3 } ?? Breathwork.breathworks[0] // calm
        }
        if UserDefaults.standard.bool(forKey: "intermediateCourse") {
            filtedMeds = filtedMeds.filter { med in
                med.id != 15 && med.id != 16 && med.id != 17 && med.id != 18 && med.id != 19 && med.id != 20 && med.id != 21 && med.id != 14
            }
        }
        
 

        if UserDefaults.standard.string(forKey: "experience") != Experience.often.title && UserDefaults.standard.string(forKey: "experience") != "Meditate often"  {
            if !UserDefaults.standard.bool(forKey: "beginnerCourse") {
                if UserDefaults.standard.integer(forKey: "dailyLaunchNumber") <= 6 {
                    featuredMeditation = Meditation.allMeditations.first(where: { med in med.id == 6 })
                } else {
                    if UserDefaults.standard.integer(forKey: "dailyLaunchNumber") <= 12 && !UserDefaults.standard.bool(forKey: "10days") {
                        featuredMeditation = Meditation.allMeditations.first(where: { med in med.id == 105 })
                    } else {
                        setFeaturedReason()
                    }
                }
            } else {
                if UserDefaults.standard.integer(forKey: "dailyLaunchNumber") <= 12 && !UserDefaults.standard.bool(forKey: "10days") {
                    featuredMeditation = Meditation.allMeditations.first(where: { med in med.id == 105 })
                } else {
                    if UserDefaults.standard.integer(forKey: "dailyLaunchNumber") <= 18 && !UserDefaults.standard.bool(forKey: "intermediateCourse") {
                        featuredMeditation = Meditation.allMeditations.first(where: { med in med.id == 14 })
                    } else {
                        setFeaturedReason()
                    }
                }
            }
        } else {
            if UserDefaults.standard.integer(forKey: "dailyLaunchNumber") <= 3 {
                featuredMeditation = Meditation.allMeditations.first(where: { med in
                    med.id == 2
                })
            } else {
                setFeaturedReason()
            }
        }
        saveFeaturedBreathwork()
        saveFeaturedMeditation()
    }

    private func setFeaturedReason() {
        var filtedMeds = Meditation.allMeditations.filter { med in
            med.type != .lesson && med.id != 22 && med.id != 45 && med.id != 55 && med.id != 56 && med.type != .weekly }
      
        if !UserDefaults.standard.bool(forKey: "isPro") {
            filtedMeds = filtedMeds.filter { med in
                return !Meditation.lockedMeditations.contains(med.id)
            }
        }
        
        if Calendar.current.component( .hour, from:Date() ) < 18 {
            filtedMeds = filtedMeds.filter { med in // day time meds only
                med.id != 27 && med.id != 54 && med.id != 39 && med.category != .sleep }
        }
        if Calendar.current.component(.hour, from: Date()) > 11 { // not morning
            filtedMeds = filtedMeds.filter { med in
                med.id != 53 && med.id != 49
            }
        }
        if UserDefaults.standard.bool(forKey: "intermediateCourse") {
            filtedMeds = filtedMeds.filter { med in
                med.id != 15 && med.id != 16 && med.id != 17 && med.id != 18 && med.id != 19 && med.id != 20 && med.id != 21 && med.id != 14
            }
        }
        filtedMeds = filtedMeds.filter { med in med.type != .lesson && med.isNew == false}
        if filtedMeds.isEmpty {
            filtedMeds = Meditation.allMeditations.filter {  med in med.type != .lesson && med.isNew == false                
            }
        }
        switch UserDefaults.standard.string(forKey: "reason") ?? "" {
        case "Sleep better":
            if Calendar.current.component( .hour, from:Date() ) >= 18 {
                filtedMeds = filtedMeds.filter { med in // day time meds only
                    med.id == 27 || med.id == 54 || med.id == 39 }
            }
            let randomInt = Int.random(in: 0..<filtedMeds.count)
            featuredMeditation = filtedMeds[randomInt]
        case "Get more focused":
            var focusedMeds = filtedMeds.filter { med in
                med.category == .focus
            }
            if focusedMeds.isEmpty {  focusedMeds = filtedMeds }
            let randomInt = Int.random(in: 0..<focusedMeds.count)
            featuredMeditation = focusedMeds[randomInt]
        case "Managing Stress & Anxiety":
            filtedMeds = filtedMeds.filter { med in
                med.category == .anxiety || med.category == .sadness
            }
            let randomInt = Int.random(in: 0..<filtedMeds.count)
            featuredMeditation = filtedMeds[randomInt]
        case "Just trying it out":
            filtedMeds = filtedMeds.filter { med in
                med.category == .beginners || med.category == .growth
            }
            let randomInt = Int.random(in: 0..<filtedMeds.count)
            featuredMeditation = filtedMeds[randomInt]
        default:
            let randomInt = Int.random(in: 0..<filtedMeds.count)
            featuredMeditation = filtedMeds[randomInt]
        }
        saveFeaturedMeditation()
    }
    private func saveFeaturedBreathwork() {
        UserDefaults(suiteName: K.widgetDefault)?.setValue(featuredBreathwork.id, forKey: "featuredBreathwork")
    }
    
    private func saveFeaturedMeditation() {
        UserDefaults(suiteName: K.widgetDefault)?.setValue(featuredMeditation?.id, forKey: "featuredMeditation")
    }

    private func getRecommendedMeds() {
        var filteredMeds = Meditation.allMeditations.filter { med in med.type != .lesson && med.id != 6 && med.id != 14 && med.id != 22 && med.id != 45 && med.type != .weekly }
        if Calendar.current.component( .hour, from:Date() ) < 16 {
            filteredMeds = filteredMeds.filter { med in // day time meds only
                med.id != 27 && med.id != 54 && med.id != 39 && med.id != 55 && med.id != 56 }
        }
        if Calendar.current.component(.hour, from: Date()) > 11 { // not morning
            filteredMeds = filteredMeds.filter { med in
                med.id != 53 && med.id != 49
            }
        }
        if UserDefaults.standard.bool(forKey: "intermediateCourse") || self.selectedMeditation?.id == 14 {
            filteredMeds = filteredMeds.filter { med in
                med.id != 15 && med.id != 16 && med.id != 17 && med.id != 18 && med.id != 19 && med.id != 20 && med.id != 21
            }
        }
        
        if UserDefaults.standard.string(forKey: "experience") != Experience.often.title  && UserDefaults.standard.string(forKey: "experience") != "Meditate often" {
            if !UserDefaults.standard.bool(forKey: "beginnerCourse") {
                filteredMeds = filteredMeds.filter { med in med.type != .lesson && med.id != 22 && med.type != .weekly}
            } else if !UserDefaults.standard.bool(forKey: "intermediateCourse") {
                filteredMeds = filteredMeds.filter { med in med.type != .lesson && med.id != 14 && med.id != 22 && med.type != .weekly }
            }
        }
        
        let randomInt = Int.random(in: 0..<filteredMeds.count)
        var randomInt2 =  Int.random(in: 0..<filteredMeds.count)
        while randomInt2 == randomInt {
            randomInt2 = Int.random(in: 0..<filteredMeds.count)
        }
        recommendedMeds = [filteredMeds[randomInt], filteredMeds[randomInt2]]
    }


    func updateSelf() {
        if let defaultFavorites = UserDefaults.standard.value(forKey: K.defaults.favorites) as? [Int] {
            self.favoritedMeditations =  defaultFavorites.reversed()
        }
        
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let favorites = document[K.defaults.favorites] as? [Int] {
                        self.favoritedMeditations = favorites.reversed()
                    }
                }
            }
        }
    }

    func favorite(id: Int) {
        let breathWork = Breathwork.breathworks.first { $0.id == id }
        if id < 0 {
            Amplitude.instance().logEvent("favorited_breathwork", withEventProperties: ["breathwork": breathWork?.title ?? ""])
        } else {
            Amplitude.instance().logEvent("favorited_meditation", withEventProperties: ["meditation": selectedMeditation?.returnEventName() ?? ""])
        }
        

        if let email = Auth.auth().currentUser?.email {
            //Read Data from firebase, for syncing
            if self.favoritedMeditations.contains(where: { favId in favId == id }) {
                self.favoritedMeditations.removeAll { med in
                    med == id
                }
            } else {
                self.favoritedMeditations.insert(id, at: 0)
            }
            self.checkIfFavorited()
            
            UserDefaults.standard.setValue(self.favoritedMeditations, forKey: K.defaults.favorites)
            self.db.collection(K.userPreferences).document(email).updateData([
                "favorited": self.favoritedMeditations,
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved meditations")
                }
            }
        } else {
            if var favorites = UserDefaults.standard.value(forKey: K.defaults.favorites) as? [Int] {
                if favorites.contains(where: { $0 == id }) {
                    favorites.removeAll { fbId in return fbId == id }
                    self.favoritedMeditations.removeAll { med in  med == id }
                } else {
                    self.favoritedMeditations.insert(id, at: 0)
                    favorites.insert(id, at: 0)
                }
                UserDefaults.standard.setValue(favorites, forKey: K.defaults.favorites)
            } else {
                self.favoritedMeditations.insert(id, at: 0)
                UserDefaults.standard.setValue(self.favoritedMeditations, forKey: K.defaults.favorites)
            }
            self.checkIfFavorited()
        }
    }

    func getReward() -> Int {
        var reward = 0
        if totalBreaths > 0 {
            var totalSeconds = 0
            if let duration = self.selectedBreath?.duration {
                totalSeconds = totalBreaths * duration
            }
            switch totalSeconds {
            case 10...23: reward = 5
            case 24...60: reward = 10
            case 61...120: reward = 20
            case 121...180: reward = 25
            case 181...240: reward = 30
            case 241...301: reward = 35
            default: reward = 0
            }
            if UserDefaults.standard.bool(forKey: "isPro") {
                reward = reward * 2
            }
            shouldStreakUpdate = true
            return reward
        }
        
        let duration = selectedMeditation?.duration ?? 0
    

        
        if ((forwardCounter > 2 && duration <= 120) || (forwardCounter > 6) || (selectedMeditation?.id == 22 && forwardCounter >= 1)) {
            reward = 0
            forwardCounter = 0
            shouldStreakUpdate = false
        } else if selectedMeditation?.duration == -1 {
            switch secondsRemaining {
            case 0...59:
                reward = 0
            case 60...299: reward = 10
            case 300...599: reward = 50
            case 600...899: reward = 100
            case 900...1199: reward = 120
            case 1200...1499: reward = 150
            case 1500...1799: reward = 180
            default: reward = 200
            }
            
            if secondsRemaining < 60 {
                shouldStreakUpdate = false
            } else {
                shouldStreakUpdate = true
            }
        } else {
            reward = selectedMeditation?.reward ?? 0
            shouldStreakUpdate = true
        }
        if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "done" && !UserDefaults.standard.bool(forKey: "review") {
            shouldStreakUpdate = true
        }
        return reward
    }
    
    // Roadmap of meditations based on experience chosen during onboarding
    func getUserMap() {
        let beg1 = [6, 107, 107, 82, 82]
        let beg2 = [105, 80, 80, 80, 104, 108, 92]
        let beg3 = [90, 91, 93, 109, 4, 4, 4]
        let beg4 = [5, 5, 5, 5, 5, 5, 5, 5, 5]
        let beg5 = [28, 28, 28, 28, 28, 28, 28, 28, 28]
        let beg6 = [29, 29, 29, 29, 29, 29, 30, 30]
    
        let exp1 = [24, 105, 90, 90, 108]
        let exp2 = [92, 5, 5, 5, 5, 5, 5, 5, 5]
        let exp3 = [28, 28, 28, 28, 28, 28, 28, 28, 28]
        let exp4 = [58, 58, 58, 58, 58,58,  58,  58,  58, 58]
        let exp5 = [29, 29, 29, 29, 29, 29, 29, 29, 29]
        let exp6 = [30, 30, 30, 30, 31, 31, 32]
        
        let begArr = [beg1, beg2, beg3, beg4, beg5, beg6]
        let expArr = [exp1, exp2, exp3, exp4, exp5, exp6]
        setRoadMap(begArr: begArr, expArr: expArr)
    }
    func setRoadMap(begArr:[[Int]], expArr:[[Int]]){
        let selected = UserDefaults.standard.string(forKey: "experience") ?? ""
        let userCoinCollectedLevel = UserDefaults.standard.value(forKey: K.defaults.userCoinCollectedLevel) as? Int ?? 0
        roadMapArr = begArr[0]
        for i in 0...userCoinCollectedLevel {
            switch selected {
            case "Meditate often":
                if i+1 < expArr.count, expArr[i].allSatisfy(completedMeditation.contains) && userCoinCollectedLevel != i {
                    roadMaplevel = i + 2
                    roadMapArr = expArr[i+1]
                } else {
                    roadMaplevel = i + 1
                    roadMapArr = expArr[i]
                }
            case Experience.often.title:
                if i+1 < expArr.count, expArr[i].allSatisfy(completedMeditation.contains) && userCoinCollectedLevel != i {
                    roadMaplevel = i + 2
                    roadMapArr = expArr[i+1]
                } else {
                    roadMaplevel = i + 1
                    roadMapArr = expArr[i]
                }
            default:
                if roadMaplevel == 6 || userCoinCollectedLevel == 6 {
                    return
                } else {
                    if i+1 < begArr.count, begArr[i].allSatisfy(completedMeditation.contains) && userCoinCollectedLevel != i  {
                        roadMaplevel = i + 2
                        roadMapArr = begArr[i+1]
                    } else {
                        roadMaplevel = i + 1
                        roadMapArr = begArr[i]
                    }
                }
            }
        }
    }
    
    var completedMeditation: [Int] {
        let completedMeditations = UserDefaults.standard.array(forKey: K.defaults.completedMeditations) as? [String]  ?? []
        return completedMeditations.compactMap { Int($0) }
    }
}


extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
