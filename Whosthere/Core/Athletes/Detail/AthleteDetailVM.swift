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
    
    //Need to pull it from the titles array from the datamanger as a array[whateverid]
    @Published var detailIndex: Int
    
    @Published private var dataManager: DataManager
    
    var anyCancellable: AnyCancellable? = nil
    
    init(athleteIndex: Int, dataManager: DataManager = DataManager.shared) {
        self.detailIndex = athleteIndex
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    var detailAthlete: Athlete {
        dataManager.athletesArray[detailIndex]
    }
    
    func getSessions(with id: UUID?) -> Session? {
        guard let id = id else { return nil }
        return dataManager.getSession(with: id)
    }
}
