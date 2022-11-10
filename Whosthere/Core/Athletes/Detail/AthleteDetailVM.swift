//
//  AthleteDetailVM.swift
//  Whosthere
//
//  Created by Moose on 08.09.22.
//

import SwiftUI
import Combine


// FIXME: when selected range is beyond current week, it only takes the weeks until the current day to calculate the avarage
@MainActor
final class AthleteDetailVM: ObservableObject {
    
    //Need to pull it from the titles array from the datamanger as a array[whateverid]
    @Published private var dataManager: DataManager
    @ObservedObject var station: Station = Station()
    
    var index: Int = 0
    var detailedAthlete: Athlete = Athlete()
    var anyCancellable: AnyCancellable? = nil
    
    
    init?(athlete: Athlete, dataManager: DataManager = DataManager.shared) {
        self.detailedAthlete = athlete
        self.dataManager = dataManager
        
        fetchAthlete()

        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    init(athlete2: Athlete, dataManager2: DataManager = DataManager.shared) {
        self.detailedAthlete = athlete2
        self.dataManager = dataManager2

        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        print("DetailVM initialized")
        
    }

    
    func fetchAthlete() {
        dataManager.fetchAthletes()
        if let indexus = dataManager.athletesArray.firstIndex(where: { $0.id == detailedAthlete.id })
        {
            //print(indexus)
            self.index = indexus
        } else {
            print("no index")
            self.index = 0
        }
        
        if dataManager.athletesArray.isEmpty{
            self.detailedAthlete = Athlete()
        } else {
            self.detailedAthlete = dataManager.athletesArray[index]
        }
    }
    
    func getSessions(with id: UUID?) -> Session? {
        guard let id = id else { return nil }
        return dataManager.getSession(with: id)
    }
    

    var modifiedArrayOfSessions: [Session] {
        var sessionsArray: [Session] {
            var arrayOfSessions: [Session] = []
            for sessionID in detailedAthlete.sessionIDs {
                    if let session = getSessions(with: sessionID) {
                        arrayOfSessions.append(session)
                    }
                }
            return arrayOfSessions
        }
        
        let allSessions = sessionsArray
        let filteredSessions1 = allSessions.filter({ (session) -> Bool in
            return session.date >= station.dateFilterAttendance.date1
        })
        let filteredSessions2 = filteredSessions1.filter({ (session) -> Bool in
            return session.date <= station.dateFilterAttendance.date2
        })
        return filteredSessions2
    }
    
    var selectedSessionAttendance: Float{
       
        switch station.perXAttendance {
        case .total:
             return Float(modifiedArrayOfSessions.count)
        case .perMonth:
            let perMonthNumber = Float(modifiedArrayOfSessions.count) / (Float(Calendar.current.numberOfDaysBetween(station.dateFilterAttendance.date1, and: station.dateFilterAttendance.date2)) / 30.436875)
             return round(perMonthNumber * 10) / 10.0
        case .perWeek:
            let perWeekNumber = Float(modifiedArrayOfSessions.count) / Float(Calendar.current.numberOfDaysBetween(station.dateFilterAttendance.date1, and: station.dateFilterAttendance.date2) / 7)
            return round(perWeekNumber * 10) / 10.0
        }
    }
    
    
}
