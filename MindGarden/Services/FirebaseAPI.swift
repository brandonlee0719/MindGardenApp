//
//  FirebaseAPI.swift
//  MindGarden
//
//  Created by Dante Kim on 2/7/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct FirebaseAPI {
    let db = Firestore.firestore()
    var firebaseMeds: [Meditation] = []
    let medModel: MeditationViewModel 
    
    // For the Learn Page
     func fetchCourses() {
        db.collection("Learn Page").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    var courseImg = ""
                    var courseDesc = ""
                    var courseDuration = ""
                    var courseCategory = ""
                    var courseSlides = [Slide]()
                    var courseId = 0
                    
                    if let id = document["id"] as? Int {
                        courseId = id
                    }
                    if let image = document["image"] as? String {
                        courseImg = image
                    }
                    
                    if let desc = document["description"] as? String {
                        courseDesc = desc
                    }
                    
                    if let duration = document["duration"] as? String {
                        courseDuration = duration
                    }
                    
                    if let category = document["category"] as? String {
                        courseCategory = category
                    }
                    if let slides = document["slides"] as? [[String: String]] {
                        for slide in slides {
                            courseSlides.append(Slide(topText: slide["topText"] ?? "", img: slide["img"] ?? "", bottomText: slide["bottomText"] ?? ""))
                        }
                    }
                    
                    let newCourse = LearnCourse(id: courseId, title: document.documentID, img: courseImg, description: courseDesc, duration: courseDuration, category: courseCategory, slides: courseSlides)
                    
                    if !LearnCourse.courses.contains(where: { $0.title == document.documentID }) {
                        LearnCourse.courses.append(newCourse)
                    }
                }
            }
        }
    }
    
    // For Meditation Page
     func fetchMeditations(meditationModel: MeditationViewModel) {
        db.collection("Meditations").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    var medDuration = 0
                    var medAuthor = ""
                    var medImage = ""
                    var medAudio = ""
                    var medReward = 0
                    var medType: MeditationType = .single
                    var medCateogry: Category = .all
                    var medDescription = ""
                    var medBelongsTo = "none"
                    var medId = 0
                    var medNew = false
                    if let duration = document["duration"] as? Int {
                        medDuration = duration
                    }
                    if let author = document["author"] as? String {
                        medAuthor = author
                    }
                    if let audio = document["audio"] as? String {
                        medAudio = audio
                    }
                    if let image = document["image"] as? String {
                        medImage = image
                    }
                    if let reward = document["reward"] as? Int {
                        medReward = reward
                    }
                    if let description = document["description"] as? String {
                        medDescription = description
                    }
                    if let belongsTo = document["belongsTo"] as? String {
                        medBelongsTo = belongsTo
                    }
                    if let id  = document["id"] as? Int {
                        medId = id
                    }
                    if let isNew = document["isNew"] as? Bool {
                        medNew = isNew
                    }
                    if let type = document["type"] as? String {
                        switch type {
                        case "single": medType = .single
                        case "lesson": medType = .lesson
                        case "single+lesson": medType = .single_and_lesson
                        case "course": medType = .course
                        case "weekly": medType = .weekly
                        default: medType = .single
                        }
                    }
                    if let category = document["category"] as? String {
                        switch category {
                        case "all": medCateogry = .all
                        case "unguided": medCateogry = .unguided
                        case "begineers": medCateogry = .beginners
                        case "courses": medCateogry = .courses
                        case "anxiety": medCateogry = .anxiety
                        case "focus": medCateogry = .focus
                        case "sleep": medCateogry = .sleep
                        case "confidence": medCateogry = .confidence
                        case "growth": medCateogry = .growth
                        case "sadness": medCateogry = .sadness
                        default: break
                        }
                    }
                    let newMed = Meditation(title: document.documentID, description: medDescription, belongsTo: medBelongsTo, category: medCateogry, img: Img.bee, type: medType, id: medId, duration: Float(medDuration), reward: medReward, url: medAudio, instructor: medAuthor,  imgURL: medImage, isNew: medNew)
                    if !firebaseMeds.contains(where: { med in med.title != document.documentID }) {
                        if medNew && medType != .weekly {
                            meditationModel.newMeditations.insert(newMed, at: 0)
                        }
                        if medType == .weekly && medNew {
                            meditationModel.weeklyMeditation = newMed
                        }
//                        firebaseMeds.append(Meditation(title: document.documentID, description: medDescription, belongsTo: medBelongsTo, category: medCateogry, img: Img.bee, type: medType, id: medId, duration: Float(medDuration), reward: medReward, url: medAudio, instructor: medAuthor,  imgURL: medImage, isNew: medNew))
                    }
                    if Meditation.allMeditations.contains(where: { med in  med.id != medId }) {
                        Meditation.allMeditations.append(newMed)
                    }
                }
                medModel.getFeaturedMeditation()
                medModel.getUserMap()
            }
        }
    }
}
