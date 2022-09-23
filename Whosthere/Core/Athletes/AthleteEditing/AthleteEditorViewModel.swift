//
//  AthleteEditorViewModel.swift
//  Whosthere
//
//  Created by Moose on 06.09.22.
//
import SwiftUI
import Combine

@MainActor
final class AthleteEditorViewModel: ObservableObject {
    
    @Published var addedAthlete: Athlete
    
    @Published var birthYear = Calendar.current.component(.year, from: Date())
    
    @Published private var dataManager: DataManager
    
    var anyCancellable: AnyCancellable? = nil
    
    init(athlete: Athlete?, dataManager: DataManager = DataManager.shared) {
        if let athlete = athlete {
            self.addedAthlete = athlete
        } else {
            self.addedAthlete = Athlete()
        }
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    func saveAthlete() {
        dataManager.updateAndSave(athlete: addedAthlete)
    }
    
    func deleteAthlete() {
            dataManager.delete(athlete: addedAthlete)
    }

    func fetchAthletes() {
        dataManager.fetchAthletes()
    }
    
    func textIsAppropriate() -> Bool {
        if addedAthlete.firstName.count >= 2 && addedAthlete.lastName.count >= 1 {
            return true
        }
        return false
    }
    
    //function to adjust the year variable according to the selected birthdate variable->is called when add athlete button is pressed
    func getBirthYear() -> Int {
        if addedAthlete.birthday != Date()
            {
            birthYear = Calendar.current.component(.year, from: addedAthlete.birthday)
            }
        return birthYear
    }
}
