//
//  Athlete+Extension.swift
//  Whosthere
//
//  Created by Moose on 28.07.22.
//

import Foundation
import CoreData

extension AthleteMO: AthleteBaseModel {
    
    static var all: NSFetchRequest<AthleteMO> {
        let request = AthleteMO.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
}
