
//  EditAthleteViewModel.swift
//  Whosthere
//
//  Created by Moose on 19.03.22.


import Foundation
import CoreData

class EditAthleteViewModel: ObservableObject {

    @Published var firstName = ""
    @Published var lastName = ""
    @Published var birthDate: Date?
    @Published var birthYear = Calendar.current.component(.year, from: Date())
    @Published var gender = ""
    @Published var showYear = false

    var id: NSManagedObjectID?
    var context: NSManagedObjectContext

    init(_ currentAthlete: AthleteViewModel, context: NSManagedObjectContext) {
        self.firstName = currentAthlete.firstName
        self.lastName = currentAthlete.lastName
        self.birthDate = currentAthlete.birthday
        self.gender = currentAthlete.gender
        self.showYear = currentAthlete.showYear
        id = currentAthlete.id
        self.context = context
    }
    
    func deleteAthlete(athleteId: NSManagedObjectID) {
        do {
            guard let athlete = try context.existingObject(with: athleteId) as? Athlete else {
                return
            }
            
            try athlete.delete()
        } catch {
            print(error)
        }
    }
    
    func editAthlete(athleteId: NSManagedObjectID) {
        do {
            guard let athlete = try context.existingObject(with: athleteId) as? Athlete else {
                return
            }
            
            athlete.firstName = firstName
            athlete.lastName = lastName
            athlete.birthday = birthDate
            athlete.gender = gender
            athlete.showYear = showYear
            try athlete.save()
        } catch {
            print(error)
        }
    }
    
    
}
