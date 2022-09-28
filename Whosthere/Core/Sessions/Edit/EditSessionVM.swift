//
//  EditSessionVM.swift
//  Whosthere
//
//  Created by Moose on 27.09.22.
//

import SwiftUI
import Combine

@MainActor
final class EditSessionVM: ObservableObject {
    
    @Published var editedSession: Session
    
    @Published var sessionTime: Date
    @Published var sessionDate: Date
    @Published var selectedIndices = Set<Int>()
    //@Published var selectedIndices = [Int]()
    
    @Published private var dataManager: DataManager
    
    var anyCancellable: AnyCancellable? = nil
    
    init(session: Session?, dataManager: DataManager = DataManager.shared) {
        if let session = session {
            self.editedSession = session
        } else {
            self.editedSession = Session()
        }
        self.sessionDate = session?.date ?? Date()
        self.sessionTime = session?.date ?? Date()
        //self.selectedIndices = Set(session.athleteIDs.indices ?? Array(Set<Int>()))
        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    var athletes: [Athlete] {
        dataManager.athletesArray
    }
    
    func toggleAthlete(athlete: Athlete) {
        ///if toggled add it to the addedChapter.titleIDs Array and if it is already in there remove it from the array
        if editedSession.athleteIDs.contains(athlete.id) {
            editedSession.athleteIDs = editedSession.athleteIDs.filter({$0 != athlete.id})
        } else {
            editedSession.athleteIDs.append(athlete.id)
        }
    }
    
    //let enumerated = Array(zip(editSessionVM.athletes.indices, editSessionVM.athletes))
    
    
    
    
    func saveSession() {
        editedSession.date = mergeTimeAndDate(time: sessionTime, date: sessionDate)
        dataManager.updateAndSave(session: editedSession)
    }
    
    func deleteSession() {
            dataManager.delete(session: editedSession)
    }
    
    func roundMinutesDown(date: Date) -> Date {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        return calendar.date(byAdding: .minute, value: (5 - minute % 5) - 5, to: date) ?? Date()
        
    }
    
    func mergeTimeAndDate(time: Date, date: Date) -> Date {
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        let dateComponents = calendar.dateComponents([.calendar, .year, .month, .day, .timeZone, .weekday, .weekOfYear], from: date)
        let mergedDate = DateComponents(calendar: dateComponents.calendar, timeZone: dateComponents.timeZone, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute, weekday: dateComponents.weekday, weekOfYear: dateComponents.weekOfYear)
        return roundMinutesDown(date: calendar.date(from: mergedDate) ?? Date())
    }
}
