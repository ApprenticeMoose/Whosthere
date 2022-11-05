//
//  SmallCalendarButton.swift
//  Whosthere
//
//  Created by Moose on 20.10.22.
//
import SwiftUI

struct SmallCalendarButton: View {
    
    var body: some View {
        VStack{
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.accentMidGround)
            Image(systemName: "calendar")
                .foregroundColor(Color.header)
        }
        Capsule()
            .frame(width: 4, height: 4)
            .foregroundColor(.clear)
            .offset(y: -3)
        }
    }
}
