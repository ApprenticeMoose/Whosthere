//
//  AthletesListViewModel.swift
//  Photopickertest
//
//  Created by Moose on 13.12.21.
//
import Foundation
import CoreData

class AthletesViewModel: ObservableObject {
    
    @Published var allAthletes: [AthletesModel] = []
    
    
    //Initializes the athlete when App is started/Screen is origanally loaded
    init() {
        loadAthletes()
    }
    
    //loads sample athlete into Athletes model array
    func loadAthletes() {
        allAthletes = AthletesModel.sampleData
    }
    
    func saveAthletes() {
        print("Saving athletes to file system")
    }
    
    //appends athlete to Athletes Model Array
    func addAthlete(_ athlete: AthletesModel) {
        allAthletes.append(athlete)
    }
    
    func updateAthlete(_ athlete: AthletesModel) {
            guard let index = allAthletes.firstIndex (where: { $0.id == athlete.id }) else {return}
            allAthletes[index] = athlete
        }
    
    func deleteAthlete(athlete: AthletesModel) {
        self.allAthletes.removeAll { $0.id == athlete.id }
    }
    
    
    
}//class end
