//
// Created by Mihael Bercic on 04/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class DatePicker: CUIView, ViewSetup {

    // Views
    private let stackView     = UIStackView()
    private let textField     = UITextField()
    private let label         = UILabel()

    // Date picker
    private let datePicker    = UIDatePicker()
    private let toolbar       = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    private let doneButton    = UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(setText))
    private let nowButton     = UIBarButtonItem(title: "Now", style: .plain, target: nil, action: #selector(selectNow))

    // Date formatter
    private let dateFormatter = DateFormatter()

    // Getter
    var selectedDate: Date { datePicker.date }
}

// Custom
extension DatePicker {

    @objc func selectNow() {
        datePicker.setDate(Date(), animated: true)
        textField.text = dateFormatter.string(from: datePicker.date)
    }

    @objc func setText() {
        datePicker.endEditing(true)
        textField.text = dateFormatter.string(from: datePicker.date)
        textField.resignFirstResponder()
    }

}

// Constraints
extension DatePicker {
    func setConstraints() {
        stackView.connect {
            $0.centerXAnchor = centerXAnchor
            $0.centerYAnchor = centerYAnchor
        }

        textField.connect {
            $0.widthConstant = 150
            $0.heightConstant = 40
        }
    }
}

// Hierarchy
extension DatePicker {
    func setHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)

        // Picker setup
        toolbar.sizeToFit()
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
        toolbar.setItems([nowButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: true)
    }
}

// Subviews
extension DatePicker {
    func modifySubviews() {
        selectNow()
        setText()

        // Single liners
        stackView.spacing = 20
        datePicker.datePickerMode = .dateAndTime
        dateFormatter.dateFormat = "HH:mm \t dd MMMM"

        label.use {
            $0.textAlignment = .center
            $0.text = "Clock in at:"
        }

        textField.use {
            $0.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.7)
            $0.layer.cornerRadius = 5
            $0.textAlignment = .center
            $0.text = "Now"
        }
    }
}