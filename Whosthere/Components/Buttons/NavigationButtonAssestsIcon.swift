//
//  NavigationButtonAssestsIcon.swift
//  Whosthere
//
//  Created by Moose on 31.01.22.
//

import SwiftUI

struct NavigationButtonAssestsIcon: View {
    let iconName: String
    
    var body: some View {
       Image(iconName)
        .font(.headline)
        .foregroundColor(.accentColor)
        .frame(width: 30, height: 30)
        .background(
            Rectangle()
                .foregroundColor(Color.textUnchangedColor)
        )
        .cornerRadius(5)
        
        
    }
}

struct NavigationButtonAssestsIcon_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButtonAssestsIcon(iconName: "PenIcon")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
