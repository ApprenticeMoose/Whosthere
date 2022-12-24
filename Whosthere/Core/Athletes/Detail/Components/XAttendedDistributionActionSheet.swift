//
//  XAttendedDistributionActionSheet.swift
//  Whosthere
//
//  Created by Moose on 24.11.22.
//

import SwiftUI

struct XAttendedDistributionActionSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var showActionSheet: Bool
    @Binding var animate: Bool
    
    @State var attendedNumber: Bool = false
    @State var attendedPercantage: Bool = false
    
    @ObservedObject var station = Station()
   

   // @EnvironmentObject var station: Station

    
    init(showActionSheet: Binding<Bool>, animate: Binding<Bool>){
        self._showActionSheet = showActionSheet
        self._animate = animate
        if station.xAttendedDistribution == .attendedNumber {
            self._attendedNumber = State(wrappedValue: true)
        } else if station.xAttendedDistribution == .attendedPercent {
            self._attendedPercantage = State(wrappedValue: true)
        }
    }
    
    var body: some View {
        
        VStack{
            HStack{
                HStack{
                    Image(systemName: "checkmark")
                        .resizable()
                        .foregroundColor(.clear)
                        .frame(width: 20, height: 15.3)
                }
                .padding(.vertical, 10)
                .padding(.leading, 10)
                .padding(.trailing, 5)
                .offset(y: -1)
                
                Spacer()
                
                Text("Show")
                    .fontWeight(.semibold)
                    .font(.title3)
                    .foregroundColor(.midTitle)
                
                Spacer()
                
                //Apply button
                Button {
                    showActionSheet.toggle()
                    //do all the UserDefaults stuff
                    if attendedNumber == true {
                        UserDefaults.standard.xAttendedDistibution = ShowAttended.attendedNumber
                    } else if attendedPercantage == true {
                        UserDefaults.standard.xAttendedDistibution = ShowAttended.attendedPercent
                    }
                    animate.toggle()
                } label: {
                    HStack{
                        Image(systemName: "checkmark")
                            .resizable()
                            .foregroundColor(.midTitle)
                            .frame(width: 20, height: 15.3)
                    }
                    .padding(.vertical, 10)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .offset(y: -3)
                }
            }
            .padding(.vertical, 1)
            .padding(.bottom, 10)
            
            HStack{
            VStack(alignment: .leading){
                Button {
                    attendedNumber = true
                    attendedPercantage = false
                } label: {
                    
                    Text("# attended")
                        .fontWeight(.semibold)
                        .foregroundColor(.midTitle)
                        .padding(.vertical, 12)
                        .opacity(attendedNumber ? 1.0 : 0.3)
                    
                }
                
                Button {
                    attendedNumber = false
                    attendedPercantage = true
                } label: {
                    Text("% attended")
                        .fontWeight(.semibold)
                        .foregroundColor(.midTitle)
                        .padding(.vertical, 12)
                        .opacity(attendedPercantage ? 1.0 : 0.3)
                }
                
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
                
            Spacer()
            }
            
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(Color.appBackground.clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 20)))
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
}

