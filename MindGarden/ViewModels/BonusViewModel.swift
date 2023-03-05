//
//  BonusViewModel.swift
//  MindGarden
//  Created by Dante Kim on 9/2/21.
//

import Swift
import Combine
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import WidgetKit
import Storyly
import Amplitude

var updatedStreak = false
var showWidgetTip = false
class BonusViewModel: ObservableObject {
    @Published var lastLogin: String = ""
    @Published var dailyBonus: String = ""
    @Published var streak: String? //Optional("1+08-25-2021 22:16:18") loco
    @Published var sevenDay: Int = 0
    @Published var thirtyDay: Int = 0
    @Published var sevenDayProgress: Double = 0.1
    @Published var thirtyDayProgress: Double = 0.08
    @Published var longestStreak: Int = 0
    @Published var totalBonuses: Int = 0
    @Published var dailyInterval: TimeInterval = 0
    @Published var progressiveTimer: Timer? = Timer()
    @Published var progressiveInterval: String = ""
    @Published var fiftyOffTimer: Timer? = Timer()
    @Published var fiftyOffInterval: String = ""
    @Published var lastStreakDate = ""
    var userModel: UserViewModel
    var gardenModel: GardenViewModel
    @Published var streakNumber = 0
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        return formatter
    }()
    let db = Firestore.firestore()

    init(userModel: UserViewModel, gardenModel: GardenViewModel) {
        self.userModel = userModel
        self.gardenModel = gardenModel
    }

    func createDailyCountdown() {
        if dailyBonus == "" { // first daily bonus ever
            dailyInterval = 86400
        } else {
            if let date = formatter.date(from: dailyBonus) {
                dailyInterval = date - Date()
            }
        }
    }
    
    private func createFiftyCountdown() {
        self.fiftyOffTimer?.invalidate()
        self.fiftyOffTimer = nil
        fiftyOffInterval = ""
        var interval = TimeInterval()

        if let fifty = UserDefaults.standard.string(forKey: "fiftyTimer") {
            interval = (formatter.date(from: fifty) ?? Date())  - Date()
        } else {
            interval = 7200
        }
        

        fiftyOffInterval = interval.stringFromTimeInterval()
        self.fiftyOffTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            interval -= 1
            self?.fiftyOffInterval = interval.stringFromTimeInterval()
            if interval <= 0 {
                timer.invalidate()
            }
        }
    }
    
    private func createProgressiveCountdown() {
        self.progressiveTimer?.invalidate()
        self.progressiveTimer = nil
        progressiveInterval = ""
        var interval = TimeInterval()

        if let lastTutorialDate = UserDefaults.standard.string(forKey: "ltd") {
            interval = (formatter.date(from: lastTutorialDate) ?? Date()) - Date()
        } else {
            interval = 43200
        }
        

        progressiveInterval = interval.stringFromTimeInterval()
        self.progressiveTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            interval -= 1
            self?.progressiveInterval = interval.stringFromTimeInterval()
            if interval <= 0 {
                timer.invalidate()
                self?.progressiveDisclosure(lastStreakDate: self?.formatter.string(from: Date()) ?? "")
            }
        }
    }

    func saveDaily(plusCoins: Int) {
        userModel.coins += plusCoins
        dailyBonus = formatter.string(from: Calendar.current.date(byAdding: .hour, value: 24, to: Date()) ?? Date())
        createDailyCountdown()
        UserDefaults.standard.setValue(self.dailyBonus, forKey: K.defaults.dailyBonus)
        UserDefaults.standard.setValue(userModel.coins, forKey: K.defaults.coins)
        if let email = Auth.auth().currentUser?.email {
                self.db.collection(K.userPreferences).document(email).updateData([
                    //TODO turn this into userdefault
                    K.defaults.dailyBonus: self.dailyBonus,
                    K.defaults.coins: userModel.coins
                ]) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        print("Succesfully saved daily", self.dailyBonus)
                    }
                }
        } else {
            UserDefaults.standard.setValue(userModel.coins, forKey: K.defaults.coins)
            UserDefaults.standard.setValue(dailyBonus, forKey: K.defaults.dailyBonus)
        }
    }

    func saveSeven() {
        userModel.coins += 300
        sevenDay += 1
        UserDefaults.standard.setValue(sevenDay, forKey: K.defaults.seven)
        UserDefaults.standard.setValue(userModel.coins, forKey: K.defaults.coins)
        if let email = Auth.auth().currentUser?.email {
            self.db.collection(K.userPreferences).document(email).updateData([
                K.defaults.seven: sevenDay,
                K.defaults.coins: userModel.coins
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved seven")
                    self.calculateProgress()
                }
            }
        } else {
            UserDefaults.standard.setValue(userModel.coins, forKey: K.defaults.coins)
            UserDefaults.standard.setValue(dailyBonus, forKey: K.defaults.dailyBonus)
            self.calculateProgress()
        }
    }
    
    func tripleBonus() {
        userModel.coins += 500
        UserDefaults.standard.setValue(userModel.coins, forKey: K.defaults.coins)
        if let email = Auth.auth().currentUser?.email {
            self.db.collection(K.userPreferences).document(email).updateData([
                K.defaults.coins: userModel.coins
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved seven")
                    self.calculateProgress()
                }
            }
        } else {
            UserDefaults.standard.setValue(userModel.coins, forKey: K.defaults.coins)
            UserDefaults.standard.setValue(dailyBonus, forKey: K.defaults.dailyBonus)
            self.calculateProgress()
        }
    }

    func saveThirty() {
        userModel.coins += 1000
        thirtyDay += 1
        UserDefaults.standard.setValue(thirtyDay, forKey: K.defaults.thirty)
        UserDefaults.standard.setValue(userModel.coins, forKey: K.defaults.coins)
        if let email = Auth.auth().currentUser?.email {
            self.db.collection(K.userPreferences).document(email).updateData([
                K.defaults.thirty: thirtyDay,
                K.defaults.coins: userModel.coins
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved thirty")
                    self.calculateProgress()
                }
            }
        } else {
            UserDefaults.standard.setValue(userModel.coins, forKey: K.defaults.coins)
            UserDefaults.standard.setValue(dailyBonus, forKey: K.defaults.dailyBonus)
            self.calculateProgress()
        }
    }

    func updateBonus() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"

        if let lastTutorialDate = UserDefaults.standard.string(forKey: "ltd")  {
            if UserDefaults.standard.bool(forKey: "newUser") {
                progressiveDisclosure(lastStreakDate: lastTutorialDate)
            }
            progressiveDisclosure(lastStreakDate: formatter.string(from: Calendar.current.date(byAdding: .hour, value: 12, to: Date()) ?? Date()))
        } else if UserDefaults.standard.bool(forKey: "newUser") {
            let dte =  formatter.string(from: Calendar.current.date(byAdding: .hour, value: 12, to: Date()) ?? Date())
            UserDefaults.standard.setValue(dte, forKey: "ltd")
            progressiveDisclosure(lastStreakDate: dte)
        } else {
            UserDefaults.standard.setValue(true, forKey: "day1")
            UserDefaults.standard.setValue(true, forKey: "day2")
            UserDefaults.standard.setValue(true, forKey: "day3")
            UserDefaults.standard.setValue(1, forKey: "day")
        }


        if let email = Auth.auth().currentUser?.email {
            let docRef = db.collection(K.userPreferences).document(email)
            docRef.getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    self.totalBonuses = 0
                    if let streak = document["streak"] as? String {
                        self.streak = streak
                        if let plus = self.streak?.firstIndex(of: "+"), let streak = self.streak  {
                            self.streakNumber = Int(streak[..<plus]) ?? 0
                            let plusOffset = streak.index(plus, offsetBy: 1)
                            self.lastStreakDate = String(streak[plusOffset...])
                            self.updateLaunchNumber()
                        }
                    }
                    
                    if let seven = document[K.defaults.seven] as? Int {
                        self.sevenDay = seven
                    }
                    
                    if let thirty = document[K.defaults.thirty] as? Int {
                        self.thirtyDay = thirty
                    }
                    
                    if let dailyBonus = document[K.defaults.dailyBonus] as? String {
                        self.dailyBonus = dailyBonus
                    }
                    
                    if let referredStack = document["referredStack"] as? String {
                        self.userModel.referredStack = referredStack
                        self.userModel.checkIfPro()
                    }
                    
                    self.calculateProgress()
                    if self.dailyBonus != "" && (self.formatter.date(from: self.dailyBonus) ?? Date()) - Date() > 0 {
                        self.createDailyCountdown()
                    }
                }
            }
        } else {
            self.totalBonuses = 0
            if let lSD = UserDefaults.standard.value(forKey: K.defaults.lastStreakDate) as? String {
                self.lastStreakDate = lSD
            }
            if let streak = UserDefaults.standard.value(forKey: "streak") as? String {
                self.streak = streak
                if let plus = self.streak?.firstIndex(of: "+"), let streak = self.streak  {
                    self.streakNumber = Int(streak[..<plus]) ?? 0
                    let plusOffset = streak.index(plus, offsetBy: 1)
                    self.lastStreakDate = String(streak[plusOffset...])
                }
            } else {
                lastStreakDate = formatter.string(from: Date())
                streakNumber = 0
            }
            if let seven = UserDefaults.standard.value(forKey: K.defaults.seven) as? Int {
                self.sevenDay = seven
            }
            if let thirty = UserDefaults.standard.value(forKey: K.defaults.thirty) as? Int {
                self.thirtyDay = thirty
            }
            if let dailyBonus = UserDefaults.standard.value(forKey: K.defaults.dailyBonus) as? String {
                self.dailyBonus = dailyBonus
            }
            self.calculateProgress()
            if self.dailyBonus != "" && (self.formatter.date(from: self.dailyBonus) ?? Date()) - Date() > 0 {
                self.createDailyCountdown()
            }
            self.updateLaunchNumber()
        }

    }
    
    private func updateTips(tip: String) {
        var segments = storySegments
        segments = storySegments.filter { str in return !str.lowercased().contains("tip")  }
        
        segments.insert(tip)
        UserDefaults.standard.setValue(Array(segments), forKey: "storySegments")
        storySegments = segments
        StorylyManager.refresh()
    }
    
    private func updateLaunchNumber() {
        var launchNum = UserDefaults.standard.integer(forKey: "dailyLaunchNumber")

        if launchNum == 7 {
            Analytics.shared.log(event: .seventh_time_coming_back)
            if UserDefaults.standard.bool(forKey: "referTip") {
                UserDefaults.standard.setValue(true, forKey: "referTip")
                updateTips(tip: "Tip Referrals")
            }
        } else if launchNum >= 2 && !UserDefaults.standard.bool(forKey: "remindersOn") {
            UserDefaults.standard.setValue(true, forKey: "remindersOn")
            updateTips(tip: "Tip Reminders")
        } else if showWidgetTip && !UserDefaults.standard.bool(forKey: "widgetTip") {
            UserDefaults.standard.setValue(true, forKey: "widgetTip")
            updateTips(tip: "Tip Widget")
        } else if UserDefaults.standard.bool(forKey: "day4") && !UserDefaults.standard.bool(forKey: "plusCoins") {
            UserDefaults.standard.setValue(true, forKey: "plusCoins")
            updateTips(tip: "Tip Potion Shop")
        }
        
        if (Date() - (formatter.date(from: lastStreakDate) ?? Date()) >= 86400 && Date() - (formatter.date(from: self.lastStreakDate) ?? Date()) <= 172800) {
            launchNum += 1
            
        } else if  Date() - (formatter.date(from: self.lastStreakDate) ?? Date()) > 172800 {
            launchNum += 1
        }
        UserDefaults.standard.setValue(launchNum, forKey: "dailyLaunchNumber")
        let identify = AMPIdentify()
            .set("dailyLaunchNumber", value: NSNumber(value: launchNum))
        Amplitude.instance().identify(identify ?? AMPIdentify())
    }
    
    
    func updateStreak() {
        if let email = Auth.auth().currentUser?.email {
            lastStreakDate = self.calculateStreak(lastStreakDate: lastStreakDate)
            if self.streakNumber == 7 {
                if !self.userModel.ownedPlants.contains(where: { p in p.title == "Red Mushroom" }) {
                    self.userModel.willBuyPlant = Plant.badgePlants.first(where: { plant in plant.title == "Red Mushroom" })
                    self.userModel.buyPlant(unlockedStrawberry: true)
                    userModel.triggerAnimation = true
                }
            } else if self.streakNumber == 30 {
                if !self.userModel.ownedPlants.contains(where: { p in p.title == "Cherry Blossoms" }) {
                    self.userModel.willBuyPlant = Plant.badgePlants.first(where: { plant in plant.title == "Cherry Blossoms" })
                    self.userModel.buyPlant(unlockedStrawberry: true)
                    userModel.triggerAnimation = true
                }
            }
            self.streak = String(self.streakNumber) + "+" + lastStreakDate
            self.db.collection(K.userPreferences).document(email).updateData([
                "streak": String(self.streakNumber) + "+" + lastStreakDate,
                "longestStreak": UserDefaults.standard.integer(forKey: "longestStreak")
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved streak")
                }
            }
        } else {
            lastStreakDate = self.calculateStreak(lastStreakDate: lastStreakDate)
            UserDefaults.standard.setValue((String(self.streakNumber) + "+" + lastStreakDate), forKey: "streak")
        }
    }

    private func calculateStreak(lastStreakDate: String = "") -> String {
        var lastStreakDate = lastStreakDate
        
        if (!SceneDelegate.profileModel.isLoggedIn)  {
            streak = UserDefaults.standard.value(forKey: "streak") as? String
        }
        
        if let plus = self.streak?.firstIndex(of: "+"), let streak = streak {
            self.streakNumber = Int(streak[..<plus]) ?? 0
            let plusOffset = streak.index(plus, offsetBy: 1)
            lastStreakDate = String(streak[plusOffset...])
            
            // for new users only
            let streakDate = (formatter.date(from: lastStreakDate) ?? Date()).setTime(hour: 00, min: 00, sec: 00)
            let currentDate = Date().setTime(hour: 00, min: 00, sec: 00) ?? Date()
            let interval = currentDate.interval(ofComponent: .day, fromDate: streakDate ?? Date())
            
            if (interval >= 1 && interval < 2) {  // update streak number and date
                updatedStreak = true
                self.streakNumber += 1
                updateLongest()
            } else if interval >= 2 { //broke streak
                updatedStreak = true
                if userModel.streakFreeze >= interval - 1 {
                    freezeStreak(interval: interval)
                    updateLongest()
                } else {
                    updatedStreak = true
                    self.streakNumber = 1
                    if let email = Auth.auth().currentUser?.email {
                        self.db.collection(K.userPreferences).document(email).updateData([
                            "sevenDay": 0,
                            "thirtyDay": 0,
                            "seven": 0,
                            "thirty": 0,
                        ]) { (error) in
                            if let e = error {
                                print("There was a issue saving data to firestore \(e) ")
                            } else {
                                print("Succesfully saved seven & thirty progress")
                            }
                        }
                    } else {
                        UserDefaults.standard.setValue(0, forKey: "sevenDay")
                        UserDefaults.standard.setValue(0, forKey: "thirtyDay")
                    }
                }
            } else {
                if streakNumber == 0 {
                        updatedStreak = true
                        self.streakNumber = 1
                        updateLongest()
                }
            }
            lastStreakDate = formatter.string(from: Date())
        } else {
            lastStreakDate  = formatter.string(from: Date())
            updatedStreak = true
            self.streakNumber = 1
            updateLongest()
        }
        
        UserDefaults(suiteName: K.widgetDefault)?.setValue(streakNumber, forKey: "streakNumber")
        UserDefaults(suiteName: K.widgetDefault)?.setValue(UserDefaults.standard.bool(forKey:"isPro"), forKey: "isPro")
        WidgetCenter.shared.reloadAllTimelines()

        return lastStreakDate
    }
    
    private func recSaveFreeze(day: Int, dates: [Date], session: [String: String]) {
        if day == dates.count {
            return
        } else {
            gardenModel.save(key: "sessions", saveValue: session, date: dates[day], freeze: true, coins: userModel.coins) { [self] in
                let day = day + 1
                recSaveFreeze(day: day, dates: dates, session: session)
            }
        }
     
    }
    
    private func freezeStreak(interval: Int) {
        let datesBetweenArray = Date.dates(from: formatter.date(from: lastStreakDate) ?? Date(), to: Date())
        var session = [String: String]()
        session[K.defaults.plantSelected] = "Ice Flower"
        session[K.defaults.meditationId] = "0"
        session[K.defaults.duration] = "0"
        recSaveFreeze(day: 1, dates: datesBetweenArray, session: session)
        
        userModel.streakFreeze -= datesBetweenArray.count
        userModel.saveIAP()
        updatedStreak = true
        self.streakNumber += 1
    }
    
    private func updateLongest() {
        if let longestStreak =  UserDefaults.standard.value(forKey: "longestStreak") as? Int {
            if longestStreak < streakNumber {
                UserDefaults.standard.setValue(streakNumber, forKey: "longestStreak")
            }
            
            UserDefaults.standard.setValue(true, forKey: "updatedStreak")
        } else {
            UserDefaults.standard.setValue(1, forKey: "longestStreak")
        }
    }
    
    private func progressiveDisclosure(lastStreakDate: String) {
//        if formatter.date(from: lastStreakDate)! - Date() <= 0 {
//            let dte =  formatter.string(from: Calendar.current.date(byAdding: .hour, value: 12, to: Date())!)
//            UserDefaults.standard.setValue(dte,forKey: "ltd")
//            if UserDefaults.standard.bool(forKey: "day1") {
//                if UserDefaults.standard.bool(forKey: "day2") {
//                    if UserDefaults.standard.bool(forKey: "day3") {
//                        if UserDefaults.standard.bool(forKey: "day4") {
//
//                        } else { //fourth day back unlock plusCoins
//
//                            UserDefaults.standard.setValue(true, forKey: "day4")
//                            UserDefaults.standard.setValue(4, forKey: "day")
//                        }
//                    } else { // third day back
//                        showWidgetTip = true
//                        UserDefaults.standard.setValue(true, forKey: "day3")
//                        UserDefaults.standard.setValue(3, forKey: "day")
//                    }
//                } else { // second day back
//                    NotificationHelper.addUnlockedFeature(title: "⚙️ Widget has been unlocked", body: "Add it to your home screen!")
//                    UserDefaults.standard.setValue(true, forKey: "day2")
//                    UserDefaults.standard.setValue(2, forKey: "day")
//                }
//            } else { // first day back
//                NotificationHelper.addUnlockedFeature(title: "🛍 Your Store Page has been unlocked!", body: "Start collecting, and make your MindGarden beautiful!")
//                UserDefaults.standard.setValue(true, forKey: "day1")
//                UserDefaults.standard.setValue(1, forKey: "day")
//            }
//        }
        createProgressiveCountdown()
    }

    private func calculateProgress() {
        totalBonuses = 0
        if self.dailyBonus != "" {
            if (Date() - (formatter.date(from: self.dailyBonus) ?? Date()) >= 0) {
                self.totalBonuses += 1
                NotificationCenter.default.post(name: Notification.Name("runCounter"), object: nil)
            }
        } else {
            self.totalBonuses += 1
            NotificationCenter.default.post(name: Notification.Name("runCounter"), object: nil)
        }


        if self.sevenDay > 0 {
            let leftOver = self.streakNumber - (self.sevenDay * 7)
            self.sevenDayProgress = Double(leftOver)/7.0
        } else {
            self.sevenDayProgress = Double(self.streakNumber)/7.0
        }
        if self.sevenDayProgress <= 0.1 {
            self.sevenDayProgress = 0.1
        }

        if self.thirtyDay > 0 {
            let leftOver = self.streakNumber - (self.thirtyDay * 30)
            self.thirtyDayProgress = Double(leftOver)/30.0
        } else {
            self.thirtyDayProgress = Double(self.streakNumber)/30.0
        }
        if self.thirtyDayProgress <= 0.08 {
            self.thirtyDayProgress = 0.08
        }

        if self.sevenDayProgress >= 1.0 {
            self.totalBonuses += 1
            NotificationCenter.default.post(name: Notification.Name("runCounter"), object: nil)
        }
        if self.thirtyDayProgress >= 1.0 {
            self.totalBonuses += 1
            NotificationCenter.default.post(name: Notification.Name("runCounter"), object: nil)
        }
    }
}
