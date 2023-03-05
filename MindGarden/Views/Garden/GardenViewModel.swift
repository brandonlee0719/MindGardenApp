//
//  GardenViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 8/6/21.
//

import Combine
import Firebase
import FirebaseFirestore
import Foundation
import WidgetKit
import Amplitude
import SwiftUI

struct StreakItem : Identifiable {
    var id = UUID()
    var title: String
    var streak: Bool
    var gratitude: String = ""
    var question: String = ""
}

struct DailyMoodItem : Identifiable {
    var id = UUID()
    var title: String
    var dailyMood: Image
}

class GardenViewModel: ObservableObject {
    @Published var grid = [String: [String:[String:[String:Any]]]]()
    @Published var isYear: Bool = false
    @Published var selectedYear: Int = 2021
    @Published var selectedMonth: Int = 1
    @Published var monthTiles = [Int: [Int: (Plant?, Mood?)]]()
    @Published var totalMoods = [Mood:Int]()
    @Published var totalMins = 0
    @Published var totalSessions = 0
    @Published var favoritePlants = [String: Int]()
    @Published var recentMeditations: [Int] = []
    @Published var gratitudes = 0
    @Published var lastFive =  [(String, Plant?,Mood?)]()
    @Published var entireHistory = [([Int], [[String: String]])]()
    @Published var monthlyBreaths = 0
    @Published var monthlyMeds = 0
    @Published var numBreaths = 0
    @Published var numMeds = 0
    @Published var numMoods = 0
    @Published var numGrads = 0
    @Published var mindfulDays = 0
    var allTimeMinutes = 0
    var allTimeSessions = 0
    var placeHolders = 0
    let db = Firestore.firestore()
        
    // StartDayView (needs to update on scenewillenterforeground)
    @Published var streakList:[StreakItem] = [StreakItem(title: "S", streak: false),
                                          StreakItem(title: "M", streak: false),
                                          StreakItem(title: "T", streak: false),
                                          StreakItem(title: "W", streak: false),
                                          StreakItem(title: "T", streak: false),
                                          StreakItem(title: "F", streak: false),
                                          StreakItem(title: "S", streak: false)]
    
    @Published var dailyMoodList:[DailyMoodItem] = [DailyMoodItem(title: "S", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "M", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "T", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "W", dailyMood: Img.emptyMood),
                                                DailyMoodItem(title: "T", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "F", dailyMood: Img.emptyMood),
                                             DailyMoodItem(title: "S", dailyMood: Img.emptyMood)]
    @Published var isGratitudeDone = false
    @Published var isMeditationDone = false
    @Published var isWeekStreakDone = false
    @Published var isMoodDone = false

    init() {
        selectedMonth = (Int(Date().get(.month)) ?? 1)
        selectedYear = Int(Date().get(.year)) ?? 2021
    }
    
    func getRecentMeditations() {
        entireHistory = []
        numMoods = 0
        numGrads = 0
        numMeds = 0
        numBreaths = 0
        mindfulDays = 0
        var yearSortDict = [String: [[[String:String]]]]()
        
        for (key,value) in grid {
            let months = value.keys.sorted { Int($0) ?? 1 > Int($1) ?? 1 }
            let yearIds = [[[String:String]]]()
            for mo in months  {
                if let singleDay = value[String(mo)]{
                    let days = singleDay.keys.sorted { Int($0) ?? 1 > Int($1) ?? 1 }
                    for day in days { // we can improve performance by stopping when we get the last two different sessions
                        mindfulDays += 1
                        var dataArr = [[String: String]]()
                        if let sessions = singleDay[String(day)]?["sessions"] as? [[String: String]] {
                            for sess in sessions { // sort by timestamp here
                                if let id = Int(sess["meditationId"] ?? "0") {
                                    if id >= 0 {
                                        numMeds += 1
                                    } else {
                                        numBreaths += 1
                                    }
                                }
                                dataArr.append(sess)
                            }
                        }
                            if let moods = singleDay[String(day)]?["moods"] as? [[String: String]] {
                                for mood in moods {
                                    dataArr.append(mood)
                                    numMoods += 1
                                }
                            } else if let moods = singleDay[String(day)]?["moods"] as? [String] {
                                for mood in moods {
                                    var moodObj = [String: String]()
                                    moodObj["mood"] = mood
                                    moodObj["elaboration"] = mood
                                    moodObj["timeStamp"] = "12:00 AM"
                                    dataArr.append(moodObj)
                                    numMoods += 1
                                }
                            }
 
                            if let journals = singleDay[String(day)]?["journals"] as? [[String: String]] {
                                for journal in journals {
                                    dataArr.append(journal)
                                    numGrads += 1
                                }
                            } else if let journals = singleDay[String(day)]?["gratitudes"] as? [String] {
                                for journal in journals {
                                    var journalObj = [String: String]()
                                    journalObj["question"] = "None"
                                    journalObj["gratitude"] = journal
                                    journalObj["timeStamp"] = "12:00 AM"
                                    dataArr.append(journalObj)
                                    numGrads += 1
                                }
                            }
                        
                        
                        entireHistory.append(([Int(day) ?? 1, Int(mo) ?? 1, Int(key) ?? 2022], dataArr)) // append day data and attach date
                    }
                }
            }
            yearSortDict[key] = yearIds
            // TODO get old timestamp sorting code from github
//            UserDefaults.standard.setValue(ids, forKey: "recent")
            // TODO instead of timestamp, save entire date.
            let identify = AMPIdentify()
                .set("breathwork_sessions", value: NSNumber(value: numBreaths))
            identify?
                .set("meditation_sessions", value: NSNumber(value: numMeds))
            UserDefaults.standard.setValue((numBreaths + numMeds), forKey: "numSessions")
            identify?
                .set("journal_sessions", value: NSNumber(value: numGrads))
            UserDefaults.standard.setValue(numGrads, forKey: "numGrads")
            identify?
                .set("mood_sessions", value: NSNumber(value: numMoods))
            Amplitude.instance().identify(identify ?? AMPIdentify())

        }
        
        entireHistory = entireHistory.sorted { (lhs, rhs) in
            let date1 = lhs.0
            let date2 = rhs.0
            if  date1[2] == date2[2] { //same year
                if date1[1] == date2[1] { // same month
                    return date1[0] > date2[0]
                }
                return date1[1] > date2[1]
            }
            return date1[2] > date2[2]
        }
    }
    func updateStartDay() {
        let weekDays = getAllDaysOfTheCurrentWeek()
        getAllGratitude(weekDays:weekDays)
        
        if let moods = grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?["moods"]  as? [[String: String]] {
            if let mood = moods[moods.count - 1]["mood"], !mood.isEmpty {
                isMoodDone = true
                for i in 0..<weekDays.count {
                    let day = weekDays[i]
                    if let moods = grid[day.get(.year)]?[day.get(.month)]?[day.get(.day)]?["moods"]  as? [[String: String]] {
                        let mood = Mood.getMood(str: moods[moods.count - 1]["mood"] ?? "okay")
                        dailyMoodList[i].dailyMood = Mood.getMoodImage(mood: mood)
                    }
                }
            }
        }
        
        if let gratitudes = grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?["journals"]  as? [[String: String]] {
            if let gratitude = gratitudes[gratitudes.count-1]["gratitude"], !gratitude.isEmpty  {
                isGratitudeDone = true
            }
        }
        
        if let meditations = grid[Date().get(.year)]?[Date().get(.month)]?[Date().get(.day)]?["sessions"]  as? [[String: String]] {
            if let meditation = meditations[meditations.count-1]["meditationId"], !meditation.isEmpty  {
                isMeditationDone = true
            }
        }
        
    }
    func getAllDaysOfTheCurrentWeek() -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 1
        let today = calendar.startOfDay(for: Date())
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        return week
    }
    
    
    func getAllGratitude(weekDays:[Date]) {
        for i in 0..<weekDays.count {
            let day = weekDays[i]
            if let gratitudes = grid[day.get(.year)]?[day.get(.month)]?[day.get(.day)]?[K.defaults.journals]  as? [[String: String]] {
                if let gratitude = gratitudes[gratitudes.count-1]["gratitude"] {
                    streakList[i].gratitude = gratitude
                    if gratitude.count > 0 {
                        streakList[i].streak = true
                    }
                }
                if let question = gratitudes[gratitudes.count-1]["question"] {
                    streakList[i].question = question
                }
            }
        }
        isWeekStreakDone = streakList.filter { $0.streak }.count == 7
    }

    func populateMonth() {
        totalMins = 0
        totalSessions = 0
        placeHolders = 0
        gratitudes = 0
        monthTiles = [Int: [Int: (Plant?, Mood?)]]()
        totalMoods = [Mood:Int]()
        favoritePlants = [String: Int]()
        gratitudes = 0
        monthlyMeds = 0
        monthlyBreaths = 0 
        var startsOnSunday = false
        let strMonth = String(selectedMonth)
        let numOfDays = Date().getNumberOfDays(month: strMonth, year: String(selectedYear))
        let intWeek = Date().weekDayToInt(weekDay: Date.dayOfWeek(day: "1", month: strMonth, year: String(selectedYear)))

        if intWeek != 0 {
            placeHolders = intWeek
        } else { //it starts on a sunday
            startsOnSunday = true
        }

        var weekNumber = 0
        for day in 1...numOfDays {
            let weekday = Date.dayOfWeek(day: String(day), month: strMonth, year: String(selectedYear))
            let weekInt = Date().weekDayToInt(weekDay: weekday)
            if weekInt == 0 && !startsOnSunday {
                weekNumber += 1
            } else if startsOnSunday {
                startsOnSunday = false
            }

            var plant: Plant? = nil
            var mood: Mood? = nil
            if let sessions = grid[String(selectedYear)]?[strMonth]?[String(day)]?[K.defaults.sessions] as? [[String: String]] {
                let fbPlant = sessions[sessions.count - 1][K.defaults.plantSelected]
                plant = Plant.allPlants.first(where: { $0.title == fbPlant })
                for session in sessions {
                    totalMins += (Double(session[K.defaults.duration] ?? "0.0") ?? 0).toInt() ?? 0
                    let plant = session[K.defaults.plantSelected] ?? ""
                    if var count = favoritePlants[plant] {
                        count += 1
                        favoritePlants[plant] = count
                    } else {
                        favoritePlants[plant] = 1
                    }
                    if let id = Int(session["meditationId"] ?? "0") {
                        if id >= 0 {
                            monthlyMeds += 1
                        } else {
                            monthlyBreaths += 1
                        }
                    }
                }
                totalSessions += sessions.count
            }
    

            if let moods = grid[String(selectedYear)]?[strMonth]?[String(day)]?[K.defaults.moods] as? [[String: String]] {
                mood = Mood.getMood(str: moods[moods.count - 1]["mood"] ?? "bad")
                for forMood in moods {
                    let singleMood = Mood.getMood(str: forMood["mood"] ?? "bad")
                    if var count = totalMoods[singleMood] {
                        count += 1
                        totalMoods[singleMood] = count
                    } else {
                        totalMoods[singleMood] = 1
                    }
                }
            } else if let moods = grid[String(selectedYear)]?[strMonth]?[String(day)]?[K.defaults.moods] as? [String] { // legacy data
                mood = Mood.getMood(str: moods[moods.count - 1])
                for forMood in moods {
                    let singleMood = Mood.getMood(str: forMood)
                    if var count = totalMoods[singleMood] {
                        count += 1
                        totalMoods[singleMood] = count
                    } else {
                        totalMoods[singleMood] = 1
                    }
                }
            }
            
            if let gratitudez = grid[Date().get(.year)]?[strMonth]?[String(day)]?["gratitudes"] as? [String] {
                gratitudes += gratitudez.count
            } else if let gratitudez = grid[Date().get(.year)]?[strMonth]?[String(day)]?["journals"] as? [[String: String]] {
                gratitudes += gratitudez.count
            }


            if let _ = monthTiles[weekNumber] {
                monthTiles[weekNumber]?[day] = (plant, mood)
            } else { // first for this week
                monthTiles[weekNumber] = [day: (plant,mood)]
            }
        }
    }
    
    func getLastFive() {
        let lastFive = Date.getDates(forLastNDays: 5)
        var returnFive = [(String, Plant?,Mood?)]()
        for day in 0...lastFive.count - 1 {
            let selMon = Int(lastFive[day].get(.month)) ?? 1
            let selYear = String(Int(lastFive[day].get(.year)) ?? 2021)
            let selDay = String(Int(lastFive[day].get(.day)) ?? 1)
            var plant: Plant? = nil
            var mood: Mood? = nil
            if let sessions = grid[selYear]?[String(selMon)]?[selDay]?[K.defaults.sessions] as? [[String: String]] {
                let fbPlant = sessions[sessions.count - 1][K.defaults.plantSelected]
                plant = Plant.allPlants.first(where: { $0.title == fbPlant })
            }

            if let moods = grid[selYear]?[String(selMon)]?[selDay]?[K.defaults.moods] as? [String] {
                mood = Mood.getMood(str: moods[moods.count - 1])
            } else if  let moods = grid[selYear]?[String(selMon)]?[selDay]?[K.defaults.moods] as? [[String: String]] {
                let moodObj = moods[moods.count - 1]
                mood = Mood.getMood(str: moodObj["mood"] ?? "none")
            }
            
            let dayString = Date().intToAbrev(weekDay: Int(lastFive[day].get(.weekday)) ?? 1)
            returnFive.append((dayString, plant,mood))
        }

        self.lastFive = returnFive.reversed()
    }

    func updateSelf() {
        if let defaultRecents = UserDefaults.standard.value(forKey: "recent") as? [Int] {
            self.recentMeditations = defaultRecents.reversed()
        }

        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let gardenGrid = document[K.defaults.gardenGrid] as? [String: [String:[String:[String:Any]]]] {
                        self.grid = gardenGrid
                        UserDefaults(suiteName: K.widgetDefault)?.setValue(self.grid, forKey: "grid")
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    self.getLastFive()
                    if let allTimeMins = document["totalMins"] as? Int {
                        self.allTimeMinutes = allTimeMins
                    }
                    if let allTimeSess = document["totalSessions"] as? Int {
                        self.allTimeSessions = allTimeSess
                    }
                    self.populateMonth()
                    self.getRecentMeditations()
                    self.updateStartDay()
                }
            }
        } else {
            if let gridd = UserDefaults.standard.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]] {
                self.grid = gridd
            }
            getLastFive()
            if let allTimeMins = UserDefaults.standard.value(forKey: "allTimeMinutes") as? Int {
                self.allTimeMinutes = allTimeMins
            }
            if let allTimeSess = UserDefaults.standard.value(forKey: "allTimeSessions") as? Int {
                self.allTimeSessions = allTimeSess
            }
            self.populateMonth()
            self.getRecentMeditations()
            UserDefaults(suiteName: K.widgetDefault)?.setValue(self.grid, forKey: "grid")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    

    func save(key: String, saveValue: Any, date: Date = Date(), freeze: Bool = false, coins: Int,  completionHandler:  @escaping ()->Void = { }) {
        
        if key == "sessions" {
            if let session = saveValue as? [String: String] {
                if !freeze {  self.allTimeSessions += 1  }
                if let myNumber = (Double(session[K.defaults.duration] ?? "0.0") ?? 0).toInt() {
                    self.allTimeMinutes += myNumber
                }
            }
        }

        if let email = Auth.auth().currentUser?.email {
            let docRef = db.collection(K.userPreferences).document(email)
            docRef.getDocument { (snapshot, error) in
                
                if let document = snapshot, document.exists {
                    if let gardenGrid = document[K.defaults.gardenGrid] {
                        if let gd = gardenGrid as? [String: [String:[String:[String:Any]]]] {
                            self.grid = gd
                        }
                    }
                    self.saveToGrid(key: key, saveValue: saveValue, date: date)
                }

                self.db.collection(K.userPreferences).document(email).updateData([
                    "gardenGrid": self.grid,
                    "totalMins": self.allTimeMinutes,
                    "totalSessions": self.allTimeSessions,
                    "coins": coins,
                ]) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        self.getRecentMeditations()
                        self.updateData(completionHandler: completionHandler, key: key)
                    }
                }
            }
        } else {
            UserDefaults.standard.setValue(self.allTimeMinutes, forKey: "allTimeMinutes")
            UserDefaults.standard.setValue(self.allTimeSessions, forKey: "allTimeSessions")
            UserDefaults.standard.setValue(coins, forKey: "coins")
            if let gridd = UserDefaults.standard.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]] {
                self.grid = gridd
            }
            
            saveToGrid(key: key, saveValue: saveValue, date: date)
            
        }
        self.updateData(completionHandler: completionHandler, key: key)
    }
    
    private func updateData(completionHandler: ()->Void = { }, key: String) {
        UserDefaults.standard.setValue(self.grid, forKey: "grid")
        UserDefaults(suiteName: K.widgetDefault)?.setValue(self.grid, forKey: "grid")
        WidgetCenter.shared.reloadAllTimelines()
        self.populateMonth()
        self.getLastFive()
        self.getRecentMeditations()
    
        completionHandler()
    }
    
    private func saveToGrid(key: String, saveValue: Any, date: Date) {
        if let year = self.grid[date.get(.year)] {
            if let month = year[date.get(.month)] {
                if let day = month[date.get(.day)] {
                    if var values = day[key] as? [Any] {
                        //["plantSelected" : "coogie", "meditationId":3]
                        values.append(saveValue)
                        self.grid[date.get(.year)]?[date.get(.month)]?[date.get(.day)]?[key] = values
                    } else {
                        self.grid[date.get(.year)]?[date.get(.month)]?[date.get(.day)]?[key] = [saveValue]
                    }
                } else { // first save of type that day
                    self.grid[date.get(.year)]?[date.get(.month)]?[date.get(.day)] = [key: [saveValue]]
                }
            } else { //first session of month
                self.grid[date.get(.year)]?[date.get(.month)] = [date.get(.day): [key: [saveValue]]]
            }
        } else {
            self.grid[date.get(.year)] = [date.get(.month): [date.get(.day): [key: [saveValue]]]]
        }

    }
    
    func getLastLogMood()-> Mood {
        let userDefaults = UserDefaults(suiteName: K.widgetDefault)
        if let grid = userDefaults?.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]] {
            var day = Int(Date().get(.day)) ?? 0
            while(day>0) {
                if let mds = grid[Date().get(.year)]?[Date().get(.month)]?["\(day)"]?["moods"]  as? [[String: String]] {
                    return Mood.getMood(str: mds[mds.count - 1]["mood"] ?? "okay")
                }
                day = day - 1
            }
        }
        return Mood.okay
    }
    
    func getImagePath(month:String, day:String)-> String? {
    if let gratitudes = grid[Date().get(.year)]?[month]?[day]?["journals"]  as? [[String: String]] {
            return gratitudes[gratitudes.count-1]["image"]
        }
        return nil
    }
}


