//
//  AthletesError.swift
//  Whosthere
//
//  Created by Moose on 20.03.22.
//

import Foundation

enum AthletesError: Error, LocalizedError {
    case saveError
    case readError
    case decodingError
    case encodingError
    
    var errorDescription: String? {
        switch self {
        case .saveError:
            return NSLocalizedString("Could not save Athletes, please reinstall the app.", comment: "")
        case .readError:
            return NSLocalizedString("Could not save Athletes, please reinstall the app.", comment: "")
        case .decodingError:
            return NSLocalizedString("There was a problem loading your athletes, please create a new athlete to start over.", comment: "")
        case .encodingError:
            return NSLocalizedString("Could not save Athletes, please reinstall the app.", comment: "")
        }
    }
}

struct ErrorType: Identifiable {
    var id = UUID()
    var error: AthletesError
}
