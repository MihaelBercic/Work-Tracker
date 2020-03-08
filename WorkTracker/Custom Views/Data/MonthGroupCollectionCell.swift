//
// Created by Mihael Bercic on 06/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class MonthGroupCollectionCell: CUICollectionViewCell, ViewSetup {

    let label = UILabel()

    func onInit() {
        backgroundColor = sharedAppColor
        layer.cornerRadius = 5
    }

    func setHierarchy() { addSubview(label) }

    func setConstraints() {
        label.connect {
            $0.topAnchor = topAnchor
            $0.leftAnchor = leftAnchor
            $0.rightAnchor = rightAnchor
            $0.bottomAnchor = bottomAnchor
        }
    }

    func modifySubviews() {
        label.use {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = .boldSystemFont(ofSize: 13)
        }
    }
}
