//
//  BaseViewController.swift
//  iTunes
//
//  Created by 서승우 on 2023/11/10.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController, Base {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialAttributes()
        initialHierarchy()
        initialLayout()
    }

    func initialAttributes() {
        view.backgroundColor = .systemBackground
    }

    func initialHierarchy() {}

    func initialLayout() {}

}
