//
//  AthleteBaseModel.swift
//  Whosthere
//
//  Created by Moose on 28.07.22.
//

import Foundation
import CoreData

protocol AthleteBaseModel {
    
    static var viewContext: NSManagedObjectContext { get }
    func save() throws
    func delete() throws
    
}

extension AthleteBaseModel where Self: NSManagedObject {
    
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
