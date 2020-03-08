//
// Created by Mihael Bercic on 26/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class ClientsTableView: CUITableView {

    var onClientSelection: (Client) -> () = { _ in }

    private var clients: [Client] = [Client]()

}

// On Init
extension ClientsTableView {
    func onInit() {
        dataSource = self
        delegate = self
        rowHeight = 80
        separatorStyle = .none
    }
}

// Custom
extension ClientsTableView {
    func clearData() {
        clients.removeAll()
        reloadData()
    }

    func setupData(_ clients: [Client]) {
        self.clients.removeAll()
        self.clients += clients
        reloadData()
    }
}

// Delegate
extension ClientsTableView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { clients.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        (dequeueReusableCell(withIdentifier: "ClientCellView") as! ClientCellView).apply {
            $0.setClient(clients[indexPath.item])
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: false)
        onClientSelection(clients[indexPath.item])
    }

}
