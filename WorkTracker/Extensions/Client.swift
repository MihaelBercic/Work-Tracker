//
// Created by Mihael Bercic on 28/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import Foundation

extension Entry {

    var earningsInCents: Int {
        if let stop = stop {
            let interval      = start.distance(to: stop)
            let ratePerSecond = client.rate.doubleValue / 3600
            return Int(interval * ratePerSecond)
        }
        return 0
    }

}

extension Client {

    var formattedRate: String {
        get { decimalFormatter.string(from: rate.intValue.asDecimal.dividing(by: 100.asDecimal)) ?? "" }
    }

    var formattedCurrency: Character {
        get { currencyValueOf(currency.intValue).asCharacter }
    }

    var currencyAsInt: Int { get { currency.intValue } }
}

