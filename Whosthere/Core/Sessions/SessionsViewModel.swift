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
    @Published var selectedDay: Date = (Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date())
    @Published var scrollToIndex: Int = 3
    
    @Published var wholeWeeks: [[Date]] = []
    
    var calendar = Calendar.current
    
    init(){
        self.calendar.firstWeekday = 2
        self.calendar.minimumDaysInFirstWeek = 4
        fetchAllDays()
        setButtonAtLaunch()
        
    }

    func setButtonAtLaunch() {
            let current = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
                selectedDay = current
            
            return scrollToIndex = 3
    
        }
    
    func fetchAllDays() {
        let thisWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDay)
        
        guard let firstDayOfWeek = thisWeek?.start else {
            return
        }
        var weekArray: [Date] = []
  
        
        (-3...3).forEach { day in
            if let weekday = calendar.date(byAdding: .weekOfYear, value: day, to: firstDayOfWeek){
                
                
                (0...6).forEach { dayz in
                    if let days = calendar.date(byAdding: .day, value: dayz, to: weekday){
                        //create an array of all days and then append this to wholeweeks etc
                        
                        weekArray.append(days)
                    }
                }
                wholeWeeks.append(weekArray)
                weekArray.removeAll()
            }
        }
        
    }
    
    //get the Int of the week from any date that is entered
    func extractWeek(date: Date) -> Int {
        let week = calendar.component(.weekOfYear, from: date)
        return week
    }
    
    //function to convert Dates into Strings to be used in text etc with formatting via "dd", "MMM", etc
    func extractDate(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    //run the array of weekdates through the for loop which singles out if the currently selected date is in this array
    func checkCurrentWeek(dates: [Date]) -> Bool {
        
        var date: Date = Date()
        
        for i in dates {
            
            if i == selectedDay {
                date = i
                break
            }
        }
        
        return calendar.isDate(selectedDay, inSameDayAs: date)
    }
}

