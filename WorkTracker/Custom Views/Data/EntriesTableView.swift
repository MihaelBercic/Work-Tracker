//
// Created by Mihael Bercic on 06/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class EntriesTableView: CUITableView, ViewSetup {

    let entriesProperty: Observable<[Entry]> = Observable<[Entry]>([])
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .heavy)

    func onInit() {
        register(EntryTableCell.self, forCellReuseIdentifier: "EntryTableCell")
        delegate = self
        dataSource = self
        separatorColor = .clear
        allowsSelection = false
        entriesProperty.setOnChange { _ in self.reloadData() }
    }
}

extension EntriesTableView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { action, view, closure in
            var entries: [Entry] = self.entriesProperty.value
            let entry:   Entry   = entries.remove(at: indexPath.item)
            self.entriesProperty.value = entries
            self.hapticGenerator.impactOccurred()
            sharedDataManager.context.delete(entry)
            sharedDataManager.saveContext()
            timeElapsedProperty.value = -1
            timeElapsedProperty.value = 0

        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entriesProperty.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        (dequeueReusableCell(withIdentifier: "EntryTableCell") as! EntryTableCell).apply {
            $0.displayEntry(entry: entriesProperty.value[indexPath.item])
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

}
