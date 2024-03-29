//
//  Athlete.swift
//  Whosthere
//
//  Created by Moose on 06.09.22.
//

import SwiftUI

/**
 This is the view-facing `Athlete` struct. Views should have no idea that this struct is
 backed up by a CoreData Managed Object: `AthleteMO`. The `DataManager`
 handles keeping this in sync via `NSFetchedResultsControllerDelegate`.
 */
struct Athlete: Identifiable, Hashable, Equatable {
    var id: UUID
    var firstName: String
    var lastName: String
    var birthday: Date
    var gender: String
    var showYear: Bool
    var dateAdded: Date
    var sessionIDs = [UUID]()
    
    init(firstName: String = "", lastName: String = "", birthday: Date = Date(), gender: String = "", showYear: Bool = false, dateAdded: Date = Date()) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.gender = gender
        self.showYear = showYear
        self.dateAdded = dateAdded
    }
    
    static func ==(lhs: Athlete, rhs: Athlete) -> Bool {
        return lhs.id == rhs.id && lhs.firstName == rhs.firstName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
    }
}
