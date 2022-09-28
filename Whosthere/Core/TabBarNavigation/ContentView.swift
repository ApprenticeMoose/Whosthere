//
//  ContentView.swift
//  Whosthere
//
//  Created by Moose on 05.08.22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .sessions
//    @Environment(\.managedObjectContext) var viewContext
//    @EnvironmentObject var athletesListVM: AthletesListViewModel
    @EnvironmentObject var tabDetail: TabDetailVM

    var body: some View {
        ZStack(alignment: .bottom) {
            
                switch selectedTab {
                case .sessions:
                    
                    SessionsHomeView(datesVM: DatesVM())
                case .statistics:
                    StatisticsOverview()
                case .athletes:
                    AthleteListView()
                case .settings:
                    SettingsOverView()
                }
            
                TabBar()
                    .offset(y: _tabDetail.wrappedValue.showDetail ? 200 : 62)
            
            
            
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Color.clear.frame(height: 44)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
