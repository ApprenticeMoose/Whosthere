//
//  AddAthleteViewModel.swift
//  Whosthere
//
//  Created by Moose on 19.03.22.
//

import Foundation

class AddAthleteViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var birthDate = Date()
    @Published var birthYear = Calendar.current.component(.year, from: Date())
    @Published var gender = ""
    
    
    func textIsAppropriate() -> Bool {
        if firstName.count >= 2 && lastName.count >= 1 {
            return true
        }
        return false
    }
}
