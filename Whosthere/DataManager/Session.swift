//
//  Session.swift
//  Whosthere
//
//  Created by Moose on 06.09.22.
//

import SwiftUI

struct Session: Identifiable, Hashable {
    var id: UUID
    var date: Date
    var athleteIDs = [UUID]()
    
    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
    }
}
