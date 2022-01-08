//
//  ScreenHeaderTextOnly.swift
//  Photopickertest
//
//  Created by Moose on 06.12.21.
//

import SwiftUI

struct ScreenHeaderTextOnly: View {
    
    let screenTitle: String
    
    var body: some View {
        
        HStack{
            
            Spacer(minLength: 0)
            
            Text(screenTitle)
                .font(.title)
                .foregroundColor(.textUnchangedColor)
                .fontWeight(.medium)
            
            Spacer(minLength: 0)
            
        }
        .padding()
    }
}

struct ScreenHeaderTextOnly_Previews: PreviewProvider {
    static var previews: some View {
        ScreenHeaderTextOnly(screenTitle: "Athletes")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
