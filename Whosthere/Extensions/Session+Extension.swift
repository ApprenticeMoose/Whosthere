//
//  Session+Extension.swift
//  Whosthere
//
//  Created by Moose on 05.09.22.
//

import Foundation
import CoreData

extension SessionEntity: SessionBaseModel {
    
    static var all: NSFetchRequest<SessionEntity> {
        let request = SessionEntity.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
}
