//
//  AddAthleteViewModel.swift
//  Whosthere
//
//  Created by Moose on 19.03.22.
//

import Foundation
import UIKit
import CoreData

class AddAthleteViewModel: ObservableObject {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var birthDate: Date?
    @Published var birthYear = Calendar.current.component(.year, from: Date())
    @Published var gender = ""
    @Published var showYear = false
    
    func save() {
        do {
            let newAthlete = AthleteMO(context: context)
            newAthlete.id = UUID()
            newAthlete.firstName = firstName
            newAthlete.lastName = lastName
            newAthlete.birthday = birthDate
            newAthlete.gender = gender
            newAthlete.showYear = showYear
            try newAthlete.save()
            
        } catch {
            print(error)
        }
    }

    
    // MARK: Functions
    
    func textIsAppropriate() -> Bool {
        if firstName.count >= 2 && lastName.count >= 1 {
            return true
        }
        return false
    }
    
   

    //function to adjust the year variable according to the selected birthdate variable->is called when add athlete button is pressed
    func getBirthYear() -> Int {
        if birthDate != Date()
            {
            birthYear = Calendar.current.component(.year, from: birthDate ?? Date())
            }
        return birthYear
    }
}

