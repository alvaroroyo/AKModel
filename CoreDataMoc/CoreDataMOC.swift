//
//  CoreDataMOC.swift
//  PruebaFever
//
//  Created by Alvaro Royo on 24/3/17.
//  Copyright © 2017 Alvaro Royo. All rights reserved.
//

import UIKit
import CoreData

class CoreDataMOC {
    
    var context : NSManagedObjectContext!
    
    init() {
        
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.persistentStoreCoordinator = getPersistentStoreCoordinator()
        
    }
    
    private func getPersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        
        let directoryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        
        print(directoryPath)
        
        let directoryURL = URL(fileURLWithPath: directoryPath)
        
        let storeURL = directoryURL.appendingPathComponent("DataModel.sqlite")
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: getManagedObjectModel())

        let options = Dictionary(dictionaryLiteral: (NSMigratePersistentStoresAutomaticallyOption,true),(NSInferMappingModelAutomaticallyOption,true))
        
        do{
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch {
            print("Error in getPersistentStoreCoordinator()")
        }
        
        return persistentStoreCoordinator
        
    }
    
    private func getManagedObjectModel() -> NSManagedObjectModel {
        
        let modelURL = Bundle.main.url(forResource: "DataModel", withExtension: "momd")
        
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL!)
        
        return managedObjectModel!
        
    }
    
    func saveContext() {
        
        do {
            try self.context.save()
        } catch {
            print("Error to save context")
        }
        
    }
    
    // MARK: Core data methods
    
    func select(entity:String!, predicate:NSPredicate?, limit:Int?, fault:Bool) -> [Any]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = limit == nil ? NSIntegerMax : limit!
        fetchRequest.returnsObjectsAsFaults = fault
        
        var result : [Any]? = nil
        
        do {
            try result = self.context.fetch(fetchRequest)
        } catch {
            print("Error in CoreDataMOC - select")
        }
        
        return result
        
    }
    
    func count(entity:String!, predicate:NSPredicate?) -> Int {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        fetchRequest.includesSubentities = true
        
        var result = 0
        
        do {
            try result = self.context .count(for: fetchRequest)
        } catch {
            print("Error in CoreDataMOC - Count")
        }
        
        return result
        
    }
    
    func drop(entities:[String]!) {
        
        for entityName in entities {
            
            let objects = self.select(entity: entityName, predicate: nil, limit: nil, fault: true)
            
            if objects != nil {
            
                for obj in objects! {
                    
                    self.context.delete(obj as! NSManagedObject)
                    
                }
                
            }
            
        }
        
        self.saveContext()
        
    }
    
}
