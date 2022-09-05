//
//  SessionsHomeView.swift
//  Whosthere
//
//  Created by Moose on 05.08.22.
//

import SwiftUI

struct SessionsHomeView: View {
    
    @ObservedObject var datesVM: DatesViewModel
    
    
    init(vm: AthletesListViewModel){
        self.datesVM = DatesViewModel()
        self.athletesListVM = vm
    }
    
    //MARK: - Variables for DateSelection
    
    @State var showCalendar: Bool = false
    @State var showAddSessionSheet: Bool = false
    
    var calendar = Calendar.current
    
    @ObservedObject private var athletesListVM: AthletesListViewModel
    @Environment(\.managedObjectContext) var viewContext
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
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
                                                     content: {AddSessionView(vm: AthletesListViewModel(context: viewContext))
                                        
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
                            }
                        }
                        
                        SmallCalendarButton()
                            .onTapGesture {
                                showCalendar.toggle()
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }//scrollview
            
            Spacer()
            
            Text("\(datesVM.extractWeek(date: datesVM.selectedDay))")
            Text("\(datesVM.extractDate(date: datesVM.selectedDay, format: "dd MMM"))")
            Text("\(datesVM.scrollToIndex)")
            
            
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


//struct SessionsHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionsHomeView()
//    }
//}
