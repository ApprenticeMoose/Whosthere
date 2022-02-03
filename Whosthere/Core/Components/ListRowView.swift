//
//  ListRowView.swift
//  Whosthere
//
//  Created by Moose on 02.02.22.
//

import SwiftUI

struct ListRowView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    //changes may be needed
    let athlete: AthletesModel
    
    var body: some View {
        HStack {
            emptyProfilePicture
            
            Text(athlete.firstName)
                .font(.title3)
            Spacer()
        }
        .padding(.vertical, 5)
        .background(
            Color.white.opacity(0.001)
        )
    }
    
    
    
    var emptyProfilePicture: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(colorScheme == .light ? .greyFourColor : .greyTwoColor)
                .padding(.horizontal, 10)
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(colorScheme == .light ? .greyTwoColor : .greyOneColor)
        }
    }
}

