//
// Created by Mihael Bercic on 26/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import Foundation
import UIKit

let allCurrencies: [Character] = ["€", "$"]

@objc public enum Currency: Int, CaseIterable {
    case euro   = 0
    case dollar = 1

    var asCharacter: Character { get { allCurrencies[rawValue] } }
    var asNSNumber:  NSNumber { get { rawValue.asNSNumber } }
}

func currencyValueOf(_ x: Int) -> Currency { Currency.allCases[x] }

