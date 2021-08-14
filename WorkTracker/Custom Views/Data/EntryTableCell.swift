//
// Created by Mihael Bercic on 06/03/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class EntryTableCell: CUITableCell, ViewSetup{
    
    // Entry has: Start, End, Client
    
    // Views
    private let timelineLabel    = UILabel()
    
    
    private let durationLabel    = UILabel()
    private let earningsLabel    = UILabel()
    private let padding: CGFloat = 10
    
    func setHierarchy() {
        addSubview(timelineLabel)
        addSubview(durationLabel)
        addSubview(earningsLabel)
    }
    
    func setConstraints() {
        
        earningsLabel.connect {
            $0.rightAnchor = rightAnchor
            $0.centerYAnchor = centerYAnchor
            $0.topAnchor = topAnchor
            $0.bottomAnchor = bottomAnchor
            $0.widthConstant = 100
            $0.rightConstant = -padding
        }
        timelineLabel.connect {
            $0.topAnchor = topAnchor
            $0.leftAnchor = leftAnchor
            $0.rightAnchor = earningsLabel.leftAnchor
            $0.bottomAnchor = centerYAnchor
            $0.leftConstant = padding
        }
        durationLabel.connect {
            $0.topAnchor = timelineLabel.bottomAnchor
            $0.leftAnchor = leftAnchor
            $0.rightAnchor = earningsLabel.leftAnchor
            $0.bottomAnchor = bottomAnchor
            $0.leftConstant = padding
        }
    }
    
    func modifySubviews() {
        earningsLabel.use {
            $0.font = .boldSystemFont(ofSize: 18)
            $0.textAlignment = .center
            $0.textColor = sharedAppColor
        }
        
        timelineLabel.use {
            $0.font = .boldSystemFont(ofSize: 13)
            $0.textColor = $0.textColor.withAlphaComponent(0.6)
        }
        
        durationLabel.use {
            $0.font = .boldSystemFont(ofSize: 16)
        }
    }
}

extension EntryTableCell {
    
    func displayEntry(entry: Entry) {
        let duration  = entry.start.distance(to: entry.stop!)
        let startTime = dateAndTimeFormatter.string(from: entry.start)
        let endTime   = dateAndTimeFormatter.string(from: entry.stop!)
        
        let ratePerSecond   = entry.client.rate.intValue.asDecimal.dividing(by: 3600)
        let ratePerDuration = duration.asDecimal.multiplying(by: ratePerSecond)
        let earnings        = ratePerDuration.dividing(by: 100)
        let currency        = entry.client.formattedCurrency
        
        timelineLabel.text = "\(startTime) - \(endTime)"
        durationLabel.text = totalTimeFormatter.string(from: duration)
        earningsLabel.text = "\(decimalFormatter.string(from: earnings) ?? "") \(currency)"
    }
    
}


