//
//  WeekService.swift
//  Whosthere
//
//  Created by Moose on 26.08.22.
//
import Foundation

class DatesVM: ObservableObject {
    
    //MARK: - Varibales for DateSelection
    
    // - FIXME: need to initialuze the selectedday on every view
    @Published var selectedDay: Date =  Date()
    @Published var scrollToIndex: Int = 3
    @Published var wholeWeeks: [[Date]] = []
    
    @Published var scrollToIndexOfSessions: Date =  Date()
    @Published var indexOfToday: Date = Date()
    @Published var dayToScrollTo: Date = Date()
    
    @Published var station: Station = Station()
    
    var calendar = Calendar.current
    
    @Published var arrayOfDatesToPick1: [Date] = []
    @Published var arrayOfDatesToPick2: [Date] = []
    
    init(){
        //Init for DateSelection
        self.calendar.firstWeekday = 2                          //To set start of week to monday
        self.calendar.minimumDaysInFirstWeek = 4
        fetchAllDays()                                          //fetches 7 arrays for the buttons each with the 7days that are
        setButtonAtLaunch()
        (-100...100).forEach { week in
            if let days1 = calendar.date(byAdding: .weekOfYear, value: week, to: Date().startOfWeek()){
                arrayOfDatesToPick1.append(days1)
            }
            if let days2 = calendar.date(byAdding: .weekOfYear, value: week, to: Date().endOfWeek()){
                arrayOfDatesToPick2.append(days2)
            }
        }
    }
    
    
    
    
    //MARK: - DateSelectionFunctions
    
    func setButtonAtLaunch() {
            let current = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
                selectedDay = current

            return scrollToIndex = 3

        }//used to set the selectedday as the first day of the week, so the buttons can be painted correctly concerning their selected state...could need rework in future if the start date is supposed to be todays date and not the first date of the week
   
    func fetchAllDays() {
        let thisWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDay)
        
        guard let firstDayOfWeek = thisWeek?.start else {
            return print("failure")
        }
        var weekArray: [Date] = []
  
        
        (-3...3).forEach { week in
            if let weekday = calendar.date(byAdding: .weekOfYear, value: week, to: firstDayOfWeek){
                
                
                (0...6).forEach { dayz in
                    if let days = calendar.date(byAdding: .day, value: dayz, to: weekday){
                        
                        weekArray.append(days)
                    }
                }
                
                wholeWeeks.append(weekArray)
                weekArray.removeAll()
            }
        }
        
    }  //fetching all days from todays date current week and 3 weeks in the past and future and putting it into the wholeWeeks Array as 7 Arrays each  containting 7 Days in an Array...used to set the Buttons to select the current week dynamically
    
    func extractWeek(date: Date) -> Int {
        let week = calendar.component(.weekOfYear, from: date)
        return week
    } //get the Int of the week from any date that is entered
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }//function to convert Dates into Strings to be used in text etc with formatting via "dd", "MMM", etc
    
    func extractDateWithoutTime(date: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.calendar, .year, .month, .day, .timeZone, .weekday, .weekOfYear], from: date)
        return calendar.date(from: DateComponents(calendar: dateComponents.calendar, timeZone: dateComponents.timeZone, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)) ?? Date()
    }
    
    func checkCurrentWeek(dates: [Date], dateSelected: Date) -> Bool {
        var isInWeek: Bool = false
        
        for i in dates {
            if i == dateSelected {
                isInWeek = true
            }
        }
        return isInWeek
    }//run the array of weekdates through the for loop which singles out if the currently selected date is in this array
    func setDateToStartOfWeek(date: Date) -> Date {
        return calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? Date()
    }
    
    
    //MARK: - DatesInAddSessionFunctions
    
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
    
    func setDateToTomorrow() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    }
}
