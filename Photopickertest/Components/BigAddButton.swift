//
//  BigAddButton.swift
//  Photopickertest
//
//  Created by Moose on 17.12.21.
//

import SwiftUI

struct BigAddButton: View {
    
    @State var icon: String
    @State var description: String
    @State var textColor: Color
    @State var backgroundColor: Color
    
    var body: some View {
        HStack{
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(description)
                .font(.headline)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 55)
        .background(backgroundColor)
        .foregroundColor(textColor)
        .cornerRadius(10)
        .padding()
    }
}

//struct BigAddButton_Previews: PreviewProvider {
//    static var previews: some View {
//        BigAddButton()
//    }
//}
