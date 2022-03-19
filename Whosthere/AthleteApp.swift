//
//  PhotopickertestApp.swift
//  Photopickertest
//
//  Created by Moose on 20.11.21.
//

import SwiftUI

@main
struct AthleteApp: App {
    
    //@StateObject private var athletesViewModel = AthletesViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
            AthletesListView()
                .navigationBarHidden(true)
            }
            .environmentObject(AthletesViewModel())
        }
    }
}
