//
// Created by Mihael Bercic on 26/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class ClientCellView: CUITableViewCell, UITableViewDelegate, ViewSetup {

    private let stackView       = UIStackView()
    private let iconView        = ClientCircularView()
    private let clientNameLabel = UILabel()
    private let clientRateLabel = UILabel()

}

// Custom
extension ClientCellView {
    func setClient(_ client: Client) {
        iconView.setup(client, clientSize: 50)
        clientNameLabel.text = client.name
        clientRateLabel.text = "\(client.formattedRate) \(client.formattedCurrency) / h"
    }
}

// On Init
extension ClientCellView {
    func onInit() { selectionStyle = .none }
}

// Hierarchy
extension ClientCellView {
    func setHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(clientNameLabel)
        stackView.addArrangedSubview(clientRateLabel)
    }
}

// Constraints
extension ClientCellView {
    func setConstraints() {
        iconView.connect { $0.centerYAnchor = stackView.centerYAnchor }
        stackView.connect {
            $0.topAnchor = topAnchor
            $0.leftAnchor = leftAnchor
            $0.bottomAnchor = bottomAnchor
            $0.leftConstant = 20
            $0.rightConstant = -20
        }
        clientRateLabel.connect {
            $0.rightAnchor = rightAnchor
            $0.rightConstant = -20
        }
    }
}

// Subviews
extension ClientCellView {
    func modifySubviews() {
        stackView.use {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.alignment = .center
            $0.axis = .horizontal
            $0.spacing = 10
        }
        iconView.use { $0.translatesAutoresizingMaskIntoConstraints = false }
        clientRateLabel.use { $0.textAlignment = .right; $0.font = .boldSystemFont(ofSize: $0.font.pointSize - 1) }
    }
}