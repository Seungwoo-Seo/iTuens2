//
//  SearchResultCell.swift
//  iTunes
//
//  Created by 서승우 on 2023/11/12.
//

import UIKit
import Kingfisher

final class SearchResultCell: BaseTableViewCell {

    let appIconImageView = BorderImageView(image: nil)
    let appNameLabel = TitleLabel()
    let downloadButton = {
        var config = UIButton.Configuration.gray()
        config.cornerStyle = .capsule
        config.title = "받기"
        let button = UIButton(configuration: config)
        return button
    }()
    let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
    let gpaLabel = SubLabel()
    let companyLabel = SubLabel()
    let categoryLabel = SubLabel()
    let screenshotStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    let screenshotImageView0 = BorderImageView(image: nil)
    let screenshotImageView1 = BorderImageView(image: nil)
    let screenshotImageView2 = BorderImageView(image: nil)

    func bind(with appInfo: AppInfo) {

        appIconImageView.kf.setImage(with: appInfo.imageUrl60)
        appNameLabel.text = appInfo.trackName
        gpaLabel.text = appInfo.gpa
        companyLabel.text = appInfo.artistName
        categoryLabel.text = appInfo.joinedGenres

        let screenshots = [
            screenshotImageView0,
            screenshotImageView1,
            screenshotImageView2
        ]

        for (index, screenshot) in screenshots.enumerated() {
            let url = appInfo.screenshotURLs[index]
            screenshot.kf.setImage(with: url)
        }
    }

    override func initialAttributes() {
        super.initialAttributes()

        selectionStyle = .none

        appNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        appNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        downloadButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        downloadButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        starImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        starImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        gpaLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        gpaLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        companyLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        companyLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        categoryLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        categoryLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            appIconImageView,
            appNameLabel,
            downloadButton,
            starImageView,
            gpaLabel,
            companyLabel,
            categoryLabel,
            screenshotStackView
        ].forEach { contentView.addSubview($0) }

        [
            screenshotImageView0,
            screenshotImageView1,
            screenshotImageView2
        ].forEach { screenshotStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 8
        let inset = 16
        appIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
            make.size.equalTo(60)
        }

        appNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(appIconImageView.snp.centerY)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(offset)
        }

        downloadButton.snp.makeConstraints { make in
            make.centerY.equalTo(appNameLabel.snp.centerY)
            make.leading.equalTo(appNameLabel.snp.trailing).offset(offset)
            make.trailing.equalToSuperview().inset(inset)
        }

        starImageView.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.bottom).offset(offset)
            make.leading.equalToSuperview().inset(inset)
        }

        gpaLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starImageView.snp.centerY)
            make.leading.equalTo(starImageView.snp.trailing).offset(offset/2)
        }

        companyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(gpaLabel.snp.centerY)
            make.leading.equalTo(gpaLabel.snp.trailing).offset(offset/2)
        }

        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(companyLabel.snp.centerY)
            make.leading.equalTo(companyLabel.snp.trailing).offset(offset/2)
            make.trailing.equalToSuperview().inset(inset)
        }

        screenshotStackView.snp.makeConstraints { make in
            make.top.equalTo(starImageView.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(inset*2)
            make.height.equalTo(200)
        }
    }

}
