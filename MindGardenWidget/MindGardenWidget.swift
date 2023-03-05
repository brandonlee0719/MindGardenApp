//
//  MindGardenWidget.swift
//  MindGardenWidget
//
//  Created by Dante Kim on 12/26/21.
//

import WidgetKit
import SwiftUI
import Intents
import Amplitude
import Firebase


struct Provider: IntentTimelineProvider {
    let gridd = [String: [String:[String:[String:Any]]]]()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = [] 
        let userDefaults = UserDefaults(suiteName: K.widgetDefault)

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let grid = userDefaults?.value(forKey: "grid") as? [String: [String:[String:[String:Any]]]] ?? [:]
        let streakNumber = userDefaults?.value(forKey: "streakNumber") as? Int ?? 1
        let isPro = userDefaults?.value(forKey: "isPro") as? Bool ?? false
        
        let lastLogDate = userDefaults?.value(forKey: "lastJournel") as? String ?? Date().toString(withFormat: "MMM dd, yyyy")
        let strLastLogMood = userDefaults?.value(forKey: "logMood") as? String ?? "okay"
        let lastLogMood = Mood.getMoodImageWidget(mood: Mood.getMood(str: strLastLogMood))
        
        let meditation = userDefaults?.value(forKey: "featuredMeditation") as? Int
        let breathwork = userDefaults?.value(forKey: "featuredBreathwork") as? Int
        
//        let breathImg = Breathwork.breathworks.first(where: { $0.id == breathwork } ) ?? Breathwork.breathworks.first!
//        let meditationImg = Meditation.allMeditations.first(where: { $0.id == meditation } ) ?? Meditation.allMeditations.first!
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) ?? Date()
            let entry = SimpleEntry(date: entryDate, grid: grid, streakNumber: streakNumber, isPro: isPro,lastLogDate: lastLogDate, lastLogMood: lastLogMood, configuration: configuration, meditationId:meditation ?? 2, breathWorkId: breathwork ?? -1/*,meditationImg: meditationImg.img, breathWorkImg:breathImg.img*/)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date = Date()
    var grid = [String: [String:[String:[String:Any]]]]()
    var streakNumber: Int = 0
    var isPro: Bool = false
    var lastLogDate: String = Date().toString(withFormat: "MMM dd, yyyy")
    var lastLogMood: Image = Image("okay")
    let configuration: ConfigurationIntent
    var meditationId: Int = 1
    var breathWorkId: Int = -1
    var meditationImg: Image = Image("meditatingTurtle")
    var breathWorkImg: Image = Image("mediumWidgetBreathwork")
}

struct MindGardenWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    @State var moods: [Mood: Int]
    @State var gratitudes: Int
    @State var streak: Int
    @State var plants: [Plnt]
    @State var dayTime: Bool
    @State var totalTime: Int
    @State var totalSess: Int

    @ViewBuilder
    var body: some View {
        ZStack {
            Color("darkWhite")
                .neoShadow()
            switch family {
            case .systemSmall:
                SmallWidget(streak: entry.streakNumber)
            case .systemMedium:
                NewMediumWidget(mediumEntry: MediumEntry(lastDate: entry.lastLogDate, lastMood: entry.lastLogMood, meditationId: entry.meditationId, breathworkId: entry.breathWorkId, breathworkImg: entry.breathWorkImg, meditationImg: entry.meditationImg))
            case .systemLarge:
                LargeWidget(streakNumber: entry.streakNumber,gardenModel: GardenViewModel(), grid:entry.grid)
            default:
                Text("Some other WidgetFamily in the future.")
            }
        }.onAppear {
            let hour = Calendar.current.component( .hour, from:Date() )
            if hour <= 17 {
                dayTime = true
            } else {
                dayTime = false
            }
//            extractData()
            Timer.scheduledTimer(withTimeInterval: 3600.0, repeats: true) { timer in
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }

    var GoProPage: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("This is a pro only feature")
                    .font(Font.fredoka(.bold, size: 18))
                    .foregroundColor(Color("superBlack"))
                Link(destination: URL(string: "pro://io.bytehouse.mindgarden")!)  {
                    Capsule()
                        .fill(Color("darkgreen"))
                        .overlay(Text("👨‍🌾 Go Pro!")
                                    .foregroundColor(.white)
                                    .font(Font.fredoka(.bold, size: 14)))
                        .frame(width: 125, height: 35)
                        .padding(.top, 5)
                        .neoShadow()
                }
                Spacer()
                }
                Spacer()
            }
    }

    func extractData() {
//       var monthTiles = [Int: [Int: (String?, Mood?)]]()
       var totalMoods = [Mood:Int]()
       var startsOnSunday = false
       var placeHolders = 0
       let strMonth = Date().get(.month)
       var favoritePlants = [String: Int]()
       let numOfDays = Date().getNumberOfDays(month: strMonth, year: Date().get(.year))
       let intWeek = Date().weekDayToInt(weekDay: Date.dayOfWeek(day: "1", month: strMonth, year: Date().get(.year)))
      streak = entry.streakNumber
       if intWeek != 0 {
           placeHolders = intWeek
       } else { //it starts on a sunday
           startsOnSunday = true
       }
       var allPlants = [String]()
       var weekNumber = 0
       for day in 1...numOfDays {
           var plant: String? = nil
           var mood: Mood? = nil
           let weekday = Date.dayOfWeek(day: String(day), month: strMonth, year: Date().get(.year))
           let weekInt = Date().weekDayToInt(weekDay: weekday)

           if weekInt == 0 && !startsOnSunday {
               weekNumber += 1
           } else if startsOnSunday {
               startsOnSunday = false
           }

           if let sessions = entry.grid[String(Date().get(.year))]?[strMonth]?[String(day)]?[KK.defaults.sessions] as? [[String: String]] {
               for session in sessions {
                   self.totalSess += 1
                   self.totalTime += Int(Double(session[K.defaults.duration] ?? "0.0") ?? 0.0)
                   let plant = session[KK.defaults.plantSelected] ?? ""
                   allPlants.append(plant)
               }
           }

           if let moods = entry.grid[String(Date().get(.year))]?[strMonth]?[String(day)]?[KK.defaults.moods] as? [String] {
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

           if let gratitudez = entry.grid[Date().get(.year)]?[strMonth]?[String(day)]?[KK.defaults.gratitudes] as? [String] {
               gratitudes += gratitudez.count
           }
   }
        var plantz = [Plnt]()
        for plant in allPlants {
//            if  plant != "Bonsai Tree"  {
                if let img = KK.plantImages[plant]{
                    let plnt = Plnt(title: img, id: plant)
                    plantz.append(plnt)
                }
//            }
        }
        plantz = plantz.reversed()
        plants = plantz
        moods = totalMoods
    }


    struct SingleMood: View {
        let mood: Mood
        let count: Int

        var body: some View {
            VStack(spacing: 2) {
                KK.getMoodImage(mood: mood)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("\(count)")
                    .font(Font.fredoka(.bold, size: 12))
                    .foregroundColor(Color.white)
            }

        }
    }

    struct MenuChoice: View {
        let title: String
        let img: Image
        let width: CGFloat

        var body: some View {
            ZStack {
                Capsule()
                    .fill(Color("darkWhite"))
                HStack(spacing: -5) {
                    Text(title)
                        .font(Font.fredoka(.medium, size: 16))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Color("darkgreen"))
                        .frame(width: width * 0.3, alignment: .leading)
                        .padding(.leading, 5)
                        .offset(x: 10)
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("darkgreen"))
                        .padding(3)
                        .frame(width: width * 0.07)
                }.frame(width: width * 0.4, alignment: .leading)
            }
        }
    }
}

struct Plnt: Identifiable {
    let title,id:String
}

@main
struct MindGardenWidget: Widget {
    let kind: String = "MindGardenWidget"
    
    init(){
        FirebaseApp.configure()
    }

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MindGardenWidgetEntryView(entry: entry, moods: [Mood: Int](), gratitudes: 0, streak: 1, plants: [Plnt](), dayTime: true, totalTime: 0, totalSess: 0)
        }
        .configurationDisplayName("MindGarden Widget")
        .description("⚙️ This is the first version of our MindGarden widget. If you would like new features or layouts or experience a bug please fill out the feedback form in the settings page of the app :) We're a small team of 3 so all this feedback will be taken very seriously.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct MindGardenWidget_Previews: PreviewProvider {
    static var previews: some View {
        MindGardenWidgetEntryView(entry: SimpleEntry(configuration: ConfigurationIntent()), moods: [Mood: Int](), gratitudes: 0, streak: 1, plants: [Plnt](), dayTime: true, totalTime: 0, totalSess: 0)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
