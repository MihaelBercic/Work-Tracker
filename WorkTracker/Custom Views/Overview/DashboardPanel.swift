//
// Created by Mihael Bercic on 29/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit


class DashboardPanel: CUIView, ViewSetup {

    // Observable
    let timeProperty = Observable<TimeInterval>(0) { x in print("HEHE THIS WAS CHANGED") }

    // Views
    private let todayLabel                    = UILabel()
    private let mainStackView                 = UIStackView()
    private let thisMonthLabel                = UILabel()
    private let hoursTodayLabel               = UILabel()
    private let tapForMoreLabel               = UILabel()
    private let hoursThisMonthLabel           = UILabel()
    private let firstVerticalStackView        = UIStackView()
    private let secondVerticalStackView       = UIStackView()

    // Variables
    private var storedTodayTime: TimeInterval = 0
    private var storedMonthTime: TimeInterval = 0

    private var calculatedToday: TimeInterval {
        loadStoredEntries.filter { $0.stop != nil && $0.start.isInToday }.reduce(0) { (x, y) in
            x + y.start.distance(to: y.stop!)
        }
    }
    private var calculatedMonth: TimeInterval {
        loadStoredEntries.filter { $0.stop != nil && $0.start.isInThisMonth }.reduce(0) { (x, y) in
            x + y.start.distance(to: y.stop!)
        }
    }


}

// Custom
extension DashboardPanel {
    private func updateCalculatedValues() {
        storedTodayTime = calculatedToday
        storedMonthTime = calculatedMonth
    }
}

// On Init
extension DashboardPanel {
    func onInit() {
        backgroundColor = sharedAppColor
        layer.cornerRadius = 5

        timeProperty.setOnChange { interval in
            if interval <= 0 { self.updateCalculatedValues() }
            self.hoursTodayLabel.text = totalTimeFormatter.string(from: interval + self.storedTodayTime)
            self.hoursThisMonthLabel.text = totalTimeFormatter.string(from: interval + self.storedMonthTime)
        }
        updateCalculatedValues()
        hoursTodayLabel.text = totalTimeFormatter.string(from: storedTodayTime)
        hoursThisMonthLabel.text = totalTimeFormatter.string(from: storedMonthTime)
    }
}

// Hierarchy
extension DashboardPanel {
    func setHierarchy() {
        addSubview(mainStackView)
        addSubview(tapForMoreLabel)
        mainStackView.addArrangedSubview(firstVerticalStackView)
        mainStackView.addArrangedSubview(secondVerticalStackView)
        // First - Today
        firstVerticalStackView.addArrangedSubview(todayLabel)
        firstVerticalStackView.addArrangedSubview(hoursTodayLabel)

        // Second . This Month
        secondVerticalStackView.addArrangedSubview(thisMonthLabel)
        secondVerticalStackView.addArrangedSubview(hoursThisMonthLabel)
    }
}

// Constraints
extension DashboardPanel {
    func setConstraints() {
        connect { $0.heightConstant = 80 }
        mainStackView.connect {
            $0.topAnchor = topAnchor
            $0.leftAnchor = leftAnchor
            $0.rightAnchor = rightAnchor
            $0.bottomAnchor = bottomAnchor
            $0.topConstant = 10
            $0.leftConstant = 10
            $0.rightConstant = -10
            $0.bottomConstant = -10
        }

        tapForMoreLabel.connect {
            $0.leftAnchor = leftAnchor
            $0.rightAnchor = rightAnchor
            $0.bottomAnchor = bottomAnchor
            $0.bottomConstant = 20
        }


    }
}

// Subviews
extension DashboardPanel {
    func modifySubviews() {
        todayLabel.use {
            $0.textColor = UIColor.white.withAlphaComponent(0.7)
            $0.font = .systemFont(ofSize: UIFont.smallSystemFontSize, weight: .bold)
            $0.textAlignment = .center
            $0.text = "TODAY"
        }
        thisMonthLabel.use {
            $0.textColor = todayLabel.textColor
            $0.font = todayLabel.font
            $0.textAlignment = .center
            $0.text = "THIS MONTH"
        }

        hoursTodayLabel.use {
            $0.textColor = .white
            $0.textAlignment = .center
        }
        hoursThisMonthLabel.use {
            $0.textColor = .white
            $0.textAlignment = .center
        }

        firstVerticalStackView.use {
            $0.axis = .vertical
            $0.distribution = .fillEqually
        }

        secondVerticalStackView.use {
            $0.axis = .vertical
            $0.distribution = .fillEqually
        }

        mainStackView.use {
            $0.spacing = 10
            $0.distribution = .fillEqually
        }

        tapForMoreLabel.use {
            $0.text = "Tap for more"
            $0.font = todayLabel.font
            $0.textColor = sharedAppColor
            $0.textAlignment = .center
        }
    }
}