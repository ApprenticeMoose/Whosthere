////
////  AddSessionViewModel.swift
////  Whosthere
////
////  Created by Moose on 05.09.22.
////
//
//import Foundation
//import CoreData
//
//class AddSessionViewModel: ObservableObject {
//    
//    
//    
//    var context: NSManagedObjectContext
//    
//    init(context: NSManagedObjectContext) {
//        self.context = context
//    }
//    
//    @Published var sessionTime: Date = Date()
//    @Published var sessionDate: Date = Date()
//    @Published var selectedIndices = Set<Int>()
//    
//    //static let instance = AthletesListViewModel(context: context)
//    
//    func roundMinutesDown(date: Date) -> Date {
//        let calendar = Calendar.current
//        let minute = calendar.component(.minute, from: date)
//        return calendar.date(byAdding: .minute, value: (5 - minute % 5) - 5, to: date) ?? Date()
//        
//    }
//    
//    func mergeTimeAndDate(time: Date, date: Date) -> Date {
//        let calendar = Calendar.current
//        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
//        let dateComponents = calendar.dateComponents([.calendar, .year, .month, .day, .timeZone, .weekday, .weekOfYear], from: date)
//        let mergedDate = DateComponents(calendar: dateComponents.calendar, timeZone: dateComponents.timeZone, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute, weekday: dateComponents.weekday, weekOfYear: dateComponents.weekOfYear)
//        return roundMinutesDown(date: calendar.date(from: mergedDate) ?? Date())
//    }
//    
//    func save() {
//        do {
//            let newSession = SessionEntity(context: context)
//            newSession.id = UUID()
//            newSession.date = mergeTimeAndDate(time: sessionTime, date: sessionDate)
//            //newSession.athlete = [athlete[0]]
//            
//            try newSession.save()
//            
//        } catch {
//            print(error)
//        }
//    }
//}
