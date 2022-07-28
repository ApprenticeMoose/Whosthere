//
//  DataController.swift
//  Whosthere
//
//  Created by Moose on 21.07.22.
//

import Foundation
import SwiftUI
import CoreData

class CoreDataManager: ObservableObject {
    
    
    let persistentStoreContainer : NSPersistentContainer
    static let shared = CoreDataManager()
    
    //@Published var savedAthletes: [Athlete] = []
    
    private init(){
        persistentStoreContainer = NSPersistentContainer(name: "WhosThere")
        persistentStoreContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load \(error.localizedDescription)")
            }
        }
    }
}
