//
//  AddSessionViewModel.swift
//  Whosthere
//
//  Created by Moose on 05.09.22.
//

import SwiftUI
import Combine

@MainActor
final class AddSessionVM: ObservableObject {
    
    @Published var addedSession: Session = Session()
    
    @Published var sessionTime: Date = Date()
    @Published var sessionDate: Date = Date()
    @Published var selectedIndices = Set<Int>()
    
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
    
    func toggleAthlete(athlete: Athlete) {
        ///if toggled add it to the addedChapter.titleIDs Array and if it is already in there remove it from the array
        if addedSession.athleteIDs.contains(athlete.id) {
            addedSession.athleteIDs = addedSession.athleteIDs.filter({$0 != athlete.id})
        } else {
            addedSession.athleteIDs.append(athlete.id)
        }
    }
    
    func saveSession() {
        addedSession.date = mergeTimeAndDate(time: sessionTime, date: sessionDate)
        dataManager.updateAndSave(session: addedSession)
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
