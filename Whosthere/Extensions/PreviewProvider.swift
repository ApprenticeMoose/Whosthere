//
//  PreviewProvider.swift
//  Whosthere
//
//  Created by Moose on 22.01.22.
//

import Foundation
import SwiftUI

extension PreviewProvider {

    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }

}

class DeveloperPreview {

    static let instance = DeveloperPreview()
    private init() { }

    let athletesVM = AthletesViewModel()
    
    let athlete = AthletesModel(firstName: "Mustafa", lastName: "Acar", birthday: .init(timeIntervalSince1970: 893796436), birthyear: 1998, gender: "male", showYear: false, noYear: false)
}

