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
    
    var beginningOfTheWeek: Date {
        get {
            //findBeginningOfTheWeek(Mo/Su)
            //make it to 00:00
            //return
            return Date()
        }
    }
    
    
}

