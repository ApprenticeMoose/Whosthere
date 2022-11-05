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
    //@Published var detailIndex: Int
    
    @Published private var dataManager: DataManager
    
    @Published var detailAthlete: Athlete
    
    @Published var station: Station = Station()
    
    var anyCancellable: AnyCancellable? = nil
    
    init?(athlete: Athlete, dataManager: DataManager = DataManager.shared) {
        //self.detailIndex = athleteIndex
        self.detailAthlete = athlete
        self.dataManager = dataManager
        
        if let indexus = dataManager.athletesArray.firstIndex(where: { $0.id == detailAthlete.id })
        {
            print(indexus)
            self.index = indexus
        }
        else {
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
        self.detailAthlete = athlete2
        self.dataManager = dataManager2

        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        print("DetailVM initialized")
    }

    
    var index: Int = 0
    
//    {
//
//    }
    
    var detailedAthlete: Athlete = Athlete()
    
    func getSessions(with id: UUID?) -> Session? {
        guard let id = id else { return nil }
        return dataManager.getSession(with: id)
    }
}
