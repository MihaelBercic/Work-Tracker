//
// Created by Mihael Bercic on 27/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class CurrencyPicker: CUITextField, ViewSetup, UIPickerViewDelegate, UIPickerViewDataSource {

    private let pickerView = UIPickerView()

    override func didMoveToSuperview() { text = String(Currency.euro.asCharacter) }

    var selectedCurrency: Currency { get { currencyValueOf(pickerView.selectedRow(inComponent: 0)) } }
}

// Custom
extension CurrencyPicker {
    func selectCurrency(_ client: Client) {
        let currency = currencyValueOf(client.currencyAsInt)
        text = String(currency.asCharacter)
        textColor = UIColor(hex: client.color)
        pickerView.selectRow(currency.rawValue, inComponent: 0, animated: false)
    }
}

// On Init
extension CurrencyPicker {
    func onInit() {
        textColor = .systemTeal
        textAlignment = .center
        tintColor = .clear
        inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        autocorrectionType = .no
        addDoneButtonOnKeyboard()
    }
}

// Delegate
extension CurrencyPicker {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { text = String(currencyValueOf(row).asCharacter) }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { allCurrencies.count }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { String(currencyValueOf(row).asCharacter) }

}
