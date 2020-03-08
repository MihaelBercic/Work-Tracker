//
// Created by Mihael Bercic on 28/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var asDecimal:  NSDecimalNumber { get { NSDecimalNumber(value: self) } }
    var asNSNumber: NSNumber { get { NSNumber(value: self) } }
}

extension Double {
    var asDecimal:  NSDecimalNumber { get { NSDecimalNumber(value: self) } }
    var asNSNumber: NSNumber { get { NSNumber(value: self) } }
}

extension UITextField {
    func setPadding(_ left: CGFloat = 0, _ right: CGFloat = 0) {
        if left > 0 {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        if right > 0 {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}

extension UIColor {

    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:  (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }

    func isInSameMonth(date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }

    func isInSameDay(date: Date) -> Bool { isEqual(to: date, toGranularity: .day) }

    func isInSameWeek(date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    var isInThisYear:  Bool { isInSameYear(date: Date()) }
    var isInThisMonth: Bool { isInSameMonth(date: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(date: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}

extension UITextField {
    func addDoneButtonOnKeyboard() {
        let flexSpace             = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        inputAccessoryView = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)).apply {
            $0.barStyle = .default
            $0.items = [flexSpace, done]
            $0.sizeToFit()
        }
    }

    @objc func doneButtonAction() { resignFirstResponder() }
}