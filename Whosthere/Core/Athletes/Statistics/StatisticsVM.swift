//
//  StatisticsVM.swift
//  Whosthere
//
//  Created by Moose on 19.12.22.
//

import Foundation
import Combine

@MainActor
final class StatisticsVM: ObservableObject {
    
    @Published var modifiedSessions = [Session]()
    
    
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
}
