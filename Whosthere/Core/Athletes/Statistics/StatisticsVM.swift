//
//  StatisticsVM.swift
//  Whosthere
//
//  Created by Moose on 19.12.22.
//

import Foundation
import Combine
import OrderedCollections

@MainActor
final class StatisticsVM: ObservableObject {
    
    // - MARK: Variables
    
    @Published var modifiedSessions = [Session]()
    
    @Published var athletesWithSessions = [(Athlete, Float)]()
    
    @Published var distributionSessions = [[Session]]() //1= Sonntag, 7= Samstag
    @Published var sessionBarHeights: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    
    @Published var attendedDistribution = [(Float, Float)]() //[(numberOfAttendedSessionOfDay, AllSessionsOfDay)]
    @Published var sessionAttendeddBarHeights: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    @Published var averageAttendedDistributionNumber : Float = 1.0
    
    // - MARK: DataManager related
    
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
    
    // - MARK: Functions
    
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
    
    func getSessions(with id: UUID?) -> Session? {
        guard let id = id else { return nil }
        return dataManager.getSession(with: id)
    }
    
    func getAthleteSessionsListContent() {
        athletesWithSessions.removeAll()
        for athlete in athletes {
            
            var sessions: [Session] = []
            var finalSessions: [Session] = []
            for sessionID in athlete.sessionIDs {
                if let session = getSessions(with: sessionID) {
                    sessions.append(session)
                }
            }
            for session in sessions {
                if modifiedSessions.contains(session) {
                    finalSessions.append(session)
                }
            }
            
            var endDate: Date {
                if UserDefaults.standard.dateFilterStatistics?.date2 ?? Date() > Date().endOfWeek() {
                    return Date().endOfWeek()
                } else {
                    return UserDefaults.standard.dateFilterStatistics?.date2 ?? Date()
                }
            }
            
            
            
            if UserDefaults.standard.string(forKey: "statisticsPerX") == PerRange.total.rawValue {
                athletesWithSessions.append((athlete , Float(finalSessions.count)))
            } else if UserDefaults.standard.string(forKey: "statisticsPerX") == PerRange.perMonth.rawValue {
                let perMonthNumber = Float(finalSessions.count) / (Float(Calendar.current.numberOfDaysBetween(UserDefaults.standard.dateFilterStatistics?.date1 ?? Date(), and: endDate)) / 30.436875)
                athletesWithSessions.append((athlete , round(perMonthNumber * 10) / 10.0))
            } else if UserDefaults.standard.string(forKey: "statisticsPerX") == PerRange.perWeek.rawValue {
                let perWeekNumber = Float(finalSessions.count) / Float(Calendar.current.numberOfDaysBetween(UserDefaults.standard.dateFilterStatistics?.date1 ?? Date(), and: endDate) / 7)
                athletesWithSessions.append((athlete , round(perWeekNumber * 10) / 10.0))
            }
            
        }
    }
    
    func getDistributionData() {
        
// fillDistributedSessions
        
        var sessionsForWeekdays: [Session] = []
        var distributedSessions = [[Session]]()
        (1...7).forEach { day in
            (modifiedSessions).forEach { session in
                
                if Calendar.current.dateComponents([.weekday], from: session.date).weekday == day {
                    sessionsForWeekdays.append(session)
                }
            }
            
            distributedSessions.append(sessionsForWeekdays)
            sessionsForWeekdays.removeAll()
        }
        distributionSessions = distributedSessions
        
//fillSessionsBarHeights
        
        var sessionsCount: [Int] = []
        (distributionSessions).forEach { sessions in
            let count = sessions.count
            sessionsCount.append(count)
        }
        
        guard let largestCount = sessionsCount.max() else {
            return print("no largest count")
        }
        var barHeightsProviso = [Float]()
        
        (sessionsCount).forEach { sessionCount in
            
            var height: Float = (Float(sessionCount) / Float(largestCount)) * 100
            
            if height == 0 {
                height += 1
            }
            barHeightsProviso.append(height)
        }
        sessionBarHeights = barHeightsProviso
        
//fillAttendedSessions
        
        var placeholderForAthletesSessionsCount = [[Int]]()
        
        for athlete in athletes {
            
            var attendedSessionsForWeekdays: [Session] = []
            var attendedDistributedSessions = [Int]()
            
            var sessions: [Session] = []
            var finalSessions: [Session] = []
            
            for sessionID in athlete.sessionIDs {
                if let session = getSessions(with: sessionID) {
                    sessions.append(session)
                }
            }
            for session in sessions {
                if modifiedSessions.contains(session) {
                    finalSessions.append(session)
                }
            }
            
            
            (1...7).forEach { day in
                (finalSessions).forEach { session in
                    
                    if Calendar.current.dateComponents([.weekday], from: session.date).weekday == day {
                        attendedSessionsForWeekdays.append(session)
                    }
                }
                
                attendedDistributedSessions.append(attendedSessionsForWeekdays.count)
                attendedSessionsForWeekdays.removeAll()
            }
            
            placeholderForAthletesSessionsCount.append(attendedDistributedSessions)
            
        }
        
        //add all 0, 1, etc indexes of all arrays in the placeholderthing and divide by the number of arrays in the placeholder array-> thats the .0 in the tuple
        for index in 0...6 {
            var weekdayAttendance = [Int]()
            var numberOfAthletes: Int = 0
            placeholderForAthletesSessionsCount.forEach { array in
                
                weekdayAttendance.append(array[index])
                numberOfAthletes += 1
            }
            
           let athletesAttendance = Float(weekdayAttendance.reduce(0, +)) // / Float(numberOfAthletes) if
            
            attendedDistribution.append(( athletesAttendance, Float(distributedSessions[index].count)))
            weekdayAttendance.removeAll()
            numberOfAthletes = 0
        }
        
//fillSessionsBarHeights
        
        var attendedCount: [Float] = []
        
        attendedDistribution.forEach { value in
            let count = value.0 / value.1
            attendedCount.append(count)
        }
        
        guard let largestAttendedCount = attendedCount.max() else {
            return print("no largest count")
        }
        var barHeightsBetween = [Float]()
        
        (attendedCount).forEach { attendedCount in
            
            var height: Float = (Float(attendedCount) / Float(largestAttendedCount)) * 100
            
            if height == 0 {
                height += 1
            }
            barHeightsBetween.append(height)
        }
        sessionAttendeddBarHeights = barHeightsBetween

//getAverageAttendedNumber
        var arrayHolder = [Float]()
        for index in 0...6 {
            arrayHolder.append(attendedDistribution[index].0 / attendedDistribution[index].1)
        }
        averageAttendedDistributionNumber = arrayHolder.reduce(0, +) / 7.0
    }
    
   /*func getAverageAttendedNumber() -> Float {
       // (viewModel.attendedDistribution[index].0 / viewModel.attendedDistribution[index].1).clean
        var arrayHolder = [Float]()
        for index in 0...6 {
            arrayHolder.append(attendedDistribution[index].0 / attendedDistribution[index].1)
        }
        return arrayHolder.reduce(0, +) / 7.0
    }*/
}
