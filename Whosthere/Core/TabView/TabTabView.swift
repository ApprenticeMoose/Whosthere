//
//  TabTabView.swift
//  Whosthere
//
//  Created by Moose on 24.06.22.
//

import SwiftUI

struct TabTabView: View {
    
    @StateObject var tabData = TabViewModel()
    
    let viewContext = CoreDataManager.shared.persistentStoreContainer.viewContext
    
    
    // Hiding Tab View...
    init(){
        UITabBar.appearance().isHidden = true
    }
    
   @Namespace var animation
    
    var body: some View {
        
        TabView(selection: $tabData.currentTab) {
            
            Text("Sessions")
                .tag("Sessions")
                .navigationTitle("")
                .navigationBarHidden(true)
            
            Text("Statistics")
                .tag("Statistics")
                .navigationTitle("")
                .navigationBarHidden(true)
            
            AthletesListView(vm: AthletesListViewModel(context: viewContext))
                .tag("Athletes")
                .navigationTitle("")
                .navigationBarHidden(true)
            //need to induce this EnvironmentObject so everything from AthletesListView onwards can use it for Navigation with @EnvironmentObject
                .environmentObject(AppState())
            
            Text("Settings")
                .tag("Settings")
                .navigationTitle("")
                .navigationBarHidden(true)
            
            
        }
        .navigationBarHidden(true)
        .overlay(

            HStack{

                TabTabBarButton(title: "Sessions", image: "doc.text", animation: animation)

                TabTabBarButton(title: "Statistics", image: "chart.xyaxis.line", animation: animation)

                TabTabBarButton(title: "Athletes", image: "person.3", animation: animation)
                
                TabTabBarButton(title: "Settings", image: "gearshape", animation: animation)
            }
            .environmentObject(tabData)
                .padding(.vertical,14)
                .padding(.horizontal)
                .background(Color.accentColor)
                .background(.regularMaterial,in: Capsule())
                .padding(.horizontal,20)
                .padding(.bottom,12)
            // Shadow...
                .shadow(color: .black.opacity(0.09), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.09), radius: 5, x: -5, y: 0)
            // Hiding Tab Bar...
                .offset(y: tabData.showDetail ? 250 : 0)
            // always light tab bar ...
               // .colorScheme(.light)

            ,alignment: .bottom
        )
        .navigationBarHidden(true)
    }
}


 //TabBarButton...
struct TabTabBarButton: View{

    var title: String
    var image: String
    // For Slide Tab Indicator Aniamtion...
    var animation: Namespace.ID
    @EnvironmentObject var tabData: TabViewModel

    var body: some View{

        Button {

            withAnimation{
                tabData.currentTab = title
            }

        } label: {

            VStack{

                Image(systemName: image)
                    .font(.title2)
                // setting same height for all images...
                // to avoid the animation glitch..
                    .frame(height: 18)

                Text(title)
                    .font(.caption.bold())
            }
            .foregroundColor(tabData.currentTab == title ? Color.orangeAccentColor : Color.greyFourColor)
            .frame(maxWidth: .infinity)
        }

    }
}



