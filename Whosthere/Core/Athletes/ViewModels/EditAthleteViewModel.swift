//
//  EditAthleteViewModel.swift
//  Whosthere
//
//  Created by Moose on 19.03.22.
//

import Foundation

class EditAthleteViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var birthDate: Date?
    @Published var birthYear = Calendar.current.component(.year, from: Date())
    @Published var gender = ""
    @Published var showYear = false
   
    var id: String
    
    
    init(_ currentAthlete: AthletesModel) {
        self.firstName = currentAthlete.firstName
        self.lastName = currentAthlete.lastName
        self.birthDate = currentAthlete.birthday ?? Date()
        self.birthYear = currentAthlete.birthyear
        self.gender = currentAthlete.gender
        self.showYear = currentAthlete.showYear
        id = currentAthlete.id
    }
}
