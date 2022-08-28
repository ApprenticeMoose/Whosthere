//
//  SessionsHomeView.swift
//  Whosthere
//
//  Created by Moose on 05.08.22.
//

import SwiftUI

struct SessionsHomeView: View {
    
    @ObservedObject var sessionsVM: SessionsViewModel
    
    
    var calendar = Calendar.current
    @State var isSelectedWeekButton: Bool = false
    @State var show: Bool = false
    
    init(){
        self.sessionsVM = SessionsViewModel()
    }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 18){
                
                HStack{
                    ScreenHeaderTextOnly(screenTitle: "Sessions")
                    athleteListButtonRow
                    //                    .fullScreenCover(isPresented: $showAddSheet,
                    //                                     content: {AddAthleteView(vm: AddAthleteViewModel(context: viewContext))})
                    
                }
              
                
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { proxy in
                        
                        HStack(spacing: 10){
                            //CalendarButton
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color.accentMidGround)
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.header)
                            }
                            .onTapGesture {
                                show.toggle()
                            }
                            ForEach(0..<sessionsVM.wholeWeeks.count, id: \.self) { i in
                                ZStack {
                                    if sessionsVM.checkCurrentWeek(dates: sessionsVM.wholeWeeks[i]) {
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.header, lineWidth: 1.0)
                                            .frame(minWidth: 100, maxWidth: 110, minHeight: 40, idealHeight: 40, maxHeight: 40)
                                            .background(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.accentMidGround)
                                            )
                                        
                                    } else {
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(minWidth: 100, maxWidth: 110, minHeight: 40, idealHeight: 40, maxHeight: 40)
                                            .foregroundColor(Color.accentMidGround)
                                    }
                                    VStack {
                                        Text("KW " + "\(sessionsVM.extractWeek(date: sessionsVM.wholeWeeks[i][0]))")
                                            .font(.footnote)
                                            .fontWeight(.semibold)
                                        HStack(spacing: 0){
                                            Text(sessionsVM.extractDate(date: sessionsVM.wholeWeeks[i][0], format: "dd") + ". -")
                                                .font(.caption2)
                                                .fontWeight(.regular)
                                                .id(i)
                                            
                                            Text(sessionsVM.extractDate(date: sessionsVM.wholeWeeks[i][6], format: "dd. MMM"))
                                                .font(.caption2)
                                                .fontWeight(.regular)
                                            
                                        }
                                        
                                    }
                                    .foregroundColor(sessionsVM.checkCurrentWeek(dates: sessionsVM.wholeWeeks[i]) ? Color.header : Color.header.opacity(0.3))
                                }
                                .onTapGesture {
                                    isSelectedWeekButton = true
                                    
                                    sessionsVM.selectedDay = sessionsVM.wholeWeeks[i][0]
                                    sessionsVM.scrollToIndex = i
                                    
                                    
                                }
                                
                            }
                            .onAppear(perform: {
                                proxy.scrollTo(sessionsVM.scrollToIndex, anchor: .center)
                            })
                            .onChange(of: sessionsVM.scrollToIndex) { value in
                                withAnimation(.spring()) {
                                    proxy.scrollTo(value, anchor: .center)
                                }
                            }
                            //CalendarButton
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color.accentMidGround)
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.header)
                            }
                            .onTapGesture {
                                show.toggle()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                }//scrollview
                
                Spacer()
                
                Text("\(sessionsVM.extractWeek(date: sessionsVM.selectedDay))")
                Text("\(sessionsVM.extractDate(date: sessionsVM.selectedDay, format: "dd MMM"))")
                Text("\(sessionsVM.scrollToIndex)")
                
                
                Spacer()
            } //VStack
            Spacer()
        }//zstack
        ZStack{
            if self.show {
                
                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { show.toggle() }
                
                PopoverCalendar(selectedDate: $sessionsVM.selectedDay, show: $show)
                    .onChange(of: sessionsVM.selectedDay) { _ in            //to fetch new dates for the buttons when random dates is selected from calendar
                        sessionsVM.wholeWeeks.removeAll()
                        sessionsVM.fetchAllDays()
                        sessionsVM.scrollToIndex = 3
                        
                    }
            }
        }
        .opacity(self.show ? 1 : 0).animation(.easeIn, value: show)
    }//body
    
    
    
    private var athleteListButtonRow: some View {
        
        HStack{
            
            
            
            Button(action: {
                //Make  Sheet Appear
                show.toggle()
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



struct PopoverCalendar: View {
    @Binding var selectedDate: Date
    @Binding var show: Bool
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var sessionsVM: SessionsViewModel
    
    
    init(selectedDate: Binding<Date>, show: Binding<Bool>) {
        self._selectedDate = selectedDate
        self._show = show
        self.sessionsVM = SessionsViewModel()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(colorScheme == .light ? .appBackground : .accentMidGround)
                .frame(maxWidth: .infinity)
                .frame(height: 315, alignment: .center)
                .padding(.horizontal)
            
            VStack(alignment: .leading ,spacing: 10) {
                
                
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .colorScheme(colorScheme == .light ? .light : .dark)
                    .accentColor(.accentSmallButton)
                    .labelsHidden()
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .frame(height: 300)
                
            }
        }
    }
}

struct SessionsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsHomeView()
    }
}
