//
// Created by Mihael Bercic on 29/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

protocol ViewSetup {
    func modifySubviews()
    func onInit()
    func setHierarchy()
    func setConstraints()
}

extension ViewSetup {
    func modifySubviews() {}

    func onInit() {}

    func setHierarchy() {}

    func setConstraints() {}
}

// Views
class CUIView: UIView {

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        if let delegate = self as? ViewSetup {
            delegate.onInit()
            delegate.setHierarchy()
            delegate.setConstraints()
            delegate.modifySubviews()
        }

    }

    required init?(coder: NSCoder) { super.init(coder: coder) }
}

class CUITableView: UITableView {
    override init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)
        if let delegate = self as? ViewSetup {
            delegate.onInit()
            delegate.setHierarchy()
            delegate.setConstraints()
            delegate.modifySubviews()
        }
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }
}

class CUICollectionView: UICollectionView {

    override init(frame: CGRect = .zero, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        if let delegate = self as? ViewSetup {
            delegate.onInit()
            delegate.setHierarchy()
            delegate.setConstraints()
            delegate.modifySubviews()
        }
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }
}

class CUITextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        if let delegate = self as? ViewSetup {
            delegate.onInit()
            delegate.setHierarchy()
            delegate.setConstraints()
            delegate.modifySubviews()
        }
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }
}


// Reusable cells
class CUITableViewCell: UITableViewCell {

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if let delegate = self as? ViewSetup {
            delegate.onInit()
            delegate.setHierarchy()
            delegate.setConstraints()
            delegate.modifySubviews()
        }
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }
}

class CUICollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        if let delegate = self as? ViewSetup {
            delegate.onInit()
            delegate.setHierarchy()
            delegate.setConstraints()
            delegate.modifySubviews()
        }
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }
}

// Controllers
class CUIViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if let delegate = self as? ViewSetup {
            delegate.onInit()
            delegate.setHierarchy()
            delegate.setConstraints()
            delegate.modifySubviews()
        }
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = self as? ViewSetup {
            delegate.onInit()
            delegate.setHierarchy()
            delegate.setConstraints()
            delegate.modifySubviews()
        }
    }
    */
}

