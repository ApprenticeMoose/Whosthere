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
    @Published var arrayOfSessions = [Session]()
    @Published var allSessions = [Session]()
    
    var index: Int = 0
    var detailedAthlete: Athlete = Athlete()
    var anyCancellable: AnyCancellable? = nil
    
    
    init?(athlete: Athlete, dataManager: DataManager = DataManager.shared) {
        self.detailedAthlete = athlete
        self.dataManager = dataManager
        fetchAthlete()
        getAllSessions()
        createArrayOfAllSessions()
        //print(sessionBarHeights)
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

    
    func getAllSessions(){
       allSessions = dataManager.sessionsArray
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
    
    func createArrayOfAllSessions() {
        var sessions: [Session] = []
        for sessionID in detailedAthlete.sessionIDs {
            if let session = getSessions(with: sessionID) {
                sessions.append(session)
            }
        }
        arrayOfSessions = sessions
    }
}
