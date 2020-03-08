//
// Created by Mihael Bercic on 25/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import Foundation
import CoreData

class DataManager {

    lazy var context = persistentContainer.viewContext

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WorkTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") }
        })
        return container
    }()


    func fetchData<T: NSManagedObject>(request: NSFetchRequest<T>, predicate: (T) -> Bool = { _ in true }) -> [T] {
        (try? context.fetch(request))?.filter(predicate) ?? []
    }


    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("Saved...")
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

}
