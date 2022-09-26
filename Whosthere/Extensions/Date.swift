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
}

