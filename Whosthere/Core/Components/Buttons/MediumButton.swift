//
//  MediumButton.swift
//  Whosthere
//
//  Created by Moose on 07.02.22.
//

import SwiftUI

struct MediumButton: View {
    
    @State var icon: String
    @State var description: String
    @State var textColor: Color
    @State var backgroundColor: Color
    
    var body: some View {
        HStack{
            Image(systemName: icon)
                .font(.system(size: 13))
            Text(description)
                .font(.footnote)
        }
        .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width - 150 , minHeight: 44, maxHeight: 44)
        .background(backgroundColor)
        .foregroundColor(textColor)
        .cornerRadius(10)
        .padding()
    }
}


struct MediumButton_Previews: PreviewProvider {
    static var previews: some View {
        MediumButton(icon: "plus", description: "Add athlete", textColor: .textColor, backgroundColor: .middlegroundColor)
    }
}
