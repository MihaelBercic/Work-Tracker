//
// Created by Mihael Bercic on 10/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class EarningsTableView: CUITableView, ViewSetup {

    private var todayData:             [(Int, Int)] = []
    private var thisMonthData:         [(Int, Int)] = []
    private var totalCurrenciesEarned: [Int]        = []
    private var heightConstraint:      NSLayoutConstraint?
    private let rowTallness:           CGFloat      = 70

}

// Custom
extension EarningsTableView {

    func show() {
        let constant = (heightConstraint?.constant ?? 0) > 0 ? 0 : rowTallness * CGFloat(totalCurrenciesEarned.count)
        if heightConstraint == nil { heightConstraint = heightAnchor.constraint(equalToConstant: constant) }
        heightConstraint!.constant = constant
        heightConstraint!.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
    }

    func refresh() {
        let entries: [Entry] = loadStoredEntries
        let entriesToday = entries.filter { $0.start.isInToday }
        let entriesThisMonth = entries.filter { $0.start.isInThisMonth }

        // Grouped
        let groupedByCurrencyToday: Dictionary<Int, [Entry]> = Dictionary(grouping: entriesToday, by: { $0.client.currencyAsInt })
        let groupedByCurrencyThisMonth = Dictionary(grouping: entriesThisMonth, by: { $0.client.currencyAsInt })

        totalCurrenciesEarned = Array(Set(entries.map { $0.client.currencyAsInt })).sorted { (first: Int, second: Int) in first < second }
        todayData = groupedByCurrencyToday
                .mapValues { entries -> Int in entries.reduce(0) { x, y in x + y.earningsInCents } }
                .sorted { tuple, tuple2 in tuple.key < tuple2.key }

        thisMonthData = groupedByCurrencyThisMonth
                .mapValues { entries -> Int in entries.reduce(0) { x, y in x + y.earningsInCents } }
                .sorted { tuple, tuple2 in tuple.key < tuple2.key }

        reloadData()
        show()
    }
}

// On Init
extension EarningsTableView {
    func onInit() {
        register(EarningCell.self, forCellReuseIdentifier: "EarningCell")
        delegate = self
        dataSource = self
        allowsSelection = false
        layer.cornerRadius = 5
        separatorColor = .clear
    }
}

// Delegate
extension EarningsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalCurrenciesEarned.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = dequeueReusableCell(withIdentifier: "EarningCell") as! EarningCell
        let index = indexPath.item
        let todayEarnings = todayData.filter { $0.0 == index }.first?.1 ?? 0
        let thisMonthEarnings = thisMonthData.filter { $0.0 == index }.first?.1 ?? 0
        let currencyCharacter = currencyValueOf(totalCurrenciesEarned[index]).asCharacter
        cell.display(today: todayEarnings, currency: currencyCharacter, thisMonth: thisMonthEarnings)
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowTallness
    }
}