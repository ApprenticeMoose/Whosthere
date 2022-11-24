//
//  DetailDataVM.swift
//  Whosthere
//
//  Created by Moose on 19.11.22.
//

import Foundation

class DetailDataVM: ObservableObject {
    @Published var modifiedArrayOfSessions = [Session]()
    @Published var modifiedDistributionSessions = [Session]()
    @Published var selectedSessionAttendance: Float = 0.0
    @Published var distributionSessions = [[Session]]() //1= Sonntag, 7= Samstag
    @Published var sessionBarHeights: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    @Published var animate: Bool = false
    
    @Published var modifiedAllSessions = [Session]()
    @Published var distributionAllSessions = [[Session]]()
    @Published var sessionAllBarHeights: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
}
