//
//  AppInfo.swift
//  iTuens2
//
//  Created by 서승우 on 2023/11/14.
//

import Foundation
import RxDataSources

struct AppInfoContainer: Codable {
    var items: [AppInfo] = []

    enum CodingKeys: String, CodingKey {
        case items = "results"
    }
}

extension AppInfoContainer: SectionModelType {
    typealias Item = AppInfo

    init(original: AppInfoContainer, items: [Item]) {
        self = original
        self.items = items
    }
}

struct AppInfo: Codable {
    let artworkUrl60, artworkUrl100: String
    let screenshotUrls: [String]
    let releaseNotes: String?
    let artistName: String
    let genres: [String]
    let description: String
    let trackName: String
    let averageUserRating: Double
    let version: String

    var imageUrl60: URL? {
        return URL(string: artworkUrl60)
    }

    var imageUrl100: URL? {
        return URL(string: artworkUrl100)
    }

    var gpa: String {
        return String(format: "%.1f", averageUserRating)
    }

    var joinedGenres: String {
        return genres.joined(separator: ",")
    }

    var screenshotURLs: [URL?] {
        return screenshotUrls.map {
            URL(string: $0)
        }
    }

}
