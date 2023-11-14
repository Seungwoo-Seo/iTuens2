//
//  SubLabel.swift
//  iTunes
//
//  Created by 서승우 on 2023/11/12.
//

import UIKit

final class SubLabel: BaseLabel {

    override func initialAttributes() {
        super.initialAttributes()

        textColor = .lightGray
        textAlignment = .center
        font = .systemFont(ofSize: 14, weight: .medium)
    }

}
