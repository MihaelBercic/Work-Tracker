//
// Created by Mihael Bercic on 04/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class ClientSelectionCollectionView: CUICollectionView, ViewSetup {

    // Variables
    private var clients:  [Client]     = []

    // Constants
    private let cellSize: CGSize       = CGSize(width: 80, height: 100)
    private let insets:   UIEdgeInsets = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)

}

// Custom
extension ClientSelectionCollectionView {

    var selectedClient: Client? {
        let selectedIndex: Int = indexPathsForSelectedItems?.first?.item ?? -1
        return selectedIndex == -1 ? nil : clients[selectedIndex]
    }

    func updateData() {
        clients = loadStoredClients
        reloadData()
    }

}

// OnInit
extension ClientSelectionCollectionView {
    func onInit() {
        register(ClientCollectionViewCell.self, forCellWithReuseIdentifier: "ClientCollectionCell")
        backgroundColor = .systemBackground
        delegate = self
        dataSource = self
    }
}

// Delegate
extension ClientSelectionCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        clients.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (dequeueReusableCell(withReuseIdentifier: "ClientCollectionCell", for: indexPath) as! ClientCollectionViewCell).apply {
            $0.setClient(client: clients[indexPath.item])
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        insets
    }
}
