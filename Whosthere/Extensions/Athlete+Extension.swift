//
//  Athlete+Extension.swift
//  Whosthere
//
//  Created by Moose on 28.07.22.
//

import Foundation
import CoreData

extension Athlete: AthleteBaseModel {
    
    static var all: NSFetchRequest<Athlete> {
        let request = Athlete.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
}
