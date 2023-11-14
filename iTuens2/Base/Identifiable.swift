//
//  Identifiable.swift
//  iTunes
//
//  Created by 서승우 on 2023/11/10.
//

import UIKit

protocol Identifiable: AnyObject {
    static var identifier: String {get}
}

extension UICollectionReusableView: Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView : Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

