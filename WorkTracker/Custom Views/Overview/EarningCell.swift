//
// Created by Mihael Bercic on 10/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class EarningCell: CUITableCell, ViewSetup {

    private let todayLabel     = UILabel()
    private let currencyLabel  = UILabel()
    private let thisMonthLabel = UILabel()

}

// Custom
extension EarningCell {
    func display(today: Int, currency: Character, thisMonth: Int) {
        let todayFormatted     = decimalFormatter.string(from: today.asDecimal.dividing(by: 100))
        let thisMonthFormatted = decimalFormatter.string(from: thisMonth.asDecimal.dividing(by: 100))
        todayLabel.text = todayFormatted
        currencyLabel.text = "\(currency)"
        thisMonthLabel.text = thisMonthFormatted
    }
}

// On Init
extension EarningCell {
    func onInit() {
        backgroundColor = sharedAppColor
    }
}

// Hierarchy
extension EarningCell {
    func setHierarchy() {
        addSubview(todayLabel)
        addSubview(currencyLabel)
        addSubview(thisMonthLabel)
    }
}

// Constraints
extension EarningCell {
    func setConstraints() {
        todayLabel.connect {
            $0.topAnchor = topAnchor
            $0.leftAnchor = leftAnchor
            $0.rightAnchor = currencyLabel.leftAnchor
            $0.bottomAnchor = bottomAnchor
        }
        currencyLabel.connect {
            $0.topAnchor = topAnchor
            $0.centerXAnchor = centerXAnchor
            $0.widthConstant = 30
            $0.bottomAnchor = bottomAnchor
        }
        thisMonthLabel.connect {
            $0.topAnchor = topAnchor
            $0.leftAnchor = currencyLabel.rightAnchor
            $0.rightAnchor = rightAnchor
            $0.bottomAnchor = bottomAnchor
        }
    }
}

// Subviews
extension EarningCell {
    func modifySubviews() {
        todayLabel.use {
            $0.textAlignment = .right
            $0.textColor = .white
        }
        currencyLabel.use {
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: 18)
            $0.textColor = sharedAppColor
            $0.textColor = .white
        }
        thisMonthLabel.use {
            $0.textAlignment = .left
            $0.textColor = .white
        }
    }
}
