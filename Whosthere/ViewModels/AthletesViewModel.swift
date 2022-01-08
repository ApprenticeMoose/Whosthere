//
//  AthletesListViewModel.swift
//  Photopickertest
//
//  Created by Moose on 13.12.21.
//

import Foundation

class AthletesViewModel: ObservableObject {
    
    @Published var athletes: [AthletesModel] = []
    
    init() {
       getAthletes()
    }
    
    func getAthletes() {
        let newAthletes = [
            AthletesModel(firstName: "Noah", lastName: "Martinez Berger"),
            AthletesModel(firstName: "Asbat", lastName: "Ouro-Body"),
            AthletesModel(firstName: "Viktor", lastName: "Kusmanow")
        ]
        athletes.append(contentsOf: newAthletes)
    }
    
    func deleteAthlete(indexSet: IndexSet) {
        athletes.remove(atOffsets: indexSet)
    }
    
    func addAthlete(firstName: String, lastName: String) {
        let newAthlete = AthletesModel(firstName: firstName, lastName: lastName)
        athletes.append(newAthlete)
    }
}
