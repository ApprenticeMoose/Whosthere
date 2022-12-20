//
//  TabModel.swift
//  Whosthere
//
//  Created by Moose on 05.08.22.
//

import SwiftUI


struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: String
    var tab: Tab
    
}

var tabItems = [
    TabItem(text: "Sessions", icon: "doc.text", tab: .sessions),
  //  TabItem(text: "Statistics", icon: "chart.xyaxis.line", tab: .statistics),
    TabItem(text: "Athletes", icon: "person.3", tab: .athletes),
    TabItem(text: "Settings", icon: "gearshape", tab: .settings)
]

enum Tab: String {
    case sessions
   /* case statistics*/
    case athletes
    case settings
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat){
        value = nextValue()
    }
}
