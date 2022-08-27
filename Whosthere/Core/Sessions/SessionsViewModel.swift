//
//  WeekService.swift
//  Whosthere
//
//  Created by Moose on 26.08.22.
//

import Foundation

class SessionsViewModel: ObservableObject {
    
    @Published var shownWeeksFirstDay: [Date] = []
    @Published var shownWeeksLastDay: [Date] = []
    @Published var shownWeek: [Int] = []
    @Published var currentWeek: Date = (Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date())
    @Published var scrollToIndex: Int = 0
    
    var calendar = Calendar.current
    
    init(){
        self.calendar.firstWeekday = 2
        self.calendar.minimumDaysInFirstWeek = 4
        fetchShownWeeksFirstDay()
        isCurrentWeek()
    }
    
    func isCurrentWeek() {
        let current = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
            currentWeek = current
        return scrollToIndex = shownWeeksFirstDay.firstIndex(where: {$0 == self.currentWeek}) ?? 0
    }
    
    func fetchShownWeeksFirstDay() {
        let currentWeek = calendar.dateInterval(of: .weekOfYear, for: Date())
        
        guard let firstWeekday = currentWeek?.start else {
            return
        }

        (-3...3).forEach { day in
            if let weekday = calendar.date(byAdding: .weekOfYear, value: day, to: firstWeekday){
                shownWeeksFirstDay.append(weekday)
                
                var comps2 = DateComponents()
                comps2.weekOfYear = 1
                comps2.day = -1
                if let endOfWeek = calendar.date(byAdding: comps2, to: weekday) {
                shownWeeksLastDay.append(endOfWeek)
                    
                    }
                }
            }
        }
    
    func extractWeek(date: Date) -> Int {
        let week = calendar.component(.weekOfYear, from: date)
        return week
    }
    
    func extractDate(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func checkCurrentWeek(date: Date) -> Bool {
        return calendar.isDate(currentWeek, inSameDayAs: date)
    }
}

