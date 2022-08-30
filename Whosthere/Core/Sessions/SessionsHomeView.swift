//
//  SessionsHomeView.swift
//  Whosthere
//
//  Created by Moose on 05.08.22.
//

import SwiftUI

struct SessionsHomeView: View {
    
    @ObservedObject var sessionsVM: SessionsViewModel
    
    
    init(){
        self.sessionsVM = SessionsViewModel()
    }
    
    //MARK: - Variables for DateSelection
    @State var show: Bool = false
    
    var calendar = Calendar.current
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }
    
    //replace the headerbutton and connect the show variable
    
    var body: some View {
        
        VStack(spacing: 18){
            
            HStack{
                ScreenHeaderTextOnly(screenTitle: "Sessions")
                athleteListButtonRow
                //                    .fullScreenCover(isPresented: $showAddSheet,
                //                                     content: {AddAthleteView(vm: AddAthleteViewModel(context: viewContext))})
                
            }
            
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    
                    HStack(spacing: 11){
                        
                        SmallCalendarButton()
                            .onTapGesture {
                                show.toggle()
                            }
                        ForEach(0..<sessionsVM.wholeWeeks.count, id: \.self) { i in
                            //
                            DateSelectionButton(checkIfSelected: sessionsVM.checkCurrentWeek(dates: sessionsVM.wholeWeeks[i], dateSelected: sessionsVM.selectedDay),
                                                colorText: Color.header,
                                                colorBackground: Color.accentMidGround,
                                                textKW: "KW " + "\(sessionsVM.extractWeek(date: sessionsVM.wholeWeeks[i][0]))",
                                                textfirstDayOfWeek: sessionsVM.extractDate(date: sessionsVM.wholeWeeks[i][0], format: "dd") + ". -",
                                                textlastDayOfWeek: sessionsVM.extractDate(date: sessionsVM.wholeWeeks[i][6], format: "dd. MMM"),
                                                id: i)
                            
                            .onTapGesture {
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
                        
                        SmallCalendarButton()
                            .onTapGesture {
                                show.toggle()
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }//scrollview
            
            Spacer()
            
            Text("\(sessionsVM.extractWeek(date: sessionsVM.selectedDay))")
            Text("\(sessionsVM.extractDate(date: sessionsVM.selectedDay, format: "dd MMM"))")
            Text("\(sessionsVM.scrollToIndex)")
            
            
            Spacer()
        } //VStack
        .background(Color.appBackground
            .edgesIgnoringSafeArea(.all))
        
        
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

struct sessionsTopButtonRow: View {
    var firstButtonImage: String
    var secondButtonImage: String
    var buttonColor: Color
    @Binding var calendarShow: Bool
    
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
                //showAddSheet.toggle()
            }){
                Image(systemName: secondButtonImage) //"plus"
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(buttonColor)
            }
        }//HStackButtonsEnd
        .padding(.horizontal, 22)
        .padding(.top, 20)
    }
}

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


struct DateSelectionButton: View {
    var checkIfSelected: Bool
    var colorText: Color
    var colorBackground: Color
    var textKW: String
    var textfirstDayOfWeek: String
    var textlastDayOfWeek: String
    var id: Int
    
    var body: some View {
        ZStack{
            if checkIfSelected {
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .frame(minWidth: 100, maxWidth: 110, minHeight: 40, idealHeight: 40, maxHeight: 40)
                        .foregroundColor(colorBackground)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(colorText, lineWidth: 1.0)
                        .frame(minWidth: 99, maxWidth: 109, minHeight: 39, idealHeight: 39, maxHeight: 39)
                    
                }
                
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .frame(minWidth: 100, maxWidth: 110, minHeight: 40, idealHeight: 40, maxHeight: 40)
                    .foregroundColor(colorBackground)
            }
            
            VStack {
                Text(textKW)
                    .font(.footnote)
                    .fontWeight(.semibold)
                HStack(spacing: 0){
                    Text(textfirstDayOfWeek)
                        .font(.caption2)
                        .fontWeight(.regular)
                        .id(id)
                    
                    Text(textlastDayOfWeek)
                        .font(.caption2)
                        .fontWeight(.regular)
                }
            }
            .foregroundColor(checkIfSelected ? colorText : colorText.opacity(0.3))
        }
    }
}


struct SessionsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsHomeView()
    }
}
