//
// Created by Mihael Bercic on 29/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import Foundation
import UIKit

protocol Bindable {
    associatedtype AssociatedType: Comparable
    var observable: Observable<AssociatedType> { get }
    var selector:   Selector { get }
    func bind(with: Observable<AssociatedType>)
}

class Observable<T: Equatable> {

    private var connected: [Observable] = []
    private var onChange: (T) -> () = { _ in }

    init(_ defaultValue: T, _ onChange: @escaping (T) -> () = { _ in }) {
        self.value = defaultValue
        self.onChange = onChange
    }

    var value: T {
        didSet { if value != oldValue { onChange(value); notify() } }
    }


    /// Notifies every connected observable.
    private func notify() {
        connected.forEach { $0.value = value }
    }

    /// Add the observable to the connected observables.
    func bindBiDirectionally(with: Observable<T>) { with.connected.append(self); connected.append(with) }

    func bind(to: Observable<T>) { to.connected.append(self) }

    func setOnChange(_ block: @escaping (T) -> ()) {
        self.onChange = block
    }
}


extension Bindable where Self: NSObject {

    func bind(with: Observable<AssociatedType>) { observable.bindBiDirectionally(with: with); addTarget() }

    func addTarget() {
        (self as? UIControl)?.use { $0.addTarget(self, action: selector, for: .allEditingEvents) }
    }
}


/// Customized UIControls
class ObservableTextField: UITextField, Bindable {
    lazy var observable: Observable<String> = Observable<String>("") { self.text = $0 }
    lazy var selector: Selector = #selector(onChange)

    @objc func onChange() { observable.value = text ?? "" }
}

class ObservableLabel: UILabel, Bindable {
    lazy var observable: Observable<String> = Observable<String>("") { self.text = $0 }
    lazy var selector: Selector = #selector(onChange)

    @objc func onChange() { observable.value = text ?? "" }
}
