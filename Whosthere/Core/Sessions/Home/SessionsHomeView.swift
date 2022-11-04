//
//  SessionsHomeView.swift
//  Whosthere
//
//  Created by Moose on 05.08.22.
//
import SwiftUI
import NavigationBackport

//- FIXME: Athletes get lost and session is only half deleted when all sessions get deleted. After restarting athletes are back.
struct SessionsHomeView: View {
    
    @EnvironmentObject var appState: AppState                               //For Navigation
    @EnvironmentObject var tabDetail: TabDetailVM
    
    @StateObject var datesVM = DatesVM()
    @StateObject var sessionsViewModel = SessionHomeVM()
    var selectedSessionsArray: [Session] {
        sessionsViewModel.sessions.filter { session in
            return datesVM.extractWeek(date: session.date) == datesVM.extractWeek(date: datesVM.selectedDay)
        }
    } // has only the sessions in it, that are seleceted from week button -> makes it easier to work in displaying the sessions
    
    //MARK: - Variables for DateSelection
    
    @State var showCalendar: Bool = false
    @State var showAddSessionSheet: Bool = false
    @Binding var showActionSheet: Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }
    
 
    //MARK: - Body
    
    var body: some View {
        NBNavigationStack(path: $appState.path) {                            //NavigationStack
            ZStack{
                VStack(spacing: 18){
                    
//Header and Buttons
                    HStack{
                        ScreenHeaderTextOnly(screenTitle: "Sessions")
                        
                        SessionsTopButtonRow(firstButtonImage: "calendar",
                                             secondButtonImage: "plus",
                                             buttonColor: Color.header,
                                             calendarShow: $showCalendar,
                                             addSessionShow: $showAddSessionSheet)
                        .fullScreenCover(isPresented: $showAddSessionSheet,
                                         content: { AddSessionView() })
                    }
                    
                    
//Week Selector Button
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
                                                        //dateIsToday: datesVM.checkCurrentWeek(dates: Date().daysOfWeek(), dateSelected: Date().noon),
                                                        
                                                        currentWeek: datesVM.extractWeek(date: datesVM.wholeWeeks[i][0]),
                                                        weekThatContainsToday: datesVM.extractWeek(date: Date()),
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
                                    //print(datesVM.selectedDay)
                                    
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
                    }//scrollview
                    
//Sessions
                    ScrollView(.vertical, showsIndicators: false){
                        ScrollViewReader { proxy in
                            LazyVStack(spacing: 20){
                                
                                ForEach(Array(sessionsViewModel.checkIfArrayIsUnique(array: selectedSessionsArray).sorted(by: { $0 < $1 })), id: \.self) { day in
                                    
                                    VStack(spacing: 6){
                                        SessionHomeCardHeadline(date: day)
                                        ForEach(selectedSessionsArray, id: \.self) { session in
                                            if day == session.date.onlyDate {
                                                
                                                SessionHomeCard(session: session, sessionVM: SessionHomeVM(), showActionSheet: $showActionSheet)
                                                
                                            }
                                        }
                                    }
                                    .id(day)
                                }
                                .onAppear {
                                    print(UserDefaults.standard.bool(forKey: "launchedOnce"))
                                    if UserDefaults.standard.bool(forKey: "launchedOnce") == true {
                                        proxy.scrollTo(datesVM.extractDateWithoutTime(date: Date()), anchor: .center)
                                        UserDefaults.standard.set(false, forKey: "launchedOnce")
                                    } // is initially set in AthleteApp.swift and is used for it to only scroll to today after launch
                                }
                                .onChange(of: datesVM.scrollToIndexOfSessions) { value in
                                    //print(sessionsViewModel.scrollToIndex)
                                    withAnimation(.spring()) {
                                        proxy.scrollTo(value, anchor: .top)
                                    }
                                }
                                
                            }
                            /*
                             Text("\(datesVM.extractWeek(date: datesVM.selectedDay))")
                             Text("\(datesVM.extractDate(date: datesVM.selectedDay, format: "dd MMM"))")
                             Text("\(datesVM.scrollToIndex)")
                             */ // check the week and day selected form row of week buttons
                            
                            Rectangle()
                                .frame(height: 50)
                                .foregroundColor(.clear)
                        }
                    }
                    .nbNavigationDestination(for: Route.self) { route in
                        switch route {
                        case let .detail(athlete):
                            AthleteDetailView(athlete: athlete)
                            
                        case let .edit(athlete):
                            EditAthleteView(athlete: athlete,
                                            goBackToRoot: { appState.path.removeLast(appState.path.count)})
                            
                        case let .editSession(session):
                            EditSessionView(session: session, selectedDay: $datesVM.selectedDay, scrollToIndexOfSessions: $datesVM.scrollToIndexOfSessions)
                                .onDisappear {
                                    datesVM.wholeWeeks.removeAll()
                                    datesVM.fetchAllDays()
                                    datesVM.scrollToIndex = 3
                            }
                        }
                    }
                    
                    Spacer()
                    
                } //VStack
                .background(Color.appBackground.edgesIgnoringSafeArea(.all))
                
//Calendar Overlay
                ZStack{
                    if self.showCalendar {
                        
                        Color.black
                            .opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture { showCalendar.toggle() }
                        
                        PopoverCalendar(selectedDate: $datesVM.selectedDay, show: $showCalendar)
                            .onChange(of: datesVM.selectedDay) { selectedDay in            //to fetch new dates for the buttons when random dates is selected from calendar
                                datesVM.wholeWeeks.removeAll()
                                datesVM.fetchAllDays()
                                datesVM.scrollToIndex = 3
                                datesVM.scrollToIndexOfSessions = selectedDay
                            }
                            .onAppear {
                                tabDetail.showDetail = true
                            }
                            .onDisappear{
                                tabDetail.showDetail = false
                            }
                    }
                }
                .opacity(self.showCalendar ? 1 : 0)//.animation(.easeIn, value: showCalendar)
            }//ZStack for Calendar
        }//Navigation
    }//body
}//StructEnd


