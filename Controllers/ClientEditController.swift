//
// Created by Mihael Bercic on 26/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class ClientEditController: CUIViewController, ViewSetup {

    // Properties
    var onDismiss = {}
    let selectedClientProperty = Observable<Client?>(nil)

    // Views
    private let clientRateView  = ClientRateView()
    private let nameTextField   = UITextField()
    private let stackView       = UIStackView()
    private let bottomStackView = UIStackView()
    private let saveButton      = ActionButton()
    private let deleteButton    = ActionButton()

    // Alerts
    private let refreshAlert    = UIAlertController(title: "Is u sure?", message: "Your client and entries related to the client will be removed.", preferredStyle: .alert)

}

// Custom
extension ClientEditController: UITextFieldDelegate {

    private func save() {
        selectedClientProperty.value?.use {
            $0.name = nameTextField.text ?? ""
            $0.rate = clientRateView.rate.asNSNumber
            $0.currency = clientRateView.currency.asNSNumber
        }
        onDismiss()
        sharedDataManager.saveContext()
        sharedClientsProperty.value = []
        sharedClientsProperty.value = loadStoredClients
        dismiss(animated: true)
    }

    private func delete() {
        if currentEntry != nil && currentEntry?.client == selectedClientProperty.value {
            print("LOL NO")
            return
        }
        present(refreshAlert, animated: true)
    }

    func createNewClient() {
        selectedClientProperty.value = Client(context: sharedDataManager.context).apply {
            $0.name = "Name"
            $0.rate = 0
            $0.currency = Currency.euro.asNSNumber
            $0.color = randomFlatColor
            $0.timeRound = 0
        }

        selectedClientProperty.value?.use {
            nameTextField.text = $0.name
            nameTextField.backgroundColor = UIColor(hex: $0.color)
            nameTextField.becomeFirstResponder()
            nameTextField.selectAll(nil)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


}

// On Init
extension ClientEditController {
    func onInit() {
        clientRateView.clientProperty.bind(to: selectedClientProperty)
        selectedClientProperty.setOnChange {
            $0?.use {
                self.nameTextField.text = $0.name
                self.nameTextField.backgroundColor = UIColor(hex: $0.color)
            }
        }
        nameTextField.delegate = self
        view.backgroundColor = .systemBackground

        saveButton.onTap { self.save() }
        deleteButton.onTap { self.delete() }
    }
}

// Hierarchy
extension ClientEditController {
    func setHierarchy() {
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        view.addSubview(nameTextField)
        stackView.addArrangedSubview(clientRateView)
        bottomStackView.addArrangedSubview(deleteButton)
        bottomStackView.addArrangedSubview(saveButton)

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.selectedClientProperty.value?.use { client in
                loadStoredEntries.filter { entry in entry.client == client }.forEach { sharedDataManager.context.delete($0) }
                sharedDataManager.context.delete(client)
            }
            self.onDismiss()
            self.dismiss(animated: true)
            sharedDataManager.saveContext()
            timeElapsedProperty.value = -1
            timeElapsedProperty.value = 0
        }))
    }
}

// Subviews
extension ClientEditController {
    func modifySubviews() {
        nameTextField.use {
            $0.font = .preferredFont(forTextStyle: .headline)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.returnKeyType = .done
        }

        stackView.use {
            $0.axis = .vertical
            $0.spacing = 10
        }
        bottomStackView.use {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .center
            $0.distribution = .equalCentering
        }
        saveButton.use { $0.setTitle("Save", for: .normal) }
        deleteButton.use { $0.setTitle("Delete", for: .normal); $0.setTitleColor(.systemRed, for: .normal) }
    }
}

// Constraints
extension ClientEditController {
    func setConstraints() {
        nameTextField.connect {
            $0.topAnchor = view.topAnchor
            $0.heightConstant = 150
            $0.leftAnchor = view.leftAnchor
            $0.rightAnchor = view.rightAnchor
        }

        stackView.connect {
            $0.topAnchor = nameTextField.bottomAnchor
            $0.topConstant = 10
            $0.leftAnchor = view.leftAnchor
            $0.rightAnchor = view.rightAnchor
        }

        clientRateView.connect {
            $0.leftAnchor = view.leftAnchor
            $0.rightAnchor = view.rightAnchor
            $0.topAnchor = stackView.topAnchor
            $0.heightConstant = 40
        }

        bottomStackView.connect {
            $0.bottomConstant = -20
            $0.rightConstant = -20
            $0.leftConstant = 20
            $0.rightAnchor = view.rightAnchor
            $0.leftAnchor = view.leftAnchor
            $0.bottomAnchor = view.bottomAnchor
        }
    }
}