//
//  ActionSheetPerXAttendanceDetail.swift
//  Whosthere
//
//  Created by Moose on 06.11.22.
//
import Foundation
import SwiftUI

struct PerXAttendanceDetailActionSheet: View {
    

    @Environment(\.colorScheme) var colorScheme
    @Binding var showActionSheet: Bool
    
    @State var perWeekIsSelected: Bool = false
    @State var perMonthIsSelected: Bool = false
    @State var totalIsSelected: Bool = false
    
    @ObservedObject var station = Station()
   // @EnvironmentObject var station: Station

    
    init(showActionSheet: Binding<Bool>){
        self._showActionSheet = showActionSheet
        if station.perXAttendance == .perWeek {
            self._perWeekIsSelected = State(wrappedValue: true)
        } else if station.perXAttendance == .perMonth {
            self._perMonthIsSelected = State(wrappedValue: true)
        }else if station.perXAttendance == .total {
            self._totalIsSelected = State(wrappedValue: true)
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
                
                Text("Sort")
                    .fontWeight(.semibold)
                    .font(.title3)
                    .foregroundColor(.midTitle)
                
                Spacer()
                
                //Apply button
                Button {
                    showActionSheet.toggle()
                    //do all the UserDefaults stuff
                    if perWeekIsSelected == true {
                        UserDefaults.standard.perXAttendance = PerX.perWeek
                    } else if perMonthIsSelected == true {
                        UserDefaults.standard.perXAttendance = PerX.perMonth
                    } else if totalIsSelected == true {
                        UserDefaults.standard.perXAttendance = PerX.total
                    }
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
            .padding(.bottom, 30)
            
            HStack{
            VStack(alignment: .leading){
                Button {
                    perWeekIsSelected = true
                    perMonthIsSelected = false
                    totalIsSelected = false
                } label: {
                    
                    Text("Avg. per Week")
                        .fontWeight(.semibold)
                        .foregroundColor(.midTitle)
                        .padding(.vertical, 12)
                        .opacity(perWeekIsSelected ? 1.0 : 0.3)
                    
                }
                
                Button {
                    perWeekIsSelected = false
                    perMonthIsSelected = true
                    totalIsSelected = false
                } label: {
                    Text("Avg. per Month")
                        .fontWeight(.semibold)
                        .foregroundColor(.midTitle)
                        .padding(.vertical, 12)
                        .opacity(perMonthIsSelected ? 1.0 : 0.3)
                }
                
                Button {
                    perWeekIsSelected = false
                    perMonthIsSelected = false
                    totalIsSelected = true
                } label: {
                    Text("Total")
                        .fontWeight(.semibold)
                        .foregroundColor(.midTitle)
                        .padding(.vertical, 12)
                        .opacity(totalIsSelected ? 1.0 : 0.3)
                }
                
            }
            .padding(.horizontal, 4)
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
