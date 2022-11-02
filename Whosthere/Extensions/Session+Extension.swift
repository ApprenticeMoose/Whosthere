//
//  Session+Extension.swift
//  Whosthere
//
//  Created by Moose on 05.09.22.
//

import Foundation
import CoreData

extension SessionMO: SessionBaseModel {
    
    static var all: NSFetchRequest<SessionMO> {
        let request = SessionMO.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
}
