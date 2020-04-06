//
//  DataController.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 06/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation
import CoreData

final class DataController {
    let persistentConteiner: NSPersistentContainer
    
    var viewConext: NSManagedObjectContext {
        return persistentConteiner.viewContext
    }
    
    init (modelName: String) {
        persistentConteiner = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentConteiner.loadPersistentStores {
            (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
           completion?()
        }
    }
}
