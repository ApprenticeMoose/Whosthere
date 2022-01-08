//
//  AthleteListRowView.swift
//  Photopickertest
//
//  Created by Moose on 04.12.21.
//

import SwiftUI

struct AthleteListRowView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let athlete: AthletesModel
    
    var body: some View {
        HStack {
            emptyProfilePicture
            
            Text(athlete.firstName)
                .font(.title3)
            Spacer()
        }
        .padding(.vertical, 5)
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

struct AthleteListRowView_Previews: PreviewProvider {
    
    static var athlete1 = AthletesModel(firstName: "Noah", lastName: "Martinez Berger")
    
    
    static var previews: some View {
        Group{
        AthleteListRowView(athlete: athlete1)
            .padding()
            .previewLayout(.sizeThatFits)
        AthleteListRowView(athlete: athlete1)
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
