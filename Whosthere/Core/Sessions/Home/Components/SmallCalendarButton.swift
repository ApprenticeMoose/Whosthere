//
//  SmallCalendarButton.swift
//  Whosthere
//
//  Created by Moose on 20.10.22.
//
import SwiftUI

struct SmallCalendarButton: View {
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.accentMidGround)
            Image(systemName: "calendar")
                .foregroundColor(Color.header)
        }
    }
}
