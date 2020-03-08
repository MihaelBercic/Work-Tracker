//
// Created by Mihael Bercic on 01/01/2020.
// Copyright (c) 2020 Regnum d.o.o. All rights reserved.
//

import UIKit
import Foundation

protocol ScopeFunctions {}

extension ScopeFunctions {

    func apply(block: (Self) -> ()) -> Self {
        block(self)
        return self
    }

    func use(block: (Self) -> ()) {
        block(self)
    }
}

extension NSObject: ScopeFunctions {}

extension Array: ScopeFunctions {}

extension CGFloat: ScopeFunctions {}
