//
//  AthleteModel.swift
//  Photopickertest
//
//  Created by Moose on 13.12.21.
//

import Foundation
import UIKit


class AthletesModel: Identifiable, Codable, ObservableObject {
    let id: String 
    let firstName: String
    let lastName: String
    let birthday: Date?
    let birthyear: Int
    let gender: String
    let showYear: Bool
//let image: UIImage?
   
    
    init(id: String = UUID().uuidString, firstName: String, lastName: String, birthday: Date?, birthyear: Int, gender: String, showYear: Bool) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.birthyear = birthyear
        self.gender = gender
        self.showYear = showYear
        
    }
    
    static var sampleData: [AthletesModel] {
        [
            AthletesModel(firstName: "Mustafa", lastName: "Acar", birthday: .init(timeIntervalSince1970: 893796436), birthyear: 1998, gender: "male", showYear: false)
        ]
    }
    
    func updateModel(firstName: String, lastName: String, birthday: Date, birthyear: Int, gender: String, showYear: Bool) -> AthletesModel {
        return AthletesModel(id: id, firstName: firstName, lastName: lastName, birthday: birthday, birthyear: birthyear, gender: gender, showYear: showYear)
    }
}
