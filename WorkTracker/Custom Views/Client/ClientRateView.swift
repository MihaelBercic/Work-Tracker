//
// Created by Mihael Bercic on 27/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class ClientRateView: CUIView, ViewSetup {

    // Variables
    var rate:     Int { get { rateTextField.cents } }
    var currency: Currency { get { currencyPicker.selectedCurrency } }

    // Constants
    let clientProperty = Observable<Client?>(nil)
    private let currencyPicker = CurrencyPicker()
    private let rateTextField  = CashRateField()
    private let stackView      = UIStackView()
    private let label          = UILabel()

}

// Custom
extension ClientRateView {
    private func displayData(_ client: Client) {
        currencyPicker.selectCurrency(client)
        rateTextField.setRate(client.rate.intValue)
    }
}

// On Init
extension ClientRateView {
    func onInit() {
        backgroundColor = .systemBackground
        clientProperty.setOnChange { if let client = $0 { self.displayData(client) } }
    }
}

// Hierarchy
extension ClientRateView {
    func setHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(rateTextField)
        stackView.addArrangedSubview(currencyPicker)
    }
}

// Constraints
extension ClientRateView {
    func setConstraints() {
        stackView.connect {
            $0.topAnchor = topAnchor
            $0.leftAnchor = leftAnchor
            $0.rightAnchor = rightAnchor
            $0.bottomAnchor = bottomAnchor
            $0.leftConstant = 10
        }

        rateTextField.connect { $0.widthConstant = 150; $0.topAnchor = stackView.topAnchor; $0.bottomAnchor = stackView.bottomAnchor }
        currencyPicker.connect { $0.widthConstant = 50; $0.topAnchor = stackView.topAnchor; $0.bottomAnchor = stackView.bottomAnchor }
    }
}

// Subviews
extension ClientRateView {
    func modifySubviews() {
        stackView.use {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
        }
        label.use {
            $0.text = "Rate per hour"
            $0.font = .preferredFont(forTextStyle: .callout)
        }
    }
}