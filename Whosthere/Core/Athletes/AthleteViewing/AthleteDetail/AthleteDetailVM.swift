//
//  AthleteDetailVM.swift
//  Whosthere
//
//  Created by Moose on 08.09.22.
//

import SwiftUI
import Combine

@MainActor
final class AthleteDetailVM: ObservableObject {
    
    @Published var detailAthlete: Athlete
    
    @Published private var dataManager: DataManager
    
    var anyCancellable: AnyCancellable? = nil
    
    init(athlete: Athlete, dataManager: DataManager = DataManager.shared) {
        self.detailAthlete = athlete
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    func fetchAthletes() {
        dataManager.fetchAthletes()
    }
    
}
