//
//  Entry+CoreDataProperties.swift
//  WorkTracker
//
//  Created by Mihael Bercic on 27/02/2020.
//  Copyright © 2020 Mihael Bercic. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var start:  Date
    @NSManaged public var stop:   Date?
    @NSManaged public var client: Client

}
