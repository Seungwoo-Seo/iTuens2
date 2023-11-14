//
//  TitleLabel.swift
//  iTunes
//
//  Created by 서승우 on 2023/11/12.
//

import UIKit

final class TitleLabel: BaseLabel {

    override func initialAttributes() {
        super.initialAttributes()

        textColor = .black
        font = .systemFont(ofSize: 20, weight: .bold)
    }

}
