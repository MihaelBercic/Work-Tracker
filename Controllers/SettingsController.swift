//
// Created by Mihael Bercic on 25/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class SettingsController: CUIViewController, ViewSetup {

    // Controllers
    private let editClientController   = ClientEditController()
    private let entriesController      = EntryViewController()

    // Components
    private let addNewClientButton     = ActionButton()
    private let clientsTableView       = ClientsTableView()
    private let titleLabel             = UILabel()
    private let noClientsLabel         = UILabel()
    private let segmentedControl       = UISegmentedControl(items: ["Settings", "Entries"])
    private let selectedClientProperty = Observable<Client?>(nil)

}

// Custom
extension SettingsController {
    func setupData() {
        sharedClientsProperty.value = loadStoredClients
        let clients = sharedClientsProperty.value
        noClientsLabel.isHidden = clients.count != 0
        clientsTableView.setupData(clients)
    }
}

// On Init
extension SettingsController {
    func onInit() {
        clientsTableView.register(ClientCellView.self, forCellReuseIdentifier: "ClientCellView")
        editClientController.onDismiss = { self.setupData() }
        clientsTableView.onClientSelection = { client in
            let isSettings = self.segmentedControl.selectedSegmentIndex == 0
            self.selectedClientProperty.value = client
            self.present(isSettings ? self.editClientController : self.entriesController, animated: true)
        }
    }
}

// Hierarchy
extension SettingsController {
    func setHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(clientsTableView)
        view.addSubview(addNewClientButton)
        view.addSubview(noClientsLabel)
        setupData()
    }
}

// Constraints
extension SettingsController {
    func setConstraints() {

        titleLabel.connect {
            $0.topAnchor = view.topAnchor
            $0.leftAnchor = view.leftAnchor
            $0.rightAnchor = view.rightAnchor
            $0.heightConstant = 60
            $0.topConstant = 20
        }

        segmentedControl.connect {
            $0.topAnchor = titleLabel.bottomAnchor
            $0.centerXAnchor = view.centerXAnchor
            $0.widthConstant = 150
        }

        clientsTableView.connect {
            $0.topAnchor = segmentedControl.bottomAnchor
            $0.leftAnchor = view.leftAnchor
            $0.rightAnchor = view.rightAnchor
            $0.bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
            $0.topConstant = 20
        }

        addNewClientButton.connect {
            $0.bottomAnchor = view.bottomAnchor
            $0.rightAnchor = view.rightAnchor
            $0.rightConstant = -40
            $0.bottomConstant = -20
            $0.heightConstant = 40
            $0.widthConstant = 40
        }

        noClientsLabel.connect {
            $0.topAnchor = segmentedControl.bottomAnchor
            $0.leftAnchor = view.leftAnchor
            $0.rightAnchor = view.rightAnchor
            $0.heightConstant = 100
        }


    }
}

// Subviews
extension SettingsController {
    func modifySubviews() {
        editClientController.selectedClientProperty.bind(to: selectedClientProperty)
        entriesController.selectedClientProperty.bind(to: selectedClientProperty)

        noClientsLabel.use {
            $0.text = "You do not have any clients yet. \nAdd one below +"
            $0.numberOfLines = 0
            $0.textColor = sharedAppColor.withAlphaComponent(0.9)
            $0.textAlignment = .center
        }
        titleLabel.use {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "On select display:"
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: $0.font.pointSize)
        }
        addNewClientButton.use {
            $0.backgroundColor = sharedAppColor
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.tintColor = .white
            $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowRadius = 0.5
            $0.layer.masksToBounds = false
            $0.setImage(UIImage(systemName: "plus"), for: .normal)
            $0.onTap {
                let controller = self.editClientController
                controller.createNewClient()
                self.present(controller, animated: true)
            }
        }
        segmentedControl.selectedSegmentIndex = 0
    }
}