//
// Created by Mihael Bercic on 04/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class ClientCollectionViewCell: CUICollectionViewCell, ViewSetup {


    // Colors
    private let  initialBackgroundColor:  UIColor = UIColor.systemGray5.withAlphaComponent(0.3)
    private let  selectedBackgroundColor: UIColor = UIColor.systemGray5

    // Views
    private let  nameLabel                        = UILabel()
    private let  circleView                       = ClientCircularView()
    private let  selectedView                     = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))

    // On selected
    override var isSelected:              Bool {
        get { super.isSelected }
        set {
            super.isSelected = newValue
            selectedView.isHidden = !newValue
            backgroundColor = newValue ? selectedBackgroundColor : initialBackgroundColor
        }
    }

}

// Custom
extension ClientCollectionViewCell {
    func setClient(client: Client) {
        circleView.setup(client, clientSize: 50)
        nameLabel.text = client.name
    }
}

// On Init
extension ClientCollectionViewCell {
    func onInit() {
        backgroundColor = initialBackgroundColor
        layer.cornerRadius = 10
    }
}

// Hierarchy
extension ClientCollectionViewCell {
    func setHierarchy() {
        addSubview(circleView)
        addSubview(nameLabel)
        addSubview(selectedView)
    }
}

// Constraints
extension ClientCollectionViewCell {
    func setConstraints() {
        circleView.connect {
            $0.topAnchor = topAnchor
            $0.centerXAnchor = centerXAnchor
            $0.topConstant = 10
        }

        nameLabel.connect {
            $0.topAnchor = circleView.bottomAnchor
            $0.leftAnchor = leftAnchor
            $0.rightAnchor = rightAnchor
            $0.bottomAnchor = bottomAnchor
            $0.leftConstant = 10
            $0.rightConstant = -10
        }

        selectedView.connect {
            $0.topAnchor = topAnchor
            $0.topConstant = -10
            $0.rightAnchor = rightAnchor
            $0.rightConstant = 10
            $0.widthConstant = 30
            $0.heightConstant = 30
        }
    }
}

// Subviews
extension ClientCollectionViewCell {
    func modifySubviews() {
        nameLabel.use {
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 12)
        }
        selectedView.use {
            $0.tintColor = sharedAppColor
            $0.backgroundColor = .systemBackground
            $0.layer.cornerRadius = 15
            $0.isHidden = true
        }
    }
}