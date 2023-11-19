//
//  DetailViewModel.swift
//  iTuens2
//
//  Created by 서승우 on 2023/11/18.
//

import Foundation
import RxCocoa
import RxSwift

final class DetailViewModel: ViewModelType {
    let disposeBag = DisposeBag()

    let appInfoContainer: BehaviorRelay<[AppInfoContainer]> = BehaviorRelay(value: [])

    struct Input {

    }

    struct Output {
        let detailSections: BehaviorRelay<[DetailSection]>
    }

    func transform(input: Input) -> Output {
        let detailSections: BehaviorRelay<[DetailSection]> = BehaviorRelay(value: [])

        appInfoContainer
            .map {
                var detailSections: [DetailSection] = []

                if let container = $0.first,
                   let item = container.items.first {

                    // 3개로 쪼개야함
                    // 1.
                    let section0 = DetailSection(items: [
                        Detail(
                            imageUrl100: item.imageUrl100,
                            trackName: item.trackName,
                            artistName: item.artistName,
                            version: item.version,
                            releaseNotes: item.releaseNotes
                        )
                    ])

                    let section1 = DetailSection(items: [
                        Detail(screenshotUrl: item.screenshotURLs[0]),
                        Detail(screenshotUrl: item.screenshotURLs[1]),
                        Detail(screenshotUrl: item.screenshotURLs[2]),
                    ])

                    let section2 = DetailSection(items: [
                        Detail(description: item.description)
                    ])

                    [section0, section1, section2].forEach { detailSections.append($0) }
                }

                return detailSections
            }
            .bind(with: self) { owner, sections in
                detailSections.accept(sections)
            }
            .disposed(by: disposeBag)

        return Output(
            detailSections: detailSections
        )
    }

}
