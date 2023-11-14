//
//  AppInfo.swift
//  iTuens2
//
//  Created by 서승우 on 2023/11/14.
//

import Foundation

struct AppInfoContainer: Codable {
    let appList: [AppInfo]

    enum CodingKeys: String, CodingKey {
        case appList = "results"
    }
}

struct AppInfo: Codable {
    let artworkUrl60, artworkUrl100: String
    let screenshotUrls: [String]
    let releaseNotes: String
    let artistName: String
    let genres: [String]
    let description: String
    let trackName: String
    let averageUserRating: Double
    let version: String
}
