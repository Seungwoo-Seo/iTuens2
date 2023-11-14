//
//  BorderImageView.swift
//  iTunes
//
//  Created by 서승우 on 2023/11/12.
//

import UIKit

final class BorderImageView: BaseImageView {

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true
    }

}
