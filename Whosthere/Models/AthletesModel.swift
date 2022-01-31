//
//  AthleteModel.swift
//  Photopickertest
//
//  Created by Moose on 13.12.21.
//

import Foundation

struct AthletesModel: Identifiable {
    let id: String = UUID().uuidString
    let firstName: String
    let lastName: String
    let birthday: Date
    let birthyear: Int
    let gender: String
}
