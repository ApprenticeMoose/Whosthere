//
//  Athlete+Extension.swift
//  Whosthere
//
//  Created by Moose on 28.07.22.
//

import Foundation
import CoreData

extension AthleteEntity: AthleteBaseModel {
    
    static var all: NSFetchRequest<AthleteEntity> {
        let request = AthleteEntity.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
}
