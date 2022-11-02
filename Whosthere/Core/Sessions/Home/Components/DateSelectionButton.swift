//
//  DateSelectionButton.swift
//  Whosthere
//
//  Created by Moose on 20.10.22.
//
import SwiftUI

struct DateSelectionButton: View {
    var checkIfSelected: Bool
    var colorText: Color
    var colorBackground: Color
    var textKW: String
    var textfirstDayOfWeek: String
    var textlastDayOfWeek: String
    var id: Int
    
    var body: some View {
        ZStack{
            if checkIfSelected {
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .frame(minWidth: 100, maxWidth: 110, minHeight: 40, idealHeight: 40, maxHeight: 40)
                        .foregroundColor(colorBackground)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(colorText, lineWidth: 1.0)
                        .frame(minWidth: 99, maxWidth: 109, minHeight: 39, idealHeight: 39, maxHeight: 39)
                    
                }
                
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .frame(minWidth: 100, maxWidth: 110, minHeight: 40, idealHeight: 40, maxHeight: 40)
                    .foregroundColor(colorBackground)
            }
            
            VStack {
                Text(textKW)
                    .font(.footnote)
                    .fontWeight(.semibold)
                HStack(spacing: 0){
                    Text(textfirstDayOfWeek)
                        .font(.caption2)
                        .fontWeight(.regular)
                        .id(id)
                    
                    Text(textlastDayOfWeek)
                        .font(.caption2)
                        .fontWeight(.regular)
                }
            }
            .foregroundColor(checkIfSelected ? colorText : colorText.opacity(0.3))
        }
    }
}
