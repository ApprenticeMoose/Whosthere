//
//  SessionsHomeViewModel.swift
//  Whosthere
//
//  Created by Moose on 05.09.22.
//

import SwiftUI
import Combine

@MainActor
final class SessionHomeVM: ObservableObject {
    
    @Published var dataManager: DataManager
    
    var anyCancellable: AnyCancellable? = nil
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    var sessions: [Session] {
        dataManager.sessionsArray
    }
    
    func fetchSessions() {
        dataManager.fetchSessions()
    }
    
    func getAthletes(with id: UUID?) -> Athlete? {
        guard let id = id else {return nil}
        return dataManager.getAthlete(with: id)
    }
}
