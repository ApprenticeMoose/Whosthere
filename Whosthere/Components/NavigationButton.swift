//
//  NavigationButton.swift
//  Photopickertest
//
//  Created by Moose on 06.12.21.
//

import SwiftUI

struct NavigationButton: View {
    
    let iconName: String
    
    var body: some View {
       Image(systemName: iconName)
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

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton(iconName: "plus")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
