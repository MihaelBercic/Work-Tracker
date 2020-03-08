//
//  Client+CoreDataProperties.swift
//  WorkTracker
//
//  Created by Mihael Bercic on 28/02/2020.
//  Copyright © 2020 Mihael Bercic. All rights reserved.
//
//

import Foundation
import CoreData


extension Client {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var color:     String
    @NSManaged public var currency:  NSNumber
    @NSManaged public var name:      String
    @NSManaged public var rate:      NSNumber
    @NSManaged public var timeRound: NSNumber
    @NSManaged public var entries:   NSSet?

}

// MARK: Generated accessors for entries
extension Client {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Entry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Entry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}
