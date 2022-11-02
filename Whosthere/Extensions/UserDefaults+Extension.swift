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


import Combine

// define key for observing
extension UserDefaults {
    private enum UserDefaultsKeys: String {
           case sortAthletes
       }
    
    @objc dynamic private(set) var observableSortAthletesData: Data? {
                get {
                    UserDefaults.standard.data(forKey: UserDefaultsKeys.sortAthletes.rawValue)
                }
                set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.sortAthletes.rawValue) }
            }
    
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
}

class Station: ObservableObject {
    @Published var sortAthletes: Sort = (UserDefaults.standard.sortAthletes ?? Sort.firstNameFromA) {
        didSet {
            UserDefaults.standard.sortAthletes = sortAthletes
        }
    }
    
    init() {
        UserDefaults.standard.publisher(for: \.observableSortAthletesData)
            .map{ data -> Sort in
                guard let data = data else {return Sort.firstNameFromA }
                return (try? JSONDecoder().decode(Sort.self, from: data)) ?? Sort.firstNameFromA
            }
            .receive(on: RunLoop.main)
            .assign(to: &$sortAthletes)

    }
}

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
