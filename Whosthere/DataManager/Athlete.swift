//
//  Athlete.swift
//  Whosthere
//
//  Created by Moose on 06.09.22.
//

import SwiftUI

/**
 This is the view-facing `Athlete` struct. Views should have no idea that this struct is
 backed up by a CoreData Managed Object: `AthleteEntity`. The `DataManager`
 handles keeping this in sync via `NSFetchedResultsControllerDelegate`.
 */
struct Athlete: Identifiable, Hashable, Equatable {
    var id: UUID
    var firstName: String
    var lastName: String
    var birthday: Date
    var gender: String
    var showYear: Bool
    var sessionIDs = [UUID]()
    
    init(firstName: String = "", lastName: String = "", birthday: Date = Date(), gender: String = "", showYear: Bool = false) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.gender = gender
        self.showYear = showYear
    }
    
    static func ==(lhs: Athlete, rhs: Athlete) -> Bool {
        return lhs.id == rhs.id
        //&& lhs.firstName == rhs.firstName
    }
}
