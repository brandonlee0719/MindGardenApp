//
//  Meditation.swift
//  MindGarden
//
//  Created by Dante Kim on 8/7/21.
//
enum Experience {
    case often, nowAndThen, never
    
    var title: String {
        switch self {
        case .often: return "Meditate often"
        case .nowAndThen: return "Have tried to meditate"
        case .never: return "Have never meditated"
        }
    }
}


import SwiftUI
// https://feed.podbean.com/mindgarden/feed.xml
struct Meditation: Hashable {
    let title: String
    let description: String
    let belongsTo: String
    let category: Category
    let img: Image
    let type: MeditationType
    let id: Int
    let duration: Float
    let reward: Int
    let url: String
    let instructor: String
    let imgURL: String
    let isNew: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Meditation, rhs: Meditation) -> Bool {
        return lhs.id == rhs.id
    }

    static var lockedMeditations = [20, 21, 25,37,39,40,49,50,51,54,78,90,87,81,77, 105,14, 104, 88, 92, 26, 75, 15,16,17,18,19,20,21, 38, 40, 41, 42, 43, 44, 45, 46, 47,48,49, 50, 51, 37, 16, 36]
    static var popularMeditations = [77, 92, 89, 105, 108, 104, 90, 85, 24]
    static var morningMeds = [53, 49, 50, 84]
    func returnEventName() -> String {
        return self.title.replacingOccurrences(of: "?", with: "").replacingOccurrences(of: "&", with: "x").replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: ",", with: "_")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "7", with: "seven")
            .lowercased()
    }

    static func getRecsFromMood(selectedMood: Mood, elaboration: String = "") -> [Int] {
        var retMeds: [Meditation] = []
        var filtedMeds = Meditation.allMeditations.filter { med in
            med.type != .lesson && med.id != 22 && med.id != 55 && med.id != 56  }
        
        if !UserDefaults.standard.bool(forKey: "isPro") {
            filtedMeds = filtedMeds.filter({ med in
                return !lockedMeditations.contains(where: {$0 == med.id})
            })
        }
        
        if Calendar.current.component(.hour, from: Date()) > 20 { // night time
            filtedMeds = filtedMeds.filter { med in
                med.id != 53 && med.id != 49
            }
        } else {
            filtedMeds = filtedMeds.filter { med in
                med.category != .sleep
            }
        }
        
        if UserDefaults.standard.string(forKey: "experience") != Experience.never.title && UserDefaults.standard.string(forKey: "experience") != "Have never meditated" {
            if !UserDefaults.standard.bool(forKey: "beginnerCourse") {
                retMeds.append(allMeditations.first(where: { $0.id == 6 }) ?? allMeditations[0])
            } else if !UserDefaults.standard.bool(forKey: "intermediateCourse") {
                retMeds.append(allMeditations.first(where: { $0.id == 14 }) ?? allMeditations[0])
            }
        } else {
            retMeds.append(allMeditations.first(where: { $0.id == 57 }) ?? allMeditations[0])
        }
        
        if UserDefaults.standard.string(forKey: "experience") != Experience.often.title && UserDefaults.standard.string(forKey: "experience") != "Meditate often" {
            if  UserDefaults.standard.integer(forKey: "dailyLaunchNumber") <= 12 {
                filtedMeds = filtedMeds.filter({ med in  med.duration <= 360 && med.category != .unguided  })
            } else if  UserDefaults.standard.integer(forKey: "dailyLaunchNumber") <= 20 {
                filtedMeds = filtedMeds.filter({ med in  med.duration <= 700 && med.category != .unguided  })
            }
        }
        
        var breathWork = 0
        switch selectedMood {
        case .stressed, .veryBad:
            retMeds += filtedMeds.filter { med in  med.category == .anxiety || med.category == .sadness }
            breathWork = Breathwork.breathworks.filter({ breath in   breath.color == .calm }).shuffled()[0].id
        case .angry:
            retMeds += filtedMeds.filter { med in
                med.id == 24 || med.id == 42 || med.id == 25 || med.id == 15 || med.id == 50
            }
        case .okay, .happy, .good, .veryGood:
            if Calendar.current.component( .hour, from:Date() ) < 12 { // daytime meds only
                retMeds += filtedMeds.filter { med in Meditation.morningMeds.contains(med.id) || med.category == .growth || med.category == .confidence }
            } else {
                retMeds += filtedMeds.filter { med in  med.category == .growth || med.category == .confidence }
            }
            breathWork = Breathwork.breathworks.filter({ breath in   breath.color == .calm || breath.id == -2 }).shuffled()[0].id

        case .sad, .bad:
            breathWork = Breathwork.breathworks.filter({ breath in   breath.color == .calm }).shuffled()[0].id
            retMeds += filtedMeds.filter { med in
                med.category == .anxiety || med.category == .sadness
            }
        case .none: break
        }
        
        if elaboration == "😴 Tired" {
            breathWork = -2
        }
        
        if retMeds.count < 3 {
            retMeds += filtedMeds.filter { med in !retMeds.contains(med) }
        }
        retMeds.shuffle()
        var finalMeds = [breathWork]
        for med in retMeds {
            finalMeds.append(med.id)
        }
        
        return finalMeds
    }
    
    static var allMeditations = [
//        Meditation(title: "Open-Ended Meditation", description: "Unguided meditation with no time limit, with the option to add a gong sounds every couple of minutes.", belongsTo: "Unguided", category: .unguided, img: Img.starfish, type: .course, id: 1, duration: 0, reward: 0),

        Meditation(title: "Timed Meditation", description: "Timed unguided (no talking) meditation, with the option to turn on background noises such as rain. A bell will signal the end of your session.", belongsTo: "Unguided", category: .unguided, img: Img.alarmClock, type: .course, id: 2, duration: 0, reward: 0, url: "", instructor: "Unguided", imgURL: "", isNew: false),
        Meditation(title: "1 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.alarmClock, type: .lesson, id: 3, duration: 60, reward: 20, url: "", instructor: "Unguided", imgURL: "", isNew: false),
        Meditation(title: "2 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.alarmClock, type: .lesson, id: 4, duration: 120, reward: 40, url: "", instructor: "Unguided", imgURL: "", isNew: false),
        Meditation(title: "5 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.alarmClock, type: .lesson, id: 5, duration: 300, reward: 60, url: "", instructor: "Unguided", imgURL: "", isNew: false),
        Meditation(title: "10 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.alarmClock, type: .lesson, id: 28, duration: 600, reward: 100, url: "", instructor: "Unguided", imgURL: "", isNew: false),
        Meditation(title: "15 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.alarmClock, type: .lesson, id: 29, duration: 900, reward: 140, url: "", instructor: "Unguided", imgURL: "", isNew: false),
        Meditation(title: "20 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.alarmClock, type: .lesson, id: 30, duration: 1200, reward: 170, url: "", instructor: "Unguided", imgURL: "", isNew: false),
        Meditation(title: "25 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.alarmClock, type: .lesson, id: 31, duration: 1500, reward: 200, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "30 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.alarmClock, type: .lesson, id: 32, duration: 1800, reward: 220, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "45 Minute Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.alarmClock, type: .lesson, id: 33, duration: 2700, reward: 250, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "1 Hour Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.alarmClock, type: .lesson, id: 34, duration: 3600, reward: 300, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "2 Hour Meditation", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Timed Meditation", category: .unguided, img: Img.alarmClock, type: .lesson, id: 35, duration: 7200, reward: 350, url: "", instructor: "Unguided",  imgURL: "", isNew: false),

        // Beginners Course
        Meditation(title: "Intro to Meditation", description: "Learn how to meditate with founder Bijan, a certified mindfulness instructor. Learn why meditation can drastically improve happiness, focus and so much more.", belongsTo: "Unguided", category: .beginners, img: Img.happySunflower, type: .course, id: 6, duration: 0, reward: 0, url: "", instructor: "Bijan",  imgURL: "", isNew: false),
        Meditation(title: "What is Meditation?", description: "Learn why millions of people around the world use this daily practice.", belongsTo: "Intro to Meditation", category: .courses, img: Img.happySunflower, type: .lesson, id: 7, duration: 422, reward: 80, url: "https://mcdn.podbean.com/mf/web/g84ptk/Day_1_Intro_to_Meditation_Finalbscsp.mp3", instructor: "Bijan",  imgURL: "", isNew: false),
        Meditation(title: "Keep it Simple", description: "Learn how to create an anchor that can help ground you during your most busy and stormy seasons.", belongsTo: "Intro to Meditation", category: .courses, img: Img.happySunflower, type: .lesson, id: 8, duration: 324, reward: 80, url: "https://mcdn.podbean.com/mf/web/fc676u/Day_2_Intro_to_Meditation_Final6fn82.mp3", instructor: "Bijan", imgURL: "", isNew: false),
        Meditation(title: "Handling Our Thoughts & Emotions", description: "", belongsTo: "Intro to Meditation", category: .courses, img: Img.happySunflower, type: .lesson, id: 9, duration: 383, reward: 80, url: "https://mcdn.podbean.com/mf/web/qripk5/day_3_intro_to_meditation_final93cb2.mp3", instructor: "Bijan",  imgURL: "", isNew: false),
        Meditation(title: "Acceptance", description: "Learn how meditating can help you think and observe much more clearly.", belongsTo: "Intro to Meditation", category: .courses, img: Img.happySunflower, type: .lesson, id: 10, duration: 312, reward: 80, url: "https://mcdn.podbean.com/mf/web/eirruy/Day_4_intro_to_meditation_finalb1uko.mp3", instructor: "Bijan",  imgURL: "", isNew: false),
        Meditation(title: "Gratitude", description: "Learn how daily meditation can be the perfect cure and preventer of stress and anxiety", belongsTo: "Intro to Meditation", category: .courses, img: Img.happySunflower, type: .lesson, id: 11, duration: 349, reward: 80, url: "https://mcdn.podbean.com/mf/web/brkva6/Day_5_Intro_to_Meditation_Finalbs7xv.mp3", instructor: "Bijan", imgURL: "", isNew: false),
        Meditation(title: "Compassion & Self-Love", description: "Discover how meditating can create boundless amounts of love & compassion for yourself & the people around you", belongsTo: "Intro to Meditation", category: .courses, img: Img.happySunflower, type: .lesson, id: 12, duration: 285, reward: 80, url: "https://mcdn.podbean.com/mf/web/y8wbsb/Day_6_Intro_to_Meditation_Finalahwwg.mp3", instructor: "Bijan",  imgURL: "", isNew: false),
        Meditation(title: "Daily Practice", description: "Discover how meditating can help you create the super power of generating happiness on demand.", belongsTo: "Intro to Meditation", category: .courses, img: Img.happySunflower, type: .lesson, id: 13, duration: 166, reward: 80, url: "https://mcdn.podbean.com/mf/web/g8i975/Day_7_Intro_to_Meditation_Final7ewof.mp3", instructor: "Bijan",  imgURL: "", isNew: false),

        //Intermediate Course
        Meditation(title: "7 Days to Happiness", description: "A 7 day series, where we use meditation to become focused, happier and motivated.", belongsTo: "Unguided", category: .courses, img: Img.kiwi, type: .course, id: 14, duration: 0, reward: 0, url: "", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Clearing the Mind", description: "Learn the fundamentals of clearing all the noise in your head so you can finally learn to listen the right signals.", belongsTo: "7 Days to Happiness", category: .beginners, img: Img.gnome, type: .lesson, id: 15, duration: 617, reward: 100, url: "https://mcdn.podbean.com/mf/web/khbnmt/1454C_Clearing_the_Mind_10_min_VOCALS929z1.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Cultivate Self Love", description: "Do you constantly put your self down? Learn the basics of loving yourself and accepting who you are.", belongsTo: "7 Days to Happiness", category: .growth, img: Img.lemon, type: .lesson, id: 16, duration: 629, reward: 100, url: "https://mcdn.podbean.com/mf/web/jsffxx/1441_Cultivate_Beautiful_Self_Love_-_10_min_VOCALSa4nt3.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Creativity & Inspiration", description: "Do you constantly feel stuck? Learn how to break-through and unleash the creativity hidden inside you", belongsTo: "7 Days to Happiness", category: .focus, img: Img.pencil, type: .lesson, id: 17, duration: 606, reward: 100, url: "https://mcdn.podbean.com/mf/web/bgbwzn/1446C_Enhance_Creativity_and_Boost_Inspiration_10_min_VOCALSaiunb.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Sustain Focus & Increase Motivation", description: "Build the discipline of laser like focus and rock solid motivation through some breath work and simple observation", belongsTo: "7 Days to Happiness", category: .focus, img: Img.target, type: .lesson, id: 18, duration: 615, reward: 100, url: "https://mcdn.podbean.com/mf/web/244bfv/1440C_Sustain_Focus_and_Increase_Motivation_10_min_VOCALS8fk39.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "The Basics", description: "A simple 10 minute guided meditaiton you can do anywhere at anytime, empty the mind, get relaxed and receive clarity.", belongsTo: "7 Days to Happiness", category: .beginners, img: Img.icecream, type: .lesson, id: 19, duration: 616, reward: 100, url: "https://mcdn.podbean.com/mf/web/2p2ww9/1433_10_Minute_Guided_Meditation_that_you_can_listen_to_every_day_VOCALS9v8ek.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Thankful Meditation for Gratitude", description: "Gratitude is the easiest thing you can do to become happier, learn to truly be thankful when having a clear focused mind.", belongsTo: "7 Days to Happiness", category: .growth, img: Img.hands, type: .lesson, id: 20, duration: 608, reward: 100, url: "https://mcdn.podbean.com/mf/web/ez7xsw/1456C_Thankful_Meditation_for_Gratitude_10_min_VOCALSbfhth.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Life is Beautiful", description: "When you have no agenda, and simply observe you come to realize just how breath taking life truly is.", belongsTo: "7 Days to Happiness", category: .growth, img: Img.apple3, type: .lesson, id: 21, duration: 623, reward: 100, url: "https://mcdn.podbean.com/mf/web/5w8mig/1530_A_Meditation_Called_Life_is_Beautiful_10_min_VOCALS99c8u.mp3", instructor: "Lisa",  imgURL: "", isNew: false),

        // Singles
        Meditation(title: "30 Second Meditation", description: "A super quick, 30 second breath work session.", belongsTo: "Unguided", category: .all, img: Img.strawberryMilk, type: .single, id: 22, duration: 29, reward: 10, url: "", instructor: "Bijan",  imgURL: "", isNew: false),
        Meditation(title: "Basic Guided Meditation", description: "A 5 minute guided meditation to help you start or end the day in a mindful matter.", belongsTo: "Unguided", category: .beginners, img: Img.starfish, type: .single, id: 23, duration: 310, reward: 80, url: "https://mcdn.podbean.com/mf/web/8cuz7s/Basic_Guided_Meditationbwagl.mp3", instructor: "Andrew",  imgURL: "", isNew: false),
        Meditation(title: "Semi-Guided Meditation", description: "A 10 minute semi-guided meditation for more advanced meditators looking to start or end their day present, focused, and calm.", belongsTo: "Unguided", category: .beginners, img: Img.feather, type: .single, id: 24, duration: 607, reward: 160, url: "https://mcdn.podbean.com/mf/web/56xviu/Semi-Guided_Meditation6qqb0.mp3", instructor: "Andrew",  imgURL: "", isNew: false),
        Meditation(title: "Meditation for Focus", description: "A simple 5 minute guided meditation to help you calm your mind, and enter a relaxed focused state.", belongsTo: "Unguided", category: .focus, img: Img.magnifyingGlass, type: .single, id: 25, duration: 315, reward: 80, url: "https://mcdn.podbean.com/mf/web/7d2g5m/Meditation_for_Focus8fetr.mp3", instructor: "Andrew",  imgURL: "", isNew: false),
        Meditation(title: "Body Scan", description: "A short guided meditation to help you tune into your body, reconnect to your physical self and notice any sensations without any judgement. ", belongsTo: "Unguided", category: .all, img: Img.heart, type: .single, id: 26, duration: 345, reward: 80, url: "https://mcdn.podbean.com/mf/web/3dqhaz/Body_Scanairn6.mp3", instructor: "Andrew",  imgURL: "", isNew: false),
        Meditation(title: "Better Faster Sleep", description: "A 5 minute guided meditation to help you relax, let go and fall into a deep restful sleep.", belongsTo: "Unguided", category: .sleep, img: Img.sleepingSloth, type: .single, id: 27, duration: 335, reward: 60, url: "https://mcdn.podbean.com/mf/web/n283c3/Better_Faster_Sleep9pxwf.mp3", instructor: "Andrew",  imgURL: "", isNew: false),
        // girl
        Meditation(title: "Chronic Pain, Safe Place", description: "Learn to deal with chronic stress and ease the emotional stress it brings through breath work.", belongsTo: "Unguided", category: .anxiety, img: Img.house, type: .single, id: 36, duration: 828, reward: 150, url: "https://mcdn.podbean.com/mf/web/3x43dz/228_Relieve_Stress_and_Activate_Intuition_VOCALSaj10d.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "A Sense of Gratitude", description: "In this meditation learn how to cultivate a sense of gratitude.", belongsTo: "Unguided", category: .growth, img: Img.wateringPot, type: .single, id: 37, duration: 1147, reward: 200, url: "https://mcdn.podbean.com/mf/web/gjbfjp/365_Sense_of_Gratitude_VOCALS6inm8.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Relieve Stress, Activate Intuition", description: "Learn the secret to relieving stress, and activating your inner intuition", belongsTo: "Unguided", category: .anxiety, img: Img.brain, type: .single, id: 38, duration: 1225, reward: 210, url: "https://mcdn.podbean.com/mf/web/3x43dz/228_Relieve_Stress_and_Activate_Intuition_VOCALSaj10d.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Deep Sleep", description: "A 20 minute meditation for people looking to quickly fall into a deep sleep", belongsTo: "Unguided", category: .sleep, img: Img.moonFull, type: .single, id: 39, duration: 1285, reward: 200, url: "https://mcdn.podbean.com/mf/web/4vxfi9/366_Deep_Sleep_VOCALS86ffx.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Meditation for Happiness", description: "Learn that happiness, just like anything else in life can be learned..", belongsTo: "Unguided", category: .growth, img: Img.daisy3, type: .single, id: 40, duration: 1227, reward: 200, url: "https://mcdn.podbean.com/mf/web/hu3net/372_Meditation_for_Happiness_VOCALS827d7.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Build Confidence", description: "Learn to feel confidence and break away from your negative thought patterns", belongsTo: "Unguided", category: .confidence, img: Img.sunglasses, type: .single, id: 41, duration: 1160, reward: 200, url: "https://mcdn.podbean.com/mf/web/2aysdh/358_Experience_Confidence_VOCALS64r7q.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Emotional Balance", description: "Learn to balance your tricky emotions and experience peace & clarity", belongsTo: "Unguided", category: .growth, img: Img.watermelon, type: .single, id: 42, duration: 1143, reward: 200, url: "https://mcdn.podbean.com/mf/web/etnx62/361_Emotional_Balance_VOCALSaba3g.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Basic Confidence Meditation", description: "A basic guided meditation to build confidence and break away from your negative thought patterns", belongsTo: "Unguided", category: .confidence, img: Img.palm, type: .single, id: 43, duration: 845, reward: 150, url: "https://mcdn.podbean.com/mf/web/2aysdh/358_Experience_Confidence_VOCALS64r7q.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "It Lies Within You", description: "Learn that confidence lies within you and how to bring it out", belongsTo: "Unguided", category: .confidence, img: Img.gnome, type: .single, id: 44, duration: 1154, reward: 200, url: "https://mcdn.podbean.com/mf/web/2aysdh/358_Experience_Confidence_VOCALS64r7q.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "How to Meditate", description: "Learn how to meditate and simply it truly is", belongsTo: "Unguided", category: .beginners, img: Img.books, type: .single, id: 45, duration: 305, reward: 50, url: "https://mcdn.podbean.com/mf/web/tr4dnq/1403_How_To_Meditate_VOCALSbrsfv.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Relieve Anxiety", description: "In this guided meditation gain control over your anxiety & experience peace and calmness.", belongsTo: "Unguided", category: .anxiety, img: Img.cloud, type: .single, id: 46, duration: 609, reward: 100, url: "https://mcdn.podbean.com/mf/web/y39bbt/1432_Guided_Meditation_for_Anxiety_10_min_VOCALSajbr7.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Good Morning, Positive Energy", description: "Learn how to cultive creatity and boost inspiration by being present.", belongsTo: "Unguided", category: .growth, img: Img.eggs, type: .single, id: 49, duration: 607, reward: 100, url: "https://mcdn.podbean.com/mf/web/h6wmv9/1523_Good_Morning_Positive_Energy_Meditation_10_min_VOCALSbgvsn.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Affirmations", description: "Affirmations for health, wealth, love and happiness.", belongsTo: "Unguided", category: .growth, img: Img.bee, type: .single, id: 50, duration: 632, reward: 100, url: "https://mcdn.podbean.com/mf/web/y39bbt/1432_Guided_Meditation_for_Anxiety_10_min_VOCALSajbr7.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Clearing Fears", description: "Learn to focus on what you can control & to quiet your fears", belongsTo: "Unguided", category: .anxiety, img: Img.hand, type: .single, id: 51, duration: 517, reward: 100, url: "https://mcdn.podbean.com/mf/web/rtmi4k/1540_Clearing_Fears_Held_in_the_Body_Scan_9_min_VOCALS8kge3.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Handle Insecurity", description: "Learn to quiet your insecurities and replace it with inspiration.", belongsTo: "Unguided", category: .anxiety, img: Img.wave, type: .single, id: 52, duration: 1185, reward: 200, url: "https://mcdn.podbean.com/mf/web/xm4jyj/390_Handle_Insecurity_VOCALS92hmv.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Seize the Day", description: "Prepare yourself to crush the day ahead with a smile.", belongsTo: "Unguided", category: .growth, img: Img.sun, type: .single, id: 53, duration: 626, reward: 100, url: "https://mcdn.podbean.com/mf/web/rucidp/1398_Seize_the_Day_Morning_Meditation_VOCALSb63wx.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Bedtime Meditation", description: "Relax & fall asleep to this peaceful meditation", belongsTo: "Unguided", category: .sleep, img: Img.sheep, type: .single, id: 54, duration: 600, reward: 100, url: "https://mcdn.podbean.com/mf/web/5cefi8/429_Bedtime_VOCALS7ekok.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Studying Meditation", description: "Want an edge over your classmates? Use this meditation before very study session to enter a laser focused state.", belongsTo: "Unguided", category: .focus, img: Img.kidStudying, type: .single, id: 55, duration: 486, reward: 120, url: "https://mcdn.podbean.com/mf/web/293n4c/meditation-for-studying.mp3", instructor: "Lisa",  imgURL: "", isNew: false),
        Meditation(title: "Exam Anxiety Meditation", description: "Feeling test jitters? Can't focus? Overthinking? Use this meditation to enter a calm zen state.", belongsTo: "Unguided", category: .anxiety, img: Img.cando, type: .single, id: 56, duration: 672, reward: 100, url: "https://mcdn.podbean.com/mf/web/4ywe6m/exam-anxiety-meditation.mp3", instructor: "Lisa",  imgURL: "", isNew: false),

        // Open Ended Meditation
        Meditation(title: "Open-ended Meditation", description: "Untimed unguided (no talking) meditation, with the option to turn on background noises such as rain. You may also play a bell every x minutes to stay focused.", belongsTo: "Unguided", category: .unguided, img: Img.bell, type: .course, id: 57, duration: 0, reward: 0, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "Play bell every 1 minute", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 1 minute.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 58, duration: -1, reward: -1, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "Play bell every 2 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 2 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 59, duration: -1, reward: -1, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "Play bell every 5 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 5 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 60, duration: -1, reward: -1, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "Play bell every 10 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 10 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 61, duration: -1, reward: -1, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "Play bell every 15 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 15 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 62, duration: -1, reward: -1, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "Play bell every 20 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 20 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 63, duration: -1, reward: -1, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "Play bell every 25 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 25 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 64, duration: -1, reward: -1, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "Play bell every 30 minutes", description: "Untimed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal you every 30 minutes.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 65, duration: -1, reward: -1, url: "", instructor: "Unguided",  imgURL: "", isNew: false),
        Meditation(title: "Play bell every 1 hour", description: "Timed unguided (no talking) meditation for a fixed period, with the option to turn on background noises such as rain. A bell will signal the end of your session.",  belongsTo: "Open-ended Meditation", category: .unguided, img: Img.bell, type: .lesson, id: 66, duration: -1, reward: -1, url: "", instructor: "Unguided",  imgURL: "", isNew: false),

        //Andrew's Beginner Course
        Meditation(title: "The Basics Course", description: "Learn the basics of meditaiton and why making it a habit can drastically improve happiness, focus and so much more", belongsTo: "Unguided", category: .beginners, img: Img.juiceBoxes, type: .course, id: 67, duration: 0, reward: 0, url: "1d", instructor: "Andrew",  imgURL: "", isNew: false),
        Meditation(title: "Why Meditate?", description: "Learn why millions of people around the world use this daily practice.", belongsTo: "The Basics Course", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 68, duration: 320, reward: 80, url: "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/Why%20Meditate%3F.mp3?alt=media&token=8e12978b-bb52-4692-b149-d9021f2a41a1", instructor: "Andrew",  imgURL: "", isNew: false),
        Meditation(title: "Create Your Anchor", description: "Learn how to create an anchor that can help ground you during your most busy and stormy seasons.", belongsTo: "The Basics Course", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 69, duration: 322, reward: 80, url: "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/Create%20Your%20Anchor.mp3?alt=media&token=87476158-7d3f-4401-be1f-b59ba3721c07", instructor: "Andrew",  imgURL: "", isNew: false),
        Meditation(title: "Tuning Into Your Body", description: "Discover how to use the body scan meditation to become more aware of your bodily experiences and the emotions tied to them.", belongsTo: "The Basics Course", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 70, duration: 429, reward: 80, url: "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/Tuning%20Into%20Your%20Body.mp3?alt=media&token=cc115cc6-564c-45fd-8779-ffe952239d20", instructor: "Andrew",  imgURL: "", isNew: false),
        Meditation(title: "Gaining Clarity", description: "Learn how meditating can help you think and observe much more clearly.", belongsTo: "The Basics Course", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 71, duration: 292, reward: 80, url: "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/Gaining%20Clarity.mp3?alt=media&token=5b515222-eb5c-49d1-a9fb-a996299e9f3b", instructor: "Andrew",  imgURL: "", isNew: false),
        Meditation(title: "Stress Antidote", description: "Learn how daily meditation can be the perfect cure and preventer of stress and anxiety", belongsTo: "The Basics Course", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 72, duration: 365, reward: 80, url: "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/Stress%20Antidote.mp3?alt=media&token=ca73b1f6-8172-456d-b2cb-1fea74a52d00", instructor: "Andrew",  imgURL: "", isNew: false),
        Meditation(title: "Compassion & Self-Love", description: "Discover how meditati ng can create boundless amounts of love & compassion for yourself & the people around you", belongsTo: "The Basics Course", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 73, duration: 314, reward: 80, url: "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/Compassion%20%26%20Self-Love.mp3?alt=media&token=8fe2c170-27fc-4b7b-b754-073801a9d7db", instructor: "Andrew",  imgURL: "", isNew: false),
        Meditation(title: "Joy on demand", description: "Discover how meditating can help you create the super power of generating happiness on demand.", belongsTo: "The Basics Course", category: .courses, img: Img.juiceBoxes, type: .lesson, id: 74, duration: 324, reward: 80, url: "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/Joy%20on%20demand.mp3?alt=media&token=67539144-de86-4af8-99b3-b8b960efffc6", instructor: "Andrew",  imgURL: "", isNew: false),

        //Bijan's stuff
        Meditation(title: "Coping with Cravings", description: "Researchers have found that people who practice regular meditation had a lower likelihood of binge eating, worrying about food, and mindless snacking. The secret: being mindful.", belongsTo: "Unguided", category: .beginners, img: Img.utensils, type: .single, id: 75, duration: 375, reward: 90, url: "https://mcdn.podbean.com/mf/web/krgcu9/Deal_With_Cravings62ffv.mp3", instructor: "Bijan",  imgURL: "", isNew: false),
        Meditation(title: "Caring for our anger", description: "Sit down and take a deep breath with Bijan. It's okay to be frustrated and upset, but constantly being in that state of mind is depleting and stressful. Break free with meditaiton", belongsTo: "Unguided", category: .beginners, img: Img.angryFire, type: .single, id: 76, duration: 578, reward: 160, url: "https://mcdn.podbean.com/mf/web/quuidx/Caring_for_our_Anger6iuut.mp3", instructor: "Bijan",  imgURL: "", isNew: false),

    ]
}

enum MeditationType {
    case single
    case lesson
    case course
    case single_and_lesson
    case weekly

    func toString() -> String {
        switch self {
            case .single: return "Single"
            case .lesson: return "Lesson"
            case .single_and_lesson: return "Single"
            case .course: return "Course"
            case .weekly: return "Weekly"
        }
    }
}
