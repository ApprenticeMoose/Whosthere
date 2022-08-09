//
//  PhotopickertestApp.swift
//  Photopickertest
//
//  Created by Moose on 20.11.21.
//

import SwiftUI

@main
struct AthleteApp: App {
    
    var body: some Scene {
        WindowGroup {
            
            let viewContext = CoreDataManager.shared.persistentStoreContainer.viewContext
            
            
            ContentView()
                    .environmentObject(AppState())
                    .environment(\.managedObjectContext, viewContext)
                    .environmentObject(TabDetailVM())
            
            
        }
    }
}
