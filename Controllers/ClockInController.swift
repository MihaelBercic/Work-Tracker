//
// Created by Mihael Bercic on 04/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

// Variables
var currentEntry: Entry?

class ClockInController: CUIViewController, ViewSetup {

    var timer: Timer?

    // Observable properties
    let clientProperty = Observable<Client?>(nil)
    let timeProperty = Observable<TimeInterval>(0)

    // Constants
    let mainStackView = UIStackView()
    let selectTitleLabel = UILabel()
    let datePicker = DatePicker()
    let startButton = ActionButton()
    let alert = UIAlertController(title: "Oi!", message: "Please select your client", preferredStyle: .actionSheet)
    let clientsCollectionView = ClientSelectionCollectionView(collectionViewLayout: UICollectionViewFlowLayout())

    func onInit() {
        view.backgroundColor = .systemBackground
    }

}

// Custom
extension ClockInController {

    func checkForLast() {
        let lastEntry = loadStoredEntries.last
        let isUnfinished = lastEntry != nil && lastEntry!.stop == nil
        if isUnfinished {
            currentEntry = lastEntry
            clientProperty.value = lastEntry?.client
            startTimer()
        }
    }

    func updateData() {
        datePicker.selectNow()
        clientsCollectionView.updateData()
    }

    func onClockIn() {
        let selectedDate = datePicker.selectedDate

        clientsCollectionView.selectedClient?.use { client in
            currentEntry = Entry(context: sharedDataManager.context).apply {
                $0.client = client
                $0.start = selectedDate
            }
            clientProperty.value = client
            sharedDataManager.saveContext()

            startTimer()
            dismiss(animated: true)
        } ?? present(alert, animated: true)
    }

    func onClockOut() {
        currentEntry?.use { $0.stop = Date() }
        sharedDataManager.saveContext()
        currentEntry = nil
        timer?.invalidate()
        timeProperty.value = 0
        clientProperty.value = nil
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTick), userInfo: nil, repeats: true)
    }

    @objc private func onTick() {
        currentEntry?.use { entry in
            let interval = entry.start.distance(to: Date())
            timeProperty.value = interval
        }
    }
}

// Hierarchy
extension ClockInController {
    func setHierarchy() {
        view.addSubview(mainStackView)
        view.addSubview(startButton)
        mainStackView.addArrangedSubview(selectTitleLabel)
        mainStackView.addArrangedSubview(clientsCollectionView)
        mainStackView.addArrangedSubview(datePicker)
    }
}

// Modifying
extension ClockInController {
    func modifySubviews() {
        mainStackView.use { $0.axis = .vertical }

        // Set alert
        alert.addAction(UIAlertAction(title: "Okay!", style: .default))
        for subview in alert.view.subviews {
            for constraint in subview.constraints where constraint.debugDescription.contains("width == - 16") {
                subview.removeConstraint(constraint)
            }
        }

        selectTitleLabel.use {
            $0.text = "Select your client"
            $0.font = .boldSystemFont(ofSize: 16)
            $0.textAlignment = .center
        }

        startButton.use {
            $0.setTitle("Start", for: .normal)
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 5
            $0.onTap { self.onClockIn() }
        }
    }
}

// Constraints
extension ClockInController {
    func setConstraints() {
        mainStackView.connect {
            $0.topAnchor = view.topAnchor
            $0.leftAnchor = view.leftAnchor
            $0.rightAnchor = view.rightAnchor
        }

        selectTitleLabel.connect { $0.heightConstant = 100 }
        datePicker.connect {
            $0.bottomAnchor = startButton.topAnchor
            $0.bottomConstant = -20
            $0.heightConstant = 80
        }

        startButton.connect {
            $0.bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
            $0.bottomConstant = -20
            $0.widthConstant = 70
            $0.heightConstant = 40
            $0.centerXAnchor = view.safeAreaLayoutGuide.centerXAnchor
        }
    }
}