//
//  30ptFrameButton.swift
//  Photopickertest
//
//  Created by Moose on 08.12.21.
//

import SwiftUI

struct FrameButton: View {
    
    let iconName: String
    let iconColor: Color
    let backgroundColor: Color
    
    var body: some View {
        Image(iconName)
            .font(.headline)
            .foregroundColor(iconColor)
            .frame(width: 30, height: 30)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(backgroundColor)
                    //.stroke(Color.textColor, lineWidth: 2.0)
                    //.foregroundColor(iconColor)
                    
            )
            
    }
}

struct FrameButton_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            FrameButton(iconName: "plus", iconColor: .textColor, backgroundColor: .accentGold)
            .padding()
            .previewLayout(.sizeThatFits)
            FrameButton(iconName: "plus", iconColor: .textColor, backgroundColor: .accentGold)
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
    }
}
