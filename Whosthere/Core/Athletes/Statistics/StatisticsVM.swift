//
//  StatisticsVM.swift
//  Whosthere
//
//  Created by Moose on 19.12.22.
//

import Foundation
import Combine
import OrderedCollections

@MainActor
final class StatisticsVM: ObservableObject {
    
    @Published var modifiedSessions = [Session]()
   // @Published var athletesWithSessions = [Athlete : Float]()
    @Published var athletesWithSessions = [(Athlete, Float)]()
    
    @Published private var dataManager: DataManager
    
    var anyCancellable: AnyCancellable? = nil
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    var athletes: [Athlete] {
        dataManager.athletesArray
    }
    
    var sessions: [Session] {
        dataManager.sessionsArray
    }
    
    func fetchData() {
        dataManager.fetchAthletes()
        dataManager.fetchSessions()
    }
    
    func getAllModifiedSessions() {
        let allSessions = sessions
        let filteredSessions1 = allSessions.filter({ (session) -> Bool in
            return session.date >= UserDefaults.standard.dateFilterStatistics?.date1 ?? Date()
        })
        let filteredSessions2 = filteredSessions1.filter({ (session) -> Bool in
            return session.date <= UserDefaults.standard.dateFilterStatistics?.date2 ?? Date()
        })
        modifiedSessions = filteredSessions2
    }
    
    func getSessions(with id: UUID?) -> Session? {
        guard let id = id else { return nil }
        return dataManager.getSession(with: id)
    }
    
    func getAthleteSessionsListContent() {
        athletesWithSessions.removeAll()
        for athlete in athletes {
            
            var sessions: [Session] = []
            var finalSessions: [Session] = []
            for sessionID in athlete.sessionIDs {
                if let session = getSessions(with: sessionID) {
                    sessions.append(session)
                }
            }
            for session in sessions {
                if modifiedSessions.contains(session) {
                    finalSessions.append(session)
                }
            }
            
            var endDate: Date {
                if UserDefaults.standard.dateFilterStatistics?.date2 ?? Date() > Date().endOfWeek() {
                    return Date().endOfWeek()
                } else {
                    return UserDefaults.standard.dateFilterStatistics?.date2 ?? Date()
                }
            }
            
            
            
            if UserDefaults.standard.string(forKey: "statisticsPerX") == PerRange.total.rawValue {
                athletesWithSessions.append((athlete , Float(finalSessions.count)))
            } else if UserDefaults.standard.string(forKey: "statisticsPerX") == PerRange.perMonth.rawValue {
                let perMonthNumber = Float(finalSessions.count) / (Float(Calendar.current.numberOfDaysBetween(UserDefaults.standard.dateFilterStatistics?.date1 ?? Date(), and: endDate)) / 30.436875)
                athletesWithSessions.append((athlete , round(perMonthNumber * 10) / 10.0))
            } else if UserDefaults.standard.string(forKey: "statisticsPerX") == PerRange.perWeek.rawValue {
                let perWeekNumber = Float(finalSessions.count) / Float(Calendar.current.numberOfDaysBetween(UserDefaults.standard.dateFilterStatistics?.date1 ?? Date(), and: endDate) / 7)
                athletesWithSessions.append((athlete , round(perWeekNumber * 10) / 10.0))
            }
            
        }
    }
}
