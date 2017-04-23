//
//  LocalDataContext.swift
//  Miras
//
//  Created by Moayad Al kouz on 2/7/17.
//  Copyright © 2017 Thiqah. All rights reserved.
//

import CoreData


class LocalContext {
    
    static let shared : LocalContext = {
        let instance = LocalContext()
        return instance
    }()
    
    // Applications default directory address
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dbURL = urls[urls.count-1]
        print("DB URL \(dbURL)")
        return dbURL
    }()
    lazy var managedObjectModel: NSManagedObjectModel = {
        // 1
        let modelURL = Bundle.main.url(forResource: "AppDataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("AppDataModel.sqlite")
        do {
            let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                            NSInferMappingModelAutomaticallyOption: true]
            // If your looking for any kind of migration then here is the time to pass it to the options
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
        } catch let  error as NSError {
            print("Ops there was an error \(error.localizedDescription)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for theapplication.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    // if there is any change in the context save it
    func saveContext() {
        if LocalContext.shared.managedObjectContext.hasChanges {
            do {
                try LocalContext.shared.managedObjectContext.save()
            } catch let error as NSError {
                print("Ops there was an error \(error.localizedDescription)")
                abort()
            }
        }
        
    }
    
    func createEntity(name: String, idAttribute: String? = nil, idAttributeValue: Any? = nil) -> NSManagedObject{
        let entity = NSEntityDescription.entity(forEntityName: name, in: managedObjectContext)
        
        var object = NSManagedObject(entity: entity!, insertInto: nil)
        //var object : NSManagedObject!
        
        if let idAttribute = idAttribute, let idAttributeValue = idAttributeValue {
            
            let projectName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
            //to get the fully qualified name
            let theName = String(format: "%@.%@", arguments: [projectName, name])
            
            let entityClass : NSManagedObject.Type = NSClassFromString(theName) as! NSManagedObject.Type
            
            let objectInDB = (getRecords(entityClass, predicate: NSPredicate(format: "%K == %@", argumentArray: [idAttribute, idAttributeValue])) as? [NSManagedObject])?.first
            
            if let objectInDB = objectInDB { //update if previously exists to prevent duplicates
                
                object = objectInDB
            }
            else { // insert
                
                object = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            }
        }
        else {
           object = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        }
        
        return object
    }
    
    func getRecords<T: NSManagedObject>(_ type : T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchOffset: Int? = nil, fetchLimit: Int? = nil) -> (Any?)
    {
        //note: this line is important, if you don't put managedObjectContext in a constant like this before using it, it will crash the app, because lazy var will be initialized using an object of the class
        
        let context = LocalContext.shared.managedObjectContext
        let request = type.fetchRequest()

        if let predicate = predicate {
            request.predicate = predicate
        }
        
        if let sortDescriptors = sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        
        if let fetchOffset = fetchOffset {
            request.fetchOffset = fetchOffset
        }
        
        if let fetchLimit = fetchLimit {
            request.fetchLimit = fetchLimit
        }
        
        do
        {
            let results = try context.fetch(request)
            return (results as? [T])
        }
        catch
        {
//            var errorInfo = ErrorInfo()
//            errorInfo.errorCode = ErrorCodes.LocalDBError.rawValue
            print("Error with request: \(error)")
            return error
        }
    }
    
    func getRecordsCount<T: NSManagedObject>(_ type : T.Type, predicate: NSPredicate? = nil) -> Int
    {
        //note: this line is important, if you don't put managedObjectContext in a constant like this before using it, it will crash the app, because lazy var will be initialized using an object of the class
        
        let context = LocalContext.shared.managedObjectContext
        let request = type.fetchRequest()
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do
        {
            let count = try context.count(for: request)
            return count
        }
        catch
        {
//            var errorInfo = ErrorInfo()
//            errorInfo.errorCode = ErrorCodes.LocalDBError.rawValue
//            print("Error with request: \(error)")
            return 0
        }
    }
    
    func deleteRecords<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil) {
        do {
            //note: this line is important, if you don't put managedObjectContext in a constant like this before using it, it will crash the app, because lazy var will be initialized using an object of the class
            
            let context = LocalContext.shared.managedObjectContext
            
            let request: NSFetchRequest = type.fetchRequest()
            
            if let predicate = predicate {
                request.predicate = predicate
            }
           
            
            let fetchedRecords = try context.fetch(request) as! [T]
            
            if fetchedRecords.count > 0 {
                
                fetchedRecords.forEach { (record) in
                    
                    context.delete(record)
                }
                saveContext()
            }
            
        }  catch {}
    }
    
    func deleteRecord(record: NSManagedObject) {
            let context = LocalContext.shared.managedObjectContext
            context.delete(record)
            saveContext()
    }
}
