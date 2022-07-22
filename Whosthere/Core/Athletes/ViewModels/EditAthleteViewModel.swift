
//  EditAthleteViewModel.swift
//  Whosthere
//
//  Created by Moose on 19.03.22.


import Foundation

class EditAthleteViewModel: ObservableObject {

    @Published var firstName = ""
    @Published var lastName = ""
    @Published var birthDate: Date?
    @Published var birthYear = Calendar.current.component(.year, from: Date())
    @Published var gender = ""
    @Published var showYear = false

    var id: UUID?


    init(_ currentAthlete: Athlete) {
        self.firstName = currentAthlete.firstName ?? "unknown Athlete"
        self.lastName = currentAthlete.lastName ?? "unknown Athlete"
        self.birthDate = currentAthlete.birthday ?? Date()
        //self.birthYear = currentAthlete.birthyear
        self.gender = currentAthlete.gender ?? "unknown Athlete"
        self.showYear = currentAthlete.showYear
        id = currentAthlete.id
    }
}
