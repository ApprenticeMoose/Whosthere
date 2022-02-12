//
//  AthleteModel.swift
//  Photopickertest
//
//  Created by Moose on 13.12.21.
//

import Foundation

struct AthletesModel: Identifiable {
    let id: String 
    let firstName: String
    let lastName: String
    let birthday: Date
    let birthyear: Int
    let gender: String
    
    init(id: String = UUID().uuidString, firstName: String, lastName: String, birthday: Date, birthyear: Int, gender: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.birthyear = birthyear
        self.gender = gender
    }
    
    func updateModel(firstName: String, lastName: String, birthday: Date, birthyear: Int, gender: String) -> AthletesModel {
        return AthletesModel(id: id, firstName: firstName, lastName: lastName, birthday: birthday, birthyear: birthyear, gender: gender)
    }
}
