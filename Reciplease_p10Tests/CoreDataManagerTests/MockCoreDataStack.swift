//
//  MockCoreDataStack.swift
//  Reciplease_p10Tests
//
//  Created by Mélanie Obringer on 17/12/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import Reciplease_p10
import Foundation
import CoreData

final class MockCoreDataStack: CoreDataStack {
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(modelName: "Reciplease_p10")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}
