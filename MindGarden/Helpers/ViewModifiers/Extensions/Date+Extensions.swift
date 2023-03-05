//
//  Date+Extensions.swift
//  MindGarden
//
//  Created by Dante Kim on 8/7/21.
//

import Foundation


extension Date {
    static func dayOfWeek(day: String, month: String, year: String)-> String{
        // Specify date components
        let userCalendar = Calendar.current // since the components above (like year 1980) are for Gregorian
        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: Int(year) ?? 0, month: Int(month) ?? 0, day: Int(day) ?? 0)
        // Create date from components
        let someDateTime = userCalendar.date(from: dateComponents)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let weekDay = dateFormatter.string(from: someDateTime ?? Date())
        return weekDay
     }
    static func weekOfMonth() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.weekOfMonth, from: Date())
    }

    func get(_ type: Calendar.Component)-> String {
        let calendar = Calendar.current
        let t = calendar.component(type, from: self)
        return "\(t)"
    }

    func toString(withFormat format: String = "MM/dd/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        return str
    }
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    static func fullMonthName() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let monthName = Date().getMonthName(month: String(calendar.component(.month, from: Date())))
        return monthName
    }

    func weekDayToInt(weekDay: String) -> Int {
        switch weekDay {
        case "Sun":
            return 0
        case "Mon":
            return 1
        case "Tue":
            return 2
        case "Wed":
            return 3
        case "Thu":
            return 4
        case "Fri":
            return 5
        case "Sat":
            return 6
        default:
            return 0
        }
    }
    
    func intToAbrev(weekDay: Int) -> String {
        switch weekDay {
        case 1: return "Su"
        case 2: return "M"
        case 3: return "T"
        case 4: return "W"
        case 5: return "Th"
        case 6: return "F"
        case 7: return "S"
        default: return "S"
        }
    }

    func getNumberOfDays(month: String, year: String) -> Int {
        switch month {
        case "1":
            return 31
        case "2":
            if isLeapYear(Int(year) ?? 2000) {
                return 29
            } else {
                return 28
            }
        case "3":
            return 31
        case "4":
            return 30
        case "5":
            return 31
        case "6":
            return 30
        case "7":
            return 31
        case "8":
            return 31
        case "9":
            return 30
        case "10":
            return 31
        case "11":
            return 30
        case "12":
            return 31
        default:
            return -1
        }
    }

    func getMonthName(month: String) -> String {
        switch month {
        case "1":
            return "January"
        case "2":
           return "February"
        case "3":
            return "March"
        case "4":
            return "April"
        case "5":
            return "May"
        case "6":
            return "June"
        case "7":
            return "July"
        case "8":
            return "August"
        case "9":
            return "September"
        case "10":
            return "October"
        case "11":
            return "November"
        case "12":
            return "December"
        default:
            return "-1"
        }
    }

    static func isSameDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }

    func getMonthNum(month: String) -> Int {
        switch month {
        case "Jan":
            return 1
        case "Feb":
            return 2
        case "Mar":
            return 3
        case "Apr":
            return 4
        case "May":
            return 5
        case "Jun":
            return 6
        case "Jul":
            return 7
        case "Aug":
            return 8
        case "Sep":
            return 9
        case "Oct":
            return 10
        case "Nov":
            return 11
        case "Dec":
            return 12
        default:
            return -1
        }

    }
    static func getTime() -> String {
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        let stringTime = timeFormatter.string(from: time)
        return stringTime
    }
    func intToMonth(num: Int) -> String {
        switch num {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return "Jan"

        }
    }
    func isLeapYear(_ year: Int) -> Bool {
        let isLeapYear = ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))

        return isLeapYear
    }

    static func isBetween(_ date1: Date, and date2: Date) -> Bool {
           return (min(date1, date2) ... max(date1, date2)).contains(Date())
       }

    static func needsExtraRow(month: Int, year: Int) -> Bool {
        let month = Date().intToMonth(num: month)
        let monthNum = String(Date().getMonthNum(month: month))
        let weekDay = self.dayOfWeek(day: "1", month: monthNum, year: String(year))
        switch weekDay {
        case "Fri":
            if Date().getNumberOfDays(month: monthNum, year: String(year)) == 31 {
                return true
            }
        case "Sat":
            if Date().getNumberOfDays(month: monthNum, year: String(year)) == 31 || Date().getNumberOfDays(month: monthNum, year: String(year)) == 30 {
                return true
            }
        default:
            return false
        }
        return false
    }
}

extension TimeInterval{
    
    func secondsFromTimeInterval() -> String {
        let time = NSInteger(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    func secondsToHourMinFormat() -> String? {
        let time = self
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .pad
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let date = dateFormatter.date(from: formatter.string(from: time) ?? "")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date ?? Date())
    }
}

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
          var dates: [Date] = []
          var date = fromDate
          
          while date <= toDate {
              dates.append(date)
              guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
              date = newDate
          }
          dates.removeLast()
          return dates
    }
    
    static func getDates(forLastNDays nDays: Int) -> [Date] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())

        var arrDates = [Date]()
        arrDates.append(Date())
        for _ in 1 ... nDays - 1 {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date) ?? Date()
            arrDates.append(date)
        }
        
        return arrDates
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
    
    func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec
        
        return cal.date(from: components)
    }
    
    func getdateAfterweek(week:Int) -> Date? {
        let calendar = Calendar.current
        let today = Date()
        return calendar.date(byAdding: .day, value: (7 * week), to: today)
    }
    
    func getdateAfterdays(days:Int) -> Date? {
        let calendar = Calendar.current
        let today = Date()
        return calendar.date(byAdding: .day, value: days, to: today)
    }
}
