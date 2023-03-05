//
//  RererralsModel.swift
//  MindGarden
//
//  Created by Vishal Davara on 27/04/22.
//


import SwiftUI

enum ReferralType: String {
    case ref1
    case ref2
    case ref3
}

var referralList = [
    ReferralItem(tabName:.ref1),
    ReferralItem(tabName:.ref2),
    ReferralItem(tabName:.ref3)
]

struct ReferralItem: Identifiable {
    var id = UUID()
    var tabName: ReferralType
    
    var image: Image {
        switch self.tabName {
        case .ref1: return Img.venusBadge
        case .ref2: return Img.redChest
        case .ref3: return Img.referral3
        }
    }
    
    
    var title : String {
        switch self.tabName {
        case .ref1: return "Your 1st Friend Invited"
        case .ref2: return "Every Friend Invited = +500 free coins"
        case .ref3: return "5 Friends = Limited Edition Sticker Pack"
        }
    }
    
    var subTitle: String {
        switch self.tabName {
        case .ref1: return "Unlock a rare venus fly trap when you invite your first friend and they sign up"
        case .ref2: return "In order for a referral to go through, your friend must signup with email using your link"
        case .ref3: return "Email us a screenshot team@mindgarden.io, and we'll mail you our pack for free!"
        }
    }
}
