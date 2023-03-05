//
//  ShareStreakModel.swift
//  demo
//
//  Created by Vishal Davara on 26/03/22.
//

import SwiftUI

struct ShareStreakItem: Identifiable {
    var id = UUID()
    var image: Image
    var name: String
    var type: ShareStreakType
}

var streakItems = [
    ShareStreakItem(image: Image(systemName: "person.fill"), name: "Share to Twitter", type: .twitter),
    ShareStreakItem(image: Image(systemName: "person.fill"), name: "Share to Instagram", type: .instagram),
    ShareStreakItem(image: Image(systemName: "person.fill"), name: "Share to Facebook", type: .facebook),
    ShareStreakItem(image: Image(systemName: "person.fill"), name: "Share to Messenger", type: .messenger),
    ShareStreakItem(image: Image(systemName: "person.fill"), name: "Share to Messages", type: .messages),
    ShareStreakItem(image: Image(systemName: "person.fill"), name: "Share to WhatsApp", type: .whatsapp)
]

var streakItems1 = [
    ShareStreakItem(image: Image(systemName: "person.fill"), name: "Save Image", type: .saveimage)
]

var streakItems2 = [
    ShareStreakItem(image: Image(systemName: "person.fill"), name: "More", type: .more)
]

enum ShareStreakType: String {
    case twitter
    case instagram
    case facebook
    case messenger
    case messages
    case whatsapp
    case saveimage
    case more
}
