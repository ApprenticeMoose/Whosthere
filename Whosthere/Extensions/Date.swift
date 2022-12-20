//
//  Date.swift
//  Whosthere
//
//  Created by Moose on 25.09.22.
//

import Foundation

extension Date {
    func formatDateWeekday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        return dateFormatter.string(from: self)
    }
    
    var onlyDate: Date {
            get {
                let calender = Calendar.current
                var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
                dateComponents.timeZone = NSTimeZone.system
                return calender.date(from: dateComponents) ?? Date()
            }
        }
    
    func startOfWeek() -> Date {
        Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    func endOfWeek() -> Date {
        let startOfWeek = Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
        let nearlyEndOfWeek = Calendar.current.date(byAdding: .day, value: 7, to: startOfWeek) ?? Date()
        return Calendar.current.date(byAdding: .minute, value: -1, to: nearlyEndOfWeek) ?? Date()
    }
    
    func extractWeek() -> Int {
        let week = Calendar.current.component(.weekOfYear, from: self)
        return week
    } //get the Int of the week from any date that is entered
    
    func extractYear() -> Int {
        let year = Calendar.current.component(.year, from: self)
        return year
    } //get the Int of the week from any date that is entered
    
    
    func isInCurrentWeek() -> Bool {
        return self.extractWeek() == Date().extractWeek() && self.extractYear() == Date().extractYear()
    }
    
    func isInPastWeeks() -> Bool {
        return self.extractWeek() < Date().extractWeek() || self.extractYear() < Date().extractYear()
    }
    
    func isInUpcomingWeeks() -> Bool {
        return self.extractWeek() > Date().extractWeek() || self.extractYear() > Date().extractYear()
    }
       var year: Int? {
           let calendar = Calendar.current
           let currentComponents = calendar.dateComponents([.year], from: self)
           return currentComponents.year
       }
    
  

}

