//
//  sessionsTopButtonRow.swift
//  Whosthere
//
//  Created by Moose on 20.10.22.
//
import SwiftUI

struct SessionsTopButtonRow: View {
    var firstButtonImage: String
    var secondButtonImage: String
    var buttonColor: Color
    @Binding var calendarShow: Bool
    @Binding var addSessionShow: Bool
    
    var body: some View {
        HStack{
            Button(action: {
                //Make  Sheet Appear
                calendarShow.toggle()
            }){
                Image(systemName: firstButtonImage) //"calendar"
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(buttonColor)
                    .padding(.horizontal, 14)
            }
            
            // Add Athlete Button
            Button(action: {
                addSessionShow.toggle()
            }){
                Image(systemName: secondButtonImage) //"plus"
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(buttonColor)
            }
        }//HStackButtonsEnd
        .padding(.horizontal, 22)
        .padding(.top, 20)
        .navigationBarHidden(true)
    }
}
