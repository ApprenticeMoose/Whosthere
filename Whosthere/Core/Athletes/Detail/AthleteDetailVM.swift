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
    //@Published var detailIndex: Int
    
    @Published private var dataManager: DataManager
    
    //@Published var detailAthlete: Athlete
    
    @Published var station: Station = Station()
    
    var anyCancellable: AnyCancellable? = nil
    
    init?(athlete: Athlete, dataManager: DataManager = DataManager.shared) {
        //self.detailIndex = athleteIndex
        //self.detailAthlete = athlete
        self.dataManager = dataManager
        
        if let indexus = dataManager.athletesArray.firstIndex(where: { $0.id == detailedAthlete.id })
        {
            print(indexus)
            self.index = indexus
        }else {
            print("no index")
            self.index = 0
        }
        
        if dataManager.athletesArray.isEmpty{
            self.detailedAthlete = Athlete()
        } else {
            self.detailedAthlete = dataManager.athletesArray[index]
        }
        
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        print("DetailVM initialized")
    }
    
    init(athlete2: Athlete, dataManager2: DataManager = DataManager.shared) {
        //self.detailIndex = athleteIndex
        //self.detailAthlete = athlete2
        self.dataManager = dataManager2

        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        print("DetailVM initialized")
        
    }

    
    var index: Int = 0
    
    @Published var detailedAthlete: Athlete = Athlete()
    
    
   //@Published
//    var date1ToCheck: Date
//    {
//        return Array(station.dateFilterAttendance.keys)[0]
//    }
//
//    var date2ToCheck: Date
//    {
//        return Array(station.dateFilterAttendance.values)[0]
//    }
//
  
            
    
    
//   @Published var date2: Date = Date()
//
//    lazy var date2ToCheck: AnyPublisher<[Date:Date],Never> = {
//        station.dateFilterAttendance
//            .map { (dicDate) -> Date in
//                return Array(dicDate.keys)[0]
//            }
//            .eraseToAnyPublisher()
//    }()
//
//    {
//        return Array(station.dateFilterAttendance.values)[0]
//    }

    var selectedSessionAttendance: Float{
        var modifiedArrayOfSessions: [Session] {
            var sessionsArray: [Session] {
                var arrayOfSessions: [Session] = []
                //ForEach(detailVM.detailAthlete.sessionIDs, id: \.self) {sessionID in
                for sessionID in detailedAthlete.sessionIDs {
                        if let session = getSessions(with: sessionID) {
                            arrayOfSessions.append(session)
                        }
                    }
                return arrayOfSessions
            }
            
            print("KW")
            let allSessions = sessionsArray
            let filteredSessions1 = allSessions.filter({ (session) -> Bool in
                return session.date >= station.dateFilterAttendance.date1
            })
            let filteredSessions2 = filteredSessions1.filter({ (session) -> Bool in
                return session.date <= station.dateFilterAttendance.date2
            })
            return filteredSessions2
        }

        print("perX")
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
    
    func getSessions(with id: UUID?) -> Session? {
        guard let id = id else { return nil }
        return dataManager.getSession(with: id)
    }
}
