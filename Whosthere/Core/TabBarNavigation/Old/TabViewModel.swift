//
//  TabViewModel.swift
//  Whosthere
//
//  Created by Moose on 24.06.22.
//

import Foundation
import SwiftUI

class TabViewModel: ObservableObject {
    
    @Published var currentTab = "Athletes"
    @Published var showDetail: Bool = false
}

