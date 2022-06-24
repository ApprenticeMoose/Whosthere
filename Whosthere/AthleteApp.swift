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
                TabTabView()
                    .navigationBarHidden(true)
            }
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(AthletesViewModel())
            
        }
    }
}
