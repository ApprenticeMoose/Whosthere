//
//  UserDefaults+Extension.swift
//  Whosthere
//
//  Created by Moose on 19.10.22.
//
import Foundation

enum Sort: Codable {
    case dateAddedFromOldest, dateAddedFromNewest, firstNameFromA, firstNameFromZ, genderFemaleFirst, genderMaleFirst
 }

enum PerX: Codable {
    case perWeek, perMonth, total
}

enum ShowAttended: Codable {
    case attendedPercent, attendedNumber
}

enum StatisticsPerX: String {
    case perWeek, perMonth, total
}

struct PickerDates: Codable {
    let date1: Date
    let date2: Date
}

import Combine

// define key for observing
extension UserDefaults {
//Step 1
    private enum UserDefaultsKeys: String {
           case sortAthletes
           case attendanceFilteredDates
           case statisticsFilterDates
           case perXAttendance
           case xAttendedDistribution
           
       }
    
//Step 2
    @objc dynamic private(set) var observableSortAthletesData: Data? {
                get {
                    UserDefaults.standard.data(forKey: UserDefaultsKeys.sortAthletes.rawValue)
                }
                set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.sortAthletes.rawValue) }
            }
    
    @objc dynamic private(set) var observableDateFilterAttendanceData: Data? {
                get {
                    UserDefaults.standard.data(forKey: UserDefaultsKeys.attendanceFilteredDates.rawValue)
                }
                set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.attendanceFilteredDates.rawValue) }
            }
    
    @objc dynamic private(set) var observableStatisticsDateFilterData: Data? {
                get {
                    UserDefaults.standard.data(forKey: UserDefaultsKeys.statisticsFilterDates.rawValue)
                }
                set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.statisticsFilterDates.rawValue) }
            }
    
    @objc dynamic private(set) var observablePerXAttendanceData: Data? {
                get {
                    UserDefaults.standard.data(forKey: UserDefaultsKeys.perXAttendance.rawValue)
                }
                set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.perXAttendance.rawValue) }
            }
    
    @objc dynamic private(set) var observableXAttendedDistributionData: Data? {
                get {
                    UserDefaults.standard.data(forKey: UserDefaultsKeys.xAttendedDistribution.rawValue)
                }
                set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.xAttendedDistribution.rawValue) }
            }
//Step 3
     var sortAthletes: Sort? {
        get {
            if let data = object(forKey:
                                    UserDefaultsKeys.sortAthletes.rawValue) as? Data {
                let sort = try? JSONDecoder().decode(Sort.self, from: data)
                return sort
            }
            return nil
        }

        set {
            observableSortAthletesData = try? JSONEncoder().encode(newValue)
        }
    }
    
    var dateFilterAttendance: PickerDates? {
       get {
           if let data = object(forKey:
                                   UserDefaultsKeys.attendanceFilteredDates.rawValue) as? Data {
               let filter = try? JSONDecoder().decode(PickerDates.self, from: data)
               return filter
           }
           return nil
       }

       set {
           observableDateFilterAttendanceData = try? JSONEncoder().encode(newValue)
       }
   }
    
    var dateFilterStatistics: PickerDates? {
       get {
           if let data = object(forKey:
                                   UserDefaultsKeys.statisticsFilterDates.rawValue) as? Data {
               let filter = try? JSONDecoder().decode(PickerDates.self, from: data)
               return filter
           }
           return nil
       }

       set {
           observableStatisticsDateFilterData = try? JSONEncoder().encode(newValue)
       }
   }

    var perXAttendance: PerX? {
       get {
           if let data = object(forKey:
                                   UserDefaultsKeys.perXAttendance.rawValue) as? Data {
               let perX = try? JSONDecoder().decode(PerX.self, from: data)
               return perX
           }
           return nil
       }

       set {
           observablePerXAttendanceData = try? JSONEncoder().encode(newValue)
       }
   }
    
    var xAttendedDistibution: ShowAttended? {
       get {
           if let data = object(forKey:
                                   UserDefaultsKeys.xAttendedDistribution.rawValue) as? Data {
               let xAttended = try? JSONDecoder().decode(ShowAttended.self, from: data)
               return xAttended
           }
           return nil
       }

       set {
           observableXAttendedDistributionData = try? JSONEncoder().encode(newValue)
       }
   }
}

class Station: ObservableObject {
//Step 4
    @Published var sortAthletes: Sort = (UserDefaults.standard.sortAthletes ?? Sort.firstNameFromA) {
        didSet {
            UserDefaults.standard.sortAthletes = sortAthletes
        }
    }
    
    @Published var dateFilterAttendance: PickerDates = (UserDefaults.standard.dateFilterAttendance ?? PickerDates(date1: Date().startOfWeek(), date2: Date().endOfWeek())) {
        didSet {
            UserDefaults.standard.dateFilterAttendance = dateFilterAttendance
        }
    }
    
    @Published var dateFilterStatistics: PickerDates = (UserDefaults.standard.dateFilterStatistics ?? PickerDates(date1: Date().startOfWeek(), date2: Date().endOfWeek())) {
        didSet {
            UserDefaults.standard.dateFilterStatistics = dateFilterStatistics
        }
    }
    
    @Published var perXAttendance: PerX = (UserDefaults.standard.perXAttendance ?? PerX.total) {
        didSet {
            UserDefaults.standard.perXAttendance = perXAttendance
        }
    }
    
    @Published var xAttendedDistribution: ShowAttended = (UserDefaults.standard.xAttendedDistibution ?? ShowAttended.attendedNumber) {
        didSet {
            UserDefaults.standard.xAttendedDistibution = xAttendedDistribution
        }
    }
    
    var cancellables = Set<AnyCancellable>()
//Step 5
    init() {
//sortAthletesSession
        UserDefaults.standard.publisher(for: \.observableSortAthletesData)
            .map{ data -> Sort in
                guard let data = data else {return Sort.firstNameFromA }
                return (try? JSONDecoder().decode(Sort.self, from: data)) ?? Sort.firstNameFromA
            }
            .receive(on: RunLoop.main)
            .assign(to: &$sortAthletes)
        
//dateFilterAttendance
        UserDefaults.standard.publisher(for: \.observableDateFilterAttendanceData)
            .map{ data -> PickerDates in
                guard let data = data else {return PickerDates(date1: Date().startOfWeek(), date2:Date().endOfWeek()) }
                return (try? JSONDecoder().decode(PickerDates.self, from: data)) ?? PickerDates(date1: Date().startOfWeek(), date2: Date().endOfWeek())
            }
            .receive(on: RunLoop.main)
            .assign(to: &$dateFilterAttendance)
        
//dateFilterDistribution
        UserDefaults.standard.publisher(for: \.observableStatisticsDateFilterData)
            .map{ data -> PickerDates in
                guard let data = data else {return PickerDates(date1: Date().startOfWeek(), date2: Date().endOfWeek()) }
                return (try? JSONDecoder().decode(PickerDates.self, from: data)) ?? PickerDates(date1: Date().startOfWeek(), date2: Date().endOfWeek())
            }
            .receive(on: RunLoop.main)
            .assign(to: &$dateFilterStatistics)
        
//perXAttendance
        UserDefaults.standard.publisher(for: \.observablePerXAttendanceData)
            .map{ data -> PerX in
                guard let data = data else {return PerX.total }
                return (try? JSONDecoder().decode(PerX.self, from: data)) ?? PerX.total
            }
            .receive(on: RunLoop.main)
            .assign(to: &$perXAttendance)
        
//XAttendedDistribution
            UserDefaults.standard.publisher(for: \.observableXAttendedDistributionData)
                .map{ data -> ShowAttended in
                    guard let data = data else {return ShowAttended.attendedNumber }
                    return (try? JSONDecoder().decode(ShowAttended.self, from: data)) ?? ShowAttended.attendedNumber
                }
                .receive(on: RunLoop.main)
                .assign(to: &$xAttendedDistribution)
    }
}

//!!!! use UserDefault to call values and station to set values
//where this comes from
/*
mainly:
https://stackoverflow.com/questions/73391756/fatal-error-when-publishing-userdefaults-with-combine
a little:
https://stackoverflow.com/questions/62713150/how-to-observe-changes-in-userdefaults
https://www.youtube.com/watch?v=LUcXaGL-X00
some:
https://sarunw.com/posts/how-to-save-enum-associated-value-in-userdefaults-using-swift/
*/
