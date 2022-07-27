//
//  DataController.swift
//  Whosthere
//
//  Created by Moose on 21.07.22.
//

import Foundation
import SwiftUI
import CoreData

class DataController: ObservableObject {
    let container : NSPersistentContainer
    @Published var savedAthletes: [Athlete] = []
    
    
    
    init(){
        container = NSPersistentContainer(name: "WhosThere")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load \(error.localizedDescription)")
            }
        }
        fetchAthletes()
    }
    
    func fetchAthletes() {
        let request = NSFetchRequest<Athlete>(entityName: "Athlete")
        
        do {
           savedAthletes = try container.viewContext.fetch(request)
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    
    func saveData()  {
        do{
            try container.viewContext.save()
        } catch let error {
            print("Error saving \(error.localizedDescription)")
        }
        fetchAthletes()
    }
    
    func addAthlete(firstName: String, lastName: String, birthday: Date?, gender: String?, showYear: Bool){
        let newAthlete = Athlete(context: container.viewContext)
        newAthlete.id = UUID()
        newAthlete.firstName = firstName
        newAthlete.lastName = lastName
        newAthlete.birthday = birthday
        newAthlete.gender = gender
        newAthlete.showYear = showYear
        
        saveData()
    }
}
