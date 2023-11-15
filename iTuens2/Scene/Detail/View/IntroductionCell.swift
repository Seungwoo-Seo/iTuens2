//
//  IntroductionCell.swift
//  iTuens2
//
//  Created by 서승우 on 2023/11/15.
//

import UIKit
import Kingfisher

final class IntroductionCell: BaseCollectionViewCell {
    let appIconImageView = BorderImageView(image: nil)
    let appNameLabel = {
        let label = TitleLabel()
        label.numberOfLines = 0
        return label
    }()
    let companyLabel = {
        let label = SubLabel()
        label.textAlignment = .left
        return label
    }()
    let downloadButton = {
        var config = UIButton.Configuration.gray()
        config.cornerStyle = .capsule
        config.title = "받기"
        let button = UIButton(configuration: config)
        return button
    }()
    let newReleaseLabel = {
        let label = TitleLabel()
        label.text = "새로운 소식"
        return label
    }()
    let versionLabel = {
        let label = SubLabel()
        label.textAlignment = .left
        return label
    }()
    let releaseNotesLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            appIconImageView,
            appNameLabel,
            companyLabel,
            downloadButton,
            newReleaseLabel,
            versionLabel,
            releaseNotesLabel
        ].forEach { contentView.addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 8
        let inset = 16
        appIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offset)
            make.leading.equalToSuperview().inset(inset)
            make.size.equalTo(115)
        }

        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.top)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(offset*2)
            make.trailing.equalToSuperview().inset(inset)
        }

        companyLabel.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(offset/2)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(offset*2)
            make.trailing.equalToSuperview().inset(inset)
        }

        downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(appIconImageView.snp.trailing).offset(offset*2)
            make.bottom.equalTo(appIconImageView.snp.bottom)
        }

        newReleaseLabel.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.bottom).offset(offset*3)
            make.leading.equalToSuperview().inset(inset)
        }

        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(newReleaseLabel.snp.bottom).offset(offset)
            make.leading.equalToSuperview().inset(inset)
        }

        releaseNotesLabel.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(offset*2)
            make.horizontalEdges.bottom.equalToSuperview().inset(inset)
        }
    }

    func bind(with item: Detail) {
        appIconImageView.kf.setImage(with: item.imageUrl100)
        appNameLabel.text = item.trackName
        companyLabel.text = item.artistName
        versionLabel.text = item.version
        releaseNotesLabel.text = item.releaseNotes
    }

}

final class ScreenshotCell: BaseCollectionViewCell {
    let screentshotImageView = BorderImageView(image: nil)

    override func initialHierarchy() {
        super.initialHierarchy()

        contentView.addSubview(screentshotImageView)
    }

    override func initialLayout() {
        super.initialLayout()

        screentshotImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func bind(_ item: Detail) {
        screentshotImageView.kf.setImage(with: item.screenshotUrl)
    }
}

final class ExplanationCell: BaseCollectionViewCell {
    let descriptionLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        contentView.addSubview(descriptionLabel)
    }

    override func initialLayout() {
        super.initialLayout()

        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    func bind(_ item: Detail) {
        descriptionLabel.text = item.description
    }
}
