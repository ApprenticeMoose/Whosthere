//
//  SessionsHomeView.swift
//  Whosthere
//
//  Created by Moose on 05.08.22.
//

import SwiftUI

struct SessionsHomeView: View {
    
    @ObservedObject var datesVM: DatesViewModel
    @StateObject var sessionsViewModel = SessionHomeVM()
    
    var selectedSessionsArray: [Session] {
        sessionsViewModel.sessions.filter { session in
            return datesVM.extractWeek(date: session.date) == datesVM.extractWeek(date: datesVM.selectedDay)
        }
    }
    
    //MARK: - Variables for DateSelection
    
    @State var showCalendar: Bool = false
    @State var showAddSessionSheet: Bool = false
    
    var calendar = Calendar.current
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }

    func checkIfArrayIsUnique(array: [Session]) -> Set<Date> {
        let sessionDates = array.map({ $0.date.onlyDate })
        return Set(sessionDates)
    }
    
    //MARK: - Body
    
    var body: some View {
        
        VStack(spacing: 18){
            
            HStack{
                ScreenHeaderTextOnly(screenTitle: "Sessions")
                
                sessionsTopButtonRow(firstButtonImage: "calendar",
                                     secondButtonImage: "plus",
                                     buttonColor: Color.header,
                                     calendarShow: $showCalendar,
                                     addSessionShow: $showAddSessionSheet)
                                    .fullScreenCover(isPresented: $showAddSessionSheet,
                                                     content: {AddSessionView()
                                    })
                
            }
            
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    
                    HStack(spacing: 11){
                        
                        SmallCalendarButton()
                            .onTapGesture {
                                showCalendar.toggle()
                            }
                        ForEach(0..<datesVM.wholeWeeks.count, id: \.self) { i in
                            //
                            DateSelectionButton(checkIfSelected: datesVM.checkCurrentWeek(dates: datesVM.wholeWeeks[i], dateSelected: datesVM.selectedDay),
                                                colorText: Color.header,
                                                colorBackground: Color.accentMidGround,
                                                textKW: "KW " + "\(datesVM.extractWeek(date: datesVM.wholeWeeks[i][0]))",
                                                textfirstDayOfWeek: datesVM.extractDate(date: datesVM.wholeWeeks[i][0], format: "dd") + ". -",
                                                textlastDayOfWeek: datesVM.extractDate(date: datesVM.wholeWeeks[i][6], format: "dd. MMM"),
                                                id: i)
                            
                            .onTapGesture {
                                datesVM.selectedDay = datesVM.wholeWeeks[i][0]
                                datesVM.scrollToIndex = i
                            }
                        }
                        .onAppear(perform: {
                            proxy.scrollTo(datesVM.scrollToIndex, anchor: .center)
                        })
                        .onChange(of: datesVM.scrollToIndex) { value in
                            withAnimation(.spring()) {
                                proxy.scrollTo(value, anchor: .center)
                                print(checkIfArrayIsUnique(array: selectedSessionsArray))
                            }
                        }
                        
                        SmallCalendarButton()
                            .onTapGesture {
                                showCalendar.toggle()
                            }
                    }
                }
                .padding(.horizontal)
                //.padding(.bottom)
            }//scrollview
            
            
            ScrollView(showsIndicators: false){
                LazyVStack(spacing: 20){
                    ForEach(Array(checkIfArrayIsUnique(array: selectedSessionsArray)).sorted(by: { $0 < $1 }), id: \.self) { day in
                        
                        VStack(spacing: 6){
                        SessionHomeCardHeadline(date: day)
                            ForEach(selectedSessionsArray, id: \.self) { session in
                                if day == session.date.onlyDate {
                                    SessionHomeCard(session: session, sessionVM: SessionHomeVM())
                                }
                            }
                        }
                    }
                }
                
//                Text("\(datesVM.extractWeek(date: datesVM.selectedDay))")
//                Text("\(datesVM.extractDate(date: datesVM.selectedDay, format: "dd MMM"))")
//                Text("\(datesVM.scrollToIndex)")
            }
            
            
            
            Spacer()
        } //VStack
        .background(Color.appBackground
            .edgesIgnoringSafeArea(.all))
        
        
        ZStack{
            if self.showCalendar {
                
                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showCalendar.toggle() }
                
                PopoverCalendar(selectedDate: $datesVM.selectedDay, show: $showCalendar)
                    .onChange(of: datesVM.selectedDay) { _ in            //to fetch new dates for the buttons when random dates is selected from calendar
                        datesVM.wholeWeeks.removeAll()
                        datesVM.fetchAllDays()
                        datesVM.scrollToIndex = 3
                        
                    }
            }
        }
        .opacity(self.showCalendar ? 1 : 0).animation(.easeIn, value: showCalendar)
    }//body
    
}//StructEnd


    //MARK: - UI Components

struct sessionsTopButtonRow: View {
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
    }
}

struct PopoverCalendar: View {
    @Binding var selectedDate: Date
    @Binding var show: Bool
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var sessionsVM: DatesViewModel
    
    init(selectedDate: Binding<Date>, show: Binding<Bool>) {
        self._selectedDate = selectedDate
        self._show = show
        self.sessionsVM = DatesViewModel()
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

struct SessionHomeCardHeadline: View {
    let date: Date
    
    var body: some View {
        HStack{
            Text(date.formatDateWeekday() + ", " + date.formatted(
                .dateTime
                .month(.wide)
                .day()
            ))
                .fontWeight(.medium)
                .foregroundColor(.cardGrey1)
                .padding(.horizontal, 22)
            Spacer()
        }
    }
}

struct SessionHomeCard: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let session: Session
    
    @ObservedObject var sessionVM: SessionHomeVM
    
    func getInitials(firstName: String, lastName: String) -> String {
        let firstLetter = firstName.first?.uppercased() ?? ""
        let lastLetter = lastName.first?.uppercased() ?? ""
        return firstLetter + lastLetter
    }
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.accentMidGround)
                .frame(maxWidth: .infinity)
                .frame(height: 94)
                .padding(.horizontal)
            
            VStack(spacing: 6){
                
                HStack{
                    //clock time and 3point button
                    HStack(spacing: 6){
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text(session.date, style: .time)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 18)
                    Spacer()
                    Button {
                        //open little menu to dublicate delete etc
                    } label: {
                        HStack(spacing: 3){
                            Circle()
                                .frame(width: 5, height: 5)
                                .foregroundColor(.cardGrey1)
                            Circle()
                                .frame(width: 5, height: 5)
                                .foregroundColor(.cardGrey1)
                            Circle()
                                .frame(width: 5, height: 5)
                                .foregroundColor(.cardGrey1)
                        }
                        .padding(.horizontal)
                        .offset(y: -4)
                    }
                    
                    
                } //Time and 3 point Button
                .padding(.horizontal)
                .padding(.top, 6)
                .padding(.bottom, 2)
                
                HStack{
                    Rectangle()
                        .frame(width: 245, height: 1.5, alignment: .center)
                        .foregroundColor(colorScheme == .light ? .cardGrey1.opacity(0.35) : .header.opacity(0.15))
                        .padding(.horizontal, 26)
                    Spacer()
                }//Line
                
                HStack{
                    
                    HStack(spacing: 12){
                        if session.athleteIDs.isEmpty {
                            VStack(spacing: 2){
                                ZStack{
                                    Circle()
                                        .frame(width: 26, height: 26)
                                        .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey3)
                                    Image(systemName: "person.badge.plus")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .font(.caption2)
                                        .foregroundColor(.cardProfileLetter)
                                        .offset(x: -1)
                                }
                                
                                Text("Add")
                                    .font(.caption2)
                                    .foregroundColor(.cardText)
                            }
                        } else {
                            ForEach(session.athleteIDs, id: \.self) {athleteID in
                                if let athlete = sessionVM.getAthletes(with: athleteID){
                                    VStack(spacing: 2){
                                        ZStack{
                                            Circle()
                                                .frame(width: 26, height: 26)
                                                .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey3)
                                            Text(getInitials(firstName: athlete.firstName, lastName: athlete.lastName))
                                                .font(.caption2)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.cardProfileLetter)
                                        }
                                        Text(athlete.firstName)
                                            .font(.caption2)
                                            .foregroundColor(.cardText)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 34)
                    Spacer()
                } //Athletes
            }
        }
    }
}

