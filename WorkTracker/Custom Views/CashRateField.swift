//
// Created by Mihael Bercic on 28/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class CashRateField: CUITextField {

    var cents: Int = 0
    private var lastNumber: Int { get { Int(String((text ?? "").last!)) ?? 0 } }

}

// Custom
extension CashRateField {

    func setRate(_ cents: Int) {
        self.cents = cents
        text = decimalFormatter.string(from: cents.asDecimal.dividing(by: 100.asDecimal))
    }

    @objc private func onEdit() { setRate(cents * 10 + lastNumber) }

}

// On Init
extension CashRateField {
    func onInit() {
        addDoneButtonOnKeyboard()
        textAlignment = .right
        delegate = self
        autocorrectionType = .no
        keyboardType = .numberPad
        setPadding(10)
        text = decimalFormatter.string(from: 0)
        addTarget(self, action: #selector(onEdit), for: .editingChanged)
    }
}

// Delegate
extension CashRateField: UITextFieldDelegate {
    public override func deleteBackward() {
        super.deleteBackward()
        setRate(cents / 100)
    }


}
