//
//  ActionSheetPerXAttendanceDetail.swift
//  Whosthere
//
//  Created by Moose on 06.11.22.
//
import Foundation
import SwiftUI

struct PerXAttendanceActionSheet: View {
    

    @Environment(\.colorScheme) var colorScheme
    @Binding var showActionSheet: Bool
    @Binding var animate: Bool
    
    @State var perWeekIsSelected: Bool = false
    @State var perMonthIsSelected: Bool = false
    @State var totalIsSelected: Bool = false
    
    var type: ActionSheetCall
    @Binding var perX: PerRange
    
    @ObservedObject var station = Station()
   // @EnvironmentObject var station: Station

    
    init(showActionSheet: Binding<Bool>, animate: Binding<Bool>, type: ActionSheetCall, perX: Binding<PerRange>){
        self._showActionSheet = showActionSheet
        self._animate = animate
        self.type = type
        self._perX = perX
        if self.perX == PerRange.perWeek {
            self._perWeekIsSelected = State(wrappedValue: true)
        } else if self.perX == PerRange.perMonth {
            self._perMonthIsSelected = State(wrappedValue: true)
        }else if self.perX == PerRange.total {
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
                  
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(301), execute: {
                        if perWeekIsSelected == true {
                            //UserDefaults.standard.perXAttendance = PerX.perWeek
                            perX = PerRange.perWeek
                        } else if perMonthIsSelected == true {
                            //UserDefaults.standard.perXAttendance = PerX.perMonth
                            perX = PerRange.perMonth
                        } else if totalIsSelected == true {
                           // UserDefaults.standard.perXAttendance = PerX.total
                            perX = PerRange.total
                        }
                        
                       
                    })
                    withAnimation {
                        animate.toggle()
                        showActionSheet.toggle()
                    }
                    
                    //do all the UserDefaults stuff
                   // if type == ActionSheetCall.detail {
                        
                    
                    /*
                }
                    else if type == ActionSheetCall.statistics {
                            if perWeekIsSelected == true {
                               // UserDefaults.standard.string(forKey: "statisticsPerX") = PerX.perWeek
                                perX = PerRange.perWeek
                            } else if perMonthIsSelected == true {
                                UserDefaults.standard.perXAttendance = PerX.perMonth
                                perX = PerRange.perWeek
                            } else if totalIsSelected == true {
                                UserDefaults.standard.perXAttendance = PerX.total
                            }
                        }*/
                    
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
