//
//  PhotopickertestApp.swift
//  Photopickertest
//
//  Created by Moose on 20.11.21.
//

import SwiftUI

@main
struct AthleteApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    var dataManager = DataManager.shared
    
    init() {
        UserDefaults.standard.register(defaults: ["launchedOnce": true])
        UserDefaults.standard.set(true, forKey: "launchedOnce")
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemBlue
        }
    
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                    .environmentObject(AppState())
                    .environmentObject(TabDetailVM())
            
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("Active")
            case .inactive:
                print("Inactive")
                dataManager.saveData()
            case .background:
                print("background")
                dataManager.saveData()
            default:
                print("unknown")
            }
        }
    }
}
