//
//  Detail.swift
//  iTuens2
//
//  Created by 서승우 on 2023/11/15.
//

import Foundation
import RxDataSources

// AppContainer와 AppInfo를 DTO로 두고
// 각 뷰마다 Domain Object로 대응하는게 좋을 듯
struct DetailSection { // -> DetailSection이 3개가 나와야함!
    var items: [Item]
}

extension DetailSection: SectionModelType {
    typealias Item = Detail

    init(original: DetailSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct Detail {
    let imageUrl100: URL?
    let trackName: String?
    let artistName: String?
    let version: String?
    let releaseNotes: String?

    let screenshotUrl: URL?

    let description: String?

    init(imageUrl100: URL?, trackName: String?, artistName: String?, version: String?, releaseNotes: String?) {
        self.imageUrl100 = imageUrl100
        self.trackName = trackName
        self.artistName = artistName
        self.version = version
        self.releaseNotes = releaseNotes
        self.screenshotUrl = nil
        self.description = nil
    }

    init(screenshotUrl: URL?) {
        self.imageUrl100 = nil
        self.trackName = nil
        self.artistName = nil
        self.version = nil
        self.releaseNotes = nil
        self.screenshotUrl = screenshotUrl
        self.description = nil
    }

    init(description: String?) {
        self.imageUrl100 = nil
        self.trackName = nil
        self.artistName = nil
        self.version = nil
        self.releaseNotes = nil
        self.screenshotUrl = nil
        self.description = description
    }
}
