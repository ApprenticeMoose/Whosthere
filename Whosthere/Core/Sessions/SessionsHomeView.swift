//
//  SessionsHomeView.swift
//  Whosthere
//
//  Created by Moose on 05.08.22.
//

import SwiftUI

struct SessionsHomeView: View {
    
    var calendar = Calendar(identifier: .gregorian)
    
    func getWeek(
    
    var body: some View {
        
        VStack{
            
            HStack{
                ScreenHeaderTextOnly(screenTitle: "Sessions")
                athleteListButtonRow
//                    .fullScreenCover(isPresented: $showAddSheet,
//                                     content: {AddAthleteView(vm: AddAthleteViewModel(context: viewContext))})
                
            } //HStack
            
            //Horizontal scroll view with
            
            
            Spacer()
        } //VStack
        Spacer()
    }
    
    
    
    
    private var athleteListButtonRow: some View {
    
    HStack{
 

        
        Button(action: {
            //Make Sort Sheet Appear
        }){
            Image(systemName: "calendar")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.header)
                .padding(.horizontal, 14)
        }
        
        // Add Athlete Button
        Button(action: {
            //showAddSheet.toggle()
        }){
            Image(systemName: "plus")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.header)
        }
        
        
        
    }//HStackButtonsEnd
    .padding(.horizontal, 22)
    .padding(.top, 20)
}
    }//StructEnd


struct SessionsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsHomeView()
    }
}
