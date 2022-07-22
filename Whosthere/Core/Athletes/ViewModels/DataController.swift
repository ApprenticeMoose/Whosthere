//
//  DataController.swift
//  Whosthere
//
//  Created by Moose on 21.07.22.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "WhosThere")
    
    init(){
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load \(error.localizedDescription)")
            }
        }
    }
}
