//
//  WeekService.swift
//  Whosthere
//
//  Created by Moose on 26.08.22.
//

import Foundation

class SessionsViewModel: ObservableObject {
    
    //MARK: - Varibales for DateSelection
    @Published var selectedDay: Date =  Date()
    @Published var scrollToIndex: Int = 3
    @Published var wholeWeeks: [[Date]] = []
    
    var calendar = Calendar.current
    
    init(){
        //Init for DateSelection
        self.calendar.firstWeekday = 2                          //To set start of week to monday
        self.calendar.minimumDaysInFirstWeek = 4
        fetchAllDays()                                          //fetches 7 arrays for the buttons each with the 7days that are
        setButtonAtLaunch()
        
    }

    
    //MARK: - DateSelectionFunctions
    
    
    //used to set the selectedday as the first day of the week, so the buttons can be painted correctly concerning their selected state...could need rework in future if the start date is supposed to be todays date and not the first date of the week
    func setButtonAtLaunch() {
            let current = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
                selectedDay = current

            return scrollToIndex = 3

        }
    
    //fetching all days from todays date current week and 3 weeks in the past and future and putting it into the wholeWeeks Array as 7 Arrays each  containting 7 Days in an Array...used to set the Buttons to select the current week dynamically
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
    func checkCurrentWeek(dates: [Date], dateSelected: Date) -> Bool {
        var isInWeek: Bool = false
        
        for i in dates {
            if i == dateSelected {
                isInWeek = true
            }
        }
        return isInWeek
    }
}

