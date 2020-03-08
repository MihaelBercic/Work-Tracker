//
// Created by Mihael Bercic on 28/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import Foundation


extension Client {

    var formattedRate: String {
        get { decimalFormatter.string(from: rate.intValue.asDecimal.dividing(by: 100.asDecimal)) ?? "" }
    }

    var formattedCurrency: Character {
        get { currencyValueOf(currency.intValue).asCharacter }
    }

    var currencyAsInt: Int { get { currency.intValue } }
}

