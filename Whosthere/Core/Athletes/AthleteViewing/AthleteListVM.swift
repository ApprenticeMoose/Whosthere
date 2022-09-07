//
//  AthleteListVM.swift
//  Whosthere
//
//  Created by Moose on 07.09.22.
//
import SwiftUI
import Combine

@MainActor
final class AthleteListVM: ObservableObject {
    
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
    
    func fetchAthletes() {
        dataManager.fetchAthletes()
    }
}
