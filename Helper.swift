//
// Created by Mihael Bercic on 04/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import Foundation


let colors = [
    // "#40407a", // no
    "#706fd3",
    "#34ace0", // yes
    "#33d9b2", // yes
    // "#2c2c54", no
    // "#474787",
    // "#227093",
    "#218c74", // yes
    "#ff5252", // yes
    "#ff793f", // yes
    "#b33939", // maybe
    // "#ffda79", // no
]
var randomFlatColor: String { get { colors.randomElement()! } }


// Static shit
let dateAndTimeFormatter = DateFormatter().apply {
    $0.dateFormat = "dd.MM hh:mm"
}

let groupDateFormatter = DateFormatter().apply {
    $0.dateFormat = "MMMM\nYYYY"
}

let currentTimeFormatter = DateComponentsFormatter().apply { formatter in
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.zeroFormattingBehavior = .pad
}
let totalTimeFormatter = DateComponentsFormatter().apply { formatter in
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.hour, .minute]
    formatter.zeroFormattingBehavior = .pad
}

let decimalFormatter = NumberFormatter().apply { formatter in
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
}