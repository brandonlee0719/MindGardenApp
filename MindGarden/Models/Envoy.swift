//
//  Envoy.swift
//  MindGarden
//
//  Created by Vishal Davara on 15/10/22.
//

import Foundation


struct EnvoyResponse: Codable {
    let url: String?

    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}

struct UserQuota: Codable {
    let userId: String?
    let userRemainingQuota: Int?

    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case userRemainingQuota = "userRemainingQuota"
    }
}

// MARK: - Envoy
struct EnvoyData: Codable {
    let userID: String
    let contentConfig: ContentConfig

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case contentConfig
    }
}

// MARK: - ContentConfig
struct ContentConfig: Codable {
    let contentType, contentName, contentDescription, contentID: String
    let common: Common

    enum CodingKeys: String, CodingKey {
        case contentType, contentName, contentDescription
        case contentID = "contentId"
        case common
    }
}

// MARK: - Common
struct Common: Codable {
    let media: Media
}

// MARK: - Media
struct Media: Codable {
    let source: String
    let sourceIsRedirect: Bool
    let poster: String
}
