//
// Created by Mihael Bercic on 06/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class MonthGroupCollectionView: CUICollectionView, ViewSetup {

    // Variables
    var onMonthSelection: ([Entry]) -> () = { x in print("\(x) has been selected.") }
    private var keys:       [String]                    = []
    private var grouped:    Dictionary<String, [Entry]> = Dictionary()

    // Customization
    private let cellSize:   CGSize                      = CGSize(width: 80, height: 80)
    private let edgeInsets: UIEdgeInsets                = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)

    func onInit() {
        register(MonthGroupCollectionCell.self, forCellWithReuseIdentifier: "MGCCell")
        backgroundColor = .systemBackground
        delegate = self
        dataSource = self
    }

    func setData(grouped: Dictionary<String, [Entry]>) {
        self.grouped = grouped
        keys = grouped.keys.sorted().reversed()
        reloadData()
    }


}

extension MonthGroupCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let monthSelected = keys[indexPath.item]
        grouped[monthSelected]?.use { self.onMonthSelection($0) }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        keys.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (dequeueReusableCell(withReuseIdentifier: "MGCCell", for: indexPath) as! MonthGroupCollectionCell).apply {
            $0.label.text = keys[indexPath.item]
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        edgeInsets
    }
}
