//
// Created by Mihael Bercic on 05/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class EntryViewController: CUIViewController, ViewSetup {

    // Views
    private let titleLabel                                       = UILabel()
    private let noEntriesLabel                                   = UILabel()
    private let toggleBar                                        = UISegmentedControl(items: ["Grouped", "List"])
    private let entriesTableView                                 = EntriesTableView()
    private let tapToCloseButton                                 = ActionButton()
    private let monthCollectionView                              = MonthGroupCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
    private let entriesProperty                                  = Observable<[Entry]>([])

    // Constraints
    private var listViewTopConstraint:       NSLayoutConstraint? = nil
    private var closeButtonBottomConstraint: NSLayoutConstraint? = nil

    // Observable
    let selectedClientProperty = Observable<Client?>(nil)

    func onInit() {
        view.backgroundColor = .systemBackground
        entriesProperty.bindBiDirectionally(with: entriesTableView.entriesProperty)
        entriesProperty.setOnChange { self.noEntriesLabel.isHidden = $0.count != 0 }

        selectedClientProperty.setOnChange {
            $0?.use {
                self.showFullScreenPreview(show: false)
                self.titleLabel.text = $0.name
                self.onTap(self.toggleBar)
            }
        }
    }
}

// Custom
extension EntryViewController {

    private func findEntriesForClient(client: Client) -> [Entry] {
        loadStoredEntries.filter { entry in entry.stop != nil && entry.client == client }
    }

    @objc func onTap(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
        monthCollectionView.isHidden = value != 0
        listViewTopConstraint?.isActive = value == 1
        selectedClientProperty.value?.use {
            let entries = findEntriesForClient(client: $0)
            let grouped = Dictionary(grouping: entries, by: { groupDateFormatter.string(from: $0.start) })
            entriesProperty.value = entries.reversed()
            monthCollectionView.setData(grouped: grouped)

        }
    }

    private func showFullScreenPreview(show: Bool) {
        self.listViewTopConstraint?.isActive = show
        self.closeButtonBottomConstraint?.isActive = show
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
            self.tapToCloseButton.alpha = show ? 1 : 0
            self.view.layoutIfNeeded()
        })
    }

}

// Hierarchy
extension EntryViewController {
    func setHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(toggleBar)
        view.addSubview(monthCollectionView)

        view.addSubview(tapToCloseButton)
        view.addSubview(entriesTableView)
        view.addSubview(noEntriesLabel)
    }
}

// Constraints
extension EntryViewController {
    func setConstraints() {
        titleLabel.connect {
            $0.topAnchor = view.safeAreaLayoutGuide.topAnchor
            $0.leftAnchor = view.safeAreaLayoutGuide.leftAnchor
            $0.rightAnchor = view.safeAreaLayoutGuide.rightAnchor
            $0.heightConstant = 100
        }

        noEntriesLabel.connect {
            $0.topAnchor = toggleBar.bottomAnchor
            $0.centerXAnchor = view.safeAreaLayoutGuide.centerXAnchor
            $0.heightConstant = 100
        }

        tapToCloseButton.connect {
            $0.topAnchor = view.safeAreaLayoutGuide.topAnchor
            $0.leftAnchor = view.safeAreaLayoutGuide.leftAnchor
            $0.rightAnchor = view.safeAreaLayoutGuide.rightAnchor
        }

        toggleBar.connect {
            $0.topAnchor = titleLabel.bottomAnchor
            $0.centerXAnchor = view.centerXAnchor
        }

        monthCollectionView.connect {
            $0.topAnchor = toggleBar.bottomAnchor
            $0.leftAnchor = view.safeAreaLayoutGuide.leftAnchor
            $0.rightAnchor = view.safeAreaLayoutGuide.rightAnchor
            $0.bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }

        entriesTableView.connect {
            $0.leftAnchor = view.safeAreaLayoutGuide.leftAnchor
            $0.rightAnchor = view.safeAreaLayoutGuide.rightAnchor
            $0.bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }

        if listViewTopConstraint == nil {
            listViewTopConstraint = entriesTableView.topAnchor.constraint(equalTo: toggleBar.bottomAnchor)
            closeButtonBottomConstraint = tapToCloseButton.bottomAnchor.constraint(equalTo: toggleBar.bottomAnchor)

            listViewTopConstraint?.constant = 40
            closeButtonBottomConstraint?.constant = 40
        }
    }
}

// Subviews
extension EntryViewController {
    func modifySubviews() {
        toggleBar.selectedSegmentIndex = 0
        toggleBar.addTarget(self, action: #selector(onTap), for: .valueChanged)

        titleLabel.use {
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: $0.font.pointSize)
        }
        noEntriesLabel.use {
            $0.text = "No entries yet."
            $0.textAlignment = .center
            $0.textColor = sharedAppColor
        }
        tapToCloseButton.use {
            $0.setTitle("Tap to exit fullscreen", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = sharedAppColor
            $0.layer.cornerRadius = 5
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.onTap { self.showFullScreenPreview(show: false) }
            $0.alpha = 0
        }
        monthCollectionView.onMonthSelection = {
            self.entriesProperty.value = $0.reversed()
            self.showFullScreenPreview(show: true)
        }
    }
}



