//
// Created by Mihael Bercic on 01/01/2020.
// Copyright (c) 2020 Regnum d.o.o. All rights reserved.
//

import UIKit

let timeElapsedProperty = Observable<TimeInterval>(0)

class OverviewController: CUIViewController, ViewSetup {

    // Constants
    private let currentTimeLabel     = UILabel()
    private let currentEarningsLabel = UILabel()
    private let clientAndRateLabel   = UILabel()
    private let verticalStackView    = UIStackView()
    private let clockInButton        = ActionButton()

    private let todayDashboard    = DashboardPanel()
    private let earningsTableView = EarningsTableView()
    private let clockInController = ClockInController()

    // Observable properties
    private let clientProperty    = Observable<Client?>(nil)

    // On dark/light mode change...
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        clockInButton.layer.borderColor = UIColor.systemGray6.cgColor
    }

}

// Custom
extension OverviewController {
    @objc func onMoreTap() {
        earningsTableView.refresh()
    }
}

// Setup
extension OverviewController {
    func onInit() {
        clientProperty.bindBiDirectionally(with: clockInController.clientProperty)
        timeElapsedProperty.bindBiDirectionally(with: clockInController.timeProperty)
        todayDashboard.timeProperty.bind(to: timeElapsedProperty)
        clockInButton.onTap {
            if loadStoredClients.count == 0 {
                (self.parent as? SwipeApplicationController)?.use { $0.scrollToPage(1) }
                return
            }

            let controller = self.clockInController
            let isFinished = currentEntry != nil

            // Ternary
            isFinished ? controller.onClockOut() : { controller.updateData(); self.present(controller, animated: true) }()
        }

        clientProperty.setOnChange { client in
            self.clockInButton.setTitle(client == nil ? "Clock in" : "Clock out", for: .normal)
            self.clientAndRateLabel.text = "Not on the clock"
            if let client = client {
                let rate = client.rate.intValue.asDecimal.dividing(by: 100)
                self.clientAndRateLabel.text = "\(client.name) at \(decimalFormatter.string(from: rate) ?? "") \(client.formattedCurrency) / hr"
            }
        }

        timeElapsedProperty.setOnChange { timeInterval in
            self.currentTimeLabel.layer.opacity = timeInterval == 0 ? 0.5 : 1
            self.currentTimeLabel.text = currentTimeFormatter.string(from: timeInterval)
            self.clientProperty.value?.use { client in
                let perSecond = client.rate.intValue.asDecimal.dividing(by: 3600)
                let earned    = timeInterval.asDecimal.multiplying(by: perSecond).dividing(by: 100)
                self.currentEarningsLabel.text = timeInterval == 0 ? nil : "\(decimalFormatter.string(from: earned) ?? "") \(client.formattedCurrency)"
            }
        }
    }
}

// Hierarchy
extension OverviewController {
    func setHierarchy() {
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(todayDashboard)
        verticalStackView.addArrangedSubview(currentTimeLabel)
        view.addSubview(currentEarningsLabel)
        view.addSubview(clientAndRateLabel)
        view.addSubview(clockInButton)
        view.addSubview(earningsTableView)
    }
}

// Constraints
extension OverviewController {
    func setConstraints() {
        verticalStackView.connect {
            $0.topAnchor = view.safeAreaLayoutGuide.topAnchor
            $0.leftAnchor = view.safeAreaLayoutGuide.leftAnchor
            $0.rightAnchor = view.safeAreaLayoutGuide.rightAnchor
            $0.topConstant = 30
            $0.leftConstant = 30
            $0.rightConstant = -30
        }

        currentTimeLabel.connect { $0.bottomAnchor = clockInButton.topAnchor }
        clientAndRateLabel.connect {
            $0.centerYAnchor = currentTimeLabel.centerYAnchor
            $0.leftAnchor = view.leftAnchor
            $0.rightAnchor = view.rightAnchor
            $0.heightConstant = 80
            $0.centerYConstant = -30
        }
        currentEarningsLabel.connect {
            $0.centerYAnchor = currentTimeLabel.centerYAnchor
            $0.leftAnchor = view.leftAnchor
            $0.rightAnchor = view.rightAnchor
            $0.heightConstant = 80
            $0.centerYConstant = 30
        }
        clockInButton.connect {
            $0.heightConstant = 50
            $0.widthConstant = 150
            $0.centerXAnchor = view.centerXAnchor
            $0.bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
            $0.bottomConstant = -70
        }
        earningsTableView.connect {
            $0.topAnchor = todayDashboard.bottomAnchor
            $0.widthAnchor = todayDashboard.widthAnchor
            $0.centerXAnchor = todayDashboard.centerXAnchor
            $0.topConstant = -10
        }
    }
}

// Subviews
extension OverviewController {
    func modifySubviews() {
        verticalStackView.use {
            $0.spacing = 20
            $0.axis = .vertical
        }

        currentTimeLabel.use {
            $0.textAlignment = .center
            $0.font = .monospacedDigitSystemFont(ofSize: 30, weight: .bold)
            $0.adjustsFontSizeToFitWidth = true
            $0.text = "00:00:00"
            $0.layer.opacity = 0.5
        }

        clientAndRateLabel.use {
            $0.font = .boldSystemFont(ofSize: 16)
            $0.textColor = sharedAppColor
            $0.textAlignment = .center
            $0.text = "Not on the clock"
        }

        currentEarningsLabel.use {
            $0.font = .boldSystemFont(ofSize: 13)
            $0.textColor = sharedAppColor
            $0.textAlignment = .center
        }

        clockInButton.use {
            $0.setTitle("Clock In", for: .normal)
            $0.setTitleColor(.label, for: .normal)
            $0.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.7)
            $0.layer.borderWidth = 2
            $0.titleLabel?.font = .boldSystemFont(ofSize: 17)
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.systemGray6.cgColor
        }

        clockInController.checkForLast()

        todayDashboard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMoreTap)))

    }
}