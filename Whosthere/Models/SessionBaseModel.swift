//
//  SessionBaseModel.swift
//  Whosthere
//
//  Created by Moose on 05.09.22.
//

import Foundation
import CoreData

protocol SessionBaseModel {
    
    static var viewContext: NSManagedObjectContext { get }
    func save() throws
    func delete() throws
    
}

extension SessionBaseModel where Self: NSManagedObject {
    
    static var viewContext: NSManagedObjectContext {
        CoreDataManager.shared.persistentStoreContainer.viewContext
    }
    
    func save() throws {
        try Self.viewContext.save()
    }
    
    func delete() throws {
        Self.viewContext.delete(self)
        try save()
    }
}
