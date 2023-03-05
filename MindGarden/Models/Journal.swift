//
//  Journal.swift
//  MindGarden
//
//  Created by Dante Kim on 7/30/22.
//
import SwiftUI

struct Journal: Hashable {
    let title: String
    let category: PromptsTabType
    let img: Image
    let id: Int
    let description: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Journal, rhs: Journal) -> Bool {
        return lhs.id == rhs.id
    }

    static var prompts: [Journal] = [
        //MARK: - Gratitude
        Journal(title: "Look Around", category: .gratitude, img: Img.hands, id: 1, description: "What’s something around you that you can feel grateful for?"),
        Journal(title: "Health is Wealth", category: .gratitude, img: Img.appleHealth , id: 2, description: "What’s something about your body or health that you can feel grateful for?"),
        Journal(title: "Relationships", category: .gratitude, img:Img.pandaTurtle , id: 3, description: "Who’s a person in your life who you can feel grateful for? Why are you grateful for them?"),
        Journal(title: "Recent Moments", category: .gratitude, img: Img.fishBowl, id: 4, description: "Think of a moment that happened recently that you can feel grateful for."),
        Journal(title: "Simple Pleasures", category: .gratitude, img: Img.coffee, id: 5, description: "What’s a simple pleasure you can feel grateful for?"),
        Journal(title: "Present Moment", category: .gratitude, img: Img.alarmClock, id: 6, description: "What are three things you can feel grateful for in this moment?"),
        
        //MARK: - Morning
        Journal(title: "Create a great day", category: .morning, img: Img.sun , id: 7, description: "What do you want today to look like? What do you want to do? How do you want to feel?"),
        Journal(title: "Daily Intention", category: .morning, img: Img.avocado, id: 8, description: "What are your main intentions today?"),
        Journal(title: "Morning Reflection", category: .morning, img: Img.pencil, id: 9, description: "What’s on your mind? How are you feeling?"),
        Journal(title: "Spread Joy", category: .morning, img: Img.happyPot, id: 10, description: "How can you create a joyful world around you today?"),
        Journal(title: "Get Hyped", category: .morning, img: Img.completeRacoon, id: 11, description: "What’s something you’re excited about doing today?"),

        //MARK: - Evening
        Journal(title: "Nightly Reflection", category: .evening, img: Img.moon , id: 13, description: "What’s on your mind? How are you feeling after a long day?"),
        Journal(title: "Daily Highlights", category: .evening, img: Img.star , id: 14, description: "Reflect on the most impactful moments of the day"),
        Journal(title: "Always Learning", category: .evening, img: Img.wateringPot , id: 15, description: "What’s something new you learned or realized today?"),
        Journal(title: "Good Times", category: .evening, img: Img.gnome , id: 16, description: "What made you laugh or smile today?"),
        Journal(title: "Honest Evaluation", category: .evening, img: Img.cloud , id: 17, description: "How did you respond to life today? Would you do anything differently?"),

        //MARK: - mental health
        Journal(title: "Gratitude", category: .mentalHealth, img: Img.hands , id: 18, description: "What are 3 things you can feel grateful for in this moment?"),
        Journal(title: "Letting Go", category: .mentalHealth, img: Img.traffic , id: 19, description: "What do you need to let go of in order to grow?"),
        Journal(title: "Understanding Anxiety", category: .mentalHealth, img: Img.sun , id: 20, description: "What are the thoughts that trigger your anxiety? Crystalize them with text"),
        Journal(title: "Recognize your Growth", category: .mentalHealth, img: Img.plane, id: 21, description: "Reflect on the person you were 5 years ago vs who you are now."),
        Journal(title: "Happy Moments", category: .mentalHealth, img: Img.cactusSmile , id: 22, description: "When do you feel the most happy? Write in as much detail as possible."),
        Journal(title: "Mental Getaway", category: .mentalHealth, img: Img.palm , id: 23, description: "Describe a place where you feel most relaxed and peaceful."),
        Journal(title: "Love Letter", category: .mentalHealth, img: Img.heart , id: 24, description: "Write a love letter to yourself."),
        Journal(title: "Forgiveness", category: .mentalHealth, img: Img.sun , id: 25, description: "Write a letter of forgiveness to yourself."),

        //MARK: - Big Picture
        Journal(title: "Weekly Reflection", category: .bigPicture, img: Img.subway , id: 26, description: "Reflect on your previous week. What do you want this next week to look like? "),
        Journal(title: "Monthly Reflection", category: .bigPicture, img: Img.train , id: 27, description: "Reflect on the past 30 days. What do you want this next month to look like?"),
        Journal(title: "Yearly Reflection", category: .bigPicture, img: Img.plane , id: 28, description: "Reflect on this past year. What do you want this next year to look like?"),
        Journal(title: "Life Direction", category: .bigPicture, img: Img.camera , id: 29, description: "If money was no issue what's something you would want to do everyday?"),
        Journal(title: "Your Ideal Self", category: .bigPicture, img: Img.statRacoon , id: 30, description: "What does your ideal self look like 5 years from now? What are the steps you can take to get there?"),
        Journal(title: "Change is Good", category: .bigPicture, img: Img.airBalloon , id: 31, description: "What are some things you want to change about yourself & your life going forward?"),
        Journal(title: "Priorities", category: .bigPicture, img: Img.target , id: 32, description: "What are the most important things to you? Do your actions align with your priorities?")
    ]
}

