//
//  DetailViewController.swift
//  iTuens2
//
//  Created by 서승우 on 2023/11/15.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift


final class DetailViewController: BaseViewController {

    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.register(IntroductionCell.self, forCellWithReuseIdentifier: IntroductionCell.identifier)
        view.register(ScreenshotCell.self, forCellWithReuseIdentifier: ScreenshotCell.identifier)
        view.register(ExplanationCell.self, forCellWithReuseIdentifier: ExplanationCell.identifier)
        return view
    }()

    let appInfoContainer: BehaviorRelay<[AppInfoContainer]> = BehaviorRelay(value: [])
    let detailSections: BehaviorRelay<[DetailSection]> = BehaviorRelay(value: [])


    let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        view.addSubview(collectionView)
    }

    override func initialLayout() {
        super.initialLayout()

        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }


    func bind() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<DetailSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let section = Section.allCases[indexPath.section]
                switch section {
                case .introduction:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: IntroductionCell.identifier,
                        for: indexPath
                    ) as? IntroductionCell else {return UICollectionViewCell()}

                    cell.bind(with: item)

                    return cell

                case .screenshot:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ScreenshotCell.identifier,
                        for: indexPath
                    ) as? ScreenshotCell else {return UICollectionViewCell()}

                    cell.bind(item)

                    return cell

                case .explanation:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ExplanationCell.identifier,
                        for: indexPath
                    ) as? ExplanationCell else {return UICollectionViewCell()}

                    cell.bind(item)

                    return cell
                }
            }
        )


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
                owner.detailSections.accept(sections)
            }
            .disposed(by: disposeBag)

        detailSections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}

private extension DetailViewController {

    enum Section: Int, CaseIterable {
        case introduction
        case screenshot
        case explanation
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) in
            guard let self else {return nil}
            let section = Section.allCases[sectionIndex]
            switch section {
            case .introduction:
                return self.introductionSectionLayout()

            case .screenshot:
                return self.screenshotSectionLayout()

            case .explanation:
                return self.explanationSectionLayout()
            }
        }
        return layout
    }

    func introductionSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(400)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(400)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func screenshotSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.7),
            heightDimension: .absolute(400)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)

        return section
    }

    func explanationSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(800)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(800)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
