//
//  MWMModel.swift
//  MindGarden
//
//  Created by Dante Kim on 2/19/23.
//

import Foundation

final class MWMModel {
    static var shared = MWMModel()
    enum DynamicScreenPlacement: String, CaseIterable {
        case onboarding = "PUB#app_launch#onboarding"
        case store = "PUB#home_btn_store#store"
        case login = "PUB#anywhere#login"
    }
}
