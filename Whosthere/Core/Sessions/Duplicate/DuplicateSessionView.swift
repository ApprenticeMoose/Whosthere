//
//  DuplicateSessionView.swift
//  Whosthere
//
//  Created by Moose on 05.10.22.
//

import SwiftUI
import NavigationBackport

struct DuplicateSessionView: View {
  
        @Environment(\.presentationMode) var presentationMode
        @Environment(\.colorScheme) var colorScheme
        
        @Binding var selectedDay: Date
    
        @Binding var duplicateIsTrue: Bool
        @Binding var selectedDayFromDuplicate: Date
        
        @State var todayIsSelected: Bool = false
        @State var tomorrowIsSelected: Bool = false
        
        @State var showTimePicker: Bool = false
        @State var showDatePicker: Bool = false
            
        @ObservedObject var duplicateSessionVM : DuplicateSessionVM
        @ObservedObject var datesVM: DatesVM
    
        
        var athleteArray = [UUID]()
        
        @EnvironmentObject var appState: AppState                                       //For Navigation
        @EnvironmentObject var tabDetail: TabDetailVM                                   //For Tabbar hiding
        
        let preference = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
    init(session: Session?, dataManager: DataManager = DataManager.shared, selectedDay: Binding<Date>, duplicateIsTrue: Binding<Bool>, selectedDayFromDuplicate: Binding<Date>) {
            self.duplicateSessionVM = DuplicateSessionVM(session: session, dataManager: dataManager)
            self.datesVM = DatesVM()
            self._selectedDay = selectedDay
            self._duplicateIsTrue = duplicateIsTrue
        self._selectedDayFromDuplicate = selectedDayFromDuplicate
            
            if duplicateSessionVM.sessionDate == duplicateSessionVM.mergeTimeAndDate(time: duplicateSessionVM.sessionTime, date: Date()) {
                self._todayIsSelected = State(wrappedValue: true)
            } else if duplicateSessionVM.sessionDate == duplicateSessionVM.mergeTimeAndDate(time: duplicateSessionVM.sessionTime, date: datesVM.setDateToTomorrow()) {
                self._tomorrowIsSelected = State(wrappedValue: true) }
            
           //For initializing the checkmarks
                //creating an array with the IDs of all the athletes so the can later be compared
            for athlete in duplicateSessionVM.athletes {
                athleteArray.append(athlete.id) }
            
                //creating dictionary with key of index and value of id, exactly like the tuple used to select the checkmarks in the view
            let arrayOfAthletes = Dictionary(uniqueKeysWithValues: zip(athleteArray.indices, athleteArray))
            
                //running through all the athletes and if the session has an athlete, the key is added to the selectedIndicies and that triggers the checkmark
            if let session = session {
            for (key, value) in arrayOfAthletes {
                for id in session.athleteIDs {
                    if id == value {
                        duplicateSessionVM.selectedIndices.insert(key)
                    }
                }
            }
        }
        }

        var body: some View {
            ZStack{
                GeometryReader { geometry in
                ScrollView{
                    VStack{
                    duplicateSessionHeader
                    
                    time

                    dates

                    athletes

                    Spacer()
                        
                  

                    }.frame(minHeight: geometry.size.height)
                }.frame(width: geometry.size.width)

                timePicker
                
                datePicker
                
                }//geometry reader
            }//zstack
        }//body
        
        func getInitials(firstName: String, lastName: String) -> String {
            let firstLetter = firstName.first?.uppercased() ?? ""
            let lastLetter = lastName.first?.uppercased() ?? ""
            return firstLetter + lastLetter
        }
        
        var duplicateSessionHeader: some View {
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }){
                    //NavigationButtonSystemName(iconName: "chevron.backward")
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .foregroundColor(.header)
                        .frame(width: 27, height: 20)
                }
                
                Spacer(minLength: 0)
                
                Text("Duplicate")
                    .font(.title)
                    .foregroundColor(.header)
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                Button(action: {
                    duplicateSessionVM.saveSession()
                    presentationMode.wrappedValue.dismiss()
                    duplicateIsTrue = true
                    selectedDayFromDuplicate = datesVM.setDateToStartOfWeek(date: duplicateSessionVM.sessionDate) //so it sets the selected day to the first of the week and the buttons recognize that
                    print(duplicateIsTrue)
                    print(selectedDay)
                    //appState.path.removeLast()
                    //tabDetail.showDetail = false
                    
                }){
                    Image(systemName: "checkmark")
                        .resizable()
                        .foregroundColor(.header)
                        .frame(width: 26, height: 20)
                }//Button
            }//HeaderHStackEnding
            .padding(.horizontal, 22)
            .padding(.top, 15)
            .onAppear(perform: { self.tabDetail.showDetail = true })
            .navigationBarHidden(true)
        }

        var time: some View {
            VStack (alignment: .leading, spacing: 0){
                
                Text("Time")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 30)
                    .offset(y: 6)
                
                
                HStack{
                    
                    
                    ZStack {
                        
                        
                        Rectangle()
                            .background(Color.accentMidGround)
                            .foregroundColor(.accentMidGround)
                            .frame(width: 105, height: 40)
                            .cornerRadius(10)
                        
                        
                        Text("\(datesVM.extractDate(date: datesVM.roundMinutesDown(date: duplicateSessionVM.sessionTime), format: "HH:mm"))")
                        //.font(.title3)
                            .fontWeight(.semibold)
                        
                        
                        
                    }
                    
                    .onTapGesture {
                        //show time selection
                        showTimePicker.toggle()
                    }
                    
                    
                    //ZStack that has padding but is clear so it is just for view formatting
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 105, height: 40)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 8)
                    //ZStack for View formatting
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 105, height: 40)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .padding(.top)
        }
        
    var dates: some View {
        VStack (alignment: .leading, spacing: 0){
            
            Text("Date")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal, 30)
                .offset(y: 6)
            
            
            HStack{
                
                
                ZStack {
                    if todayIsSelected {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentBigButton.opacity(0.3), lineWidth: 1.0)
                            .frame(width: 105, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accentSmallButton)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.accentMidGround)
                            .frame(width: 105, height: 40)
                    }
                    
                    
                    Text("Today")
                        .fontWeight(.semibold)
                        .foregroundColor(todayIsSelected ? Color.white: colorScheme == .light ? Color.detailGray2 : Color.cardGrey1)
                }
                
                .onTapGesture {
                    //show time selection
                    duplicateSessionVM.sessionDate = Date()
                    todayIsSelected = true
                    tomorrowIsSelected = false
                }
                
                
                ZStack {
                    if tomorrowIsSelected {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentBigButton.opacity(0.3), lineWidth: 1.0)
                            .frame(width: 105, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accentSmallButton)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.accentMidGround)
                            .frame(width: 105, height: 40)
                    }
                    
                    Text("Tomorrow")
                        .fontWeight(.semibold)
                        .foregroundColor(tomorrowIsSelected ? Color.white: colorScheme == .light ? Color.detailGray2 : Color.cardGrey1)
                }
                .padding(.horizontal, 8)
                .onTapGesture {
                    //show time selection
                    duplicateSessionVM.sessionDate = datesVM.setDateToTomorrow()
                    todayIsSelected = false
                    tomorrowIsSelected = true
                }
                
                ZStack {
                    Rectangle()
                    //                        .padding(.vertical, 10)
                    //                        .padding(.horizontal)
                        .background(Color.accentMidGround)
                        .foregroundColor(.accentMidGround)
                        .frame(width: 105, height: 40)
                        .cornerRadius(10)
                    
                    Text("\(datesVM.extractDate(date: duplicateSessionVM.sessionDate, format: "dd. MMM"))")
                        .fontWeight(.semibold)
                }
                //.padding()
                .onTapGesture {
                    //show time selection
                    showDatePicker.toggle()
                }
                
            }
            .padding()
        }
    }

        var athletes: some View {
            VStack (alignment: .leading, spacing: 0){
                
                Text("Athletes")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 30)
                    .offset(y: 6)
                
                

                VStack {
                            LazyVGrid(columns: preference, spacing: 16) {
                                
                                let enumerated = Array(zip(duplicateSessionVM.athletes.indices, duplicateSessionVM.athletes))
                                ForEach(enumerated, id: \.1) { index, athlete in
                                    VStack{
                                        ZStack{
                                        ZStack{
                                            Circle()
                                                .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                                .frame(height: 45)
                                            Text(getInitials(firstName: athlete.firstName, lastName: athlete.lastName))
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.cardProfileLetter)
                                        }
                                        .opacity(duplicateSessionVM.selectedIndices.contains(index) ? 0.3 : 1.0)
                                            Image(systemName: "checkmark")
                                                .resizable()
                                                .foregroundColor(.accentBigButton)
                                                .frame(width: 21, height: 16, alignment: .center)
                                                .opacity(duplicateSessionVM.selectedIndices.contains(index) ? 1.0 : 0.0)
                                        }
                                       
                                        
                                        Text("\(athlete.firstName)")
                                            .font(.caption)
                                            .opacity(duplicateSessionVM.selectedIndices.contains(index) ? 0.5 : 1.0)
                                    }
                                    .onTapGesture {
                                        if duplicateSessionVM.selectedIndices.contains(index) {
                                           duplicateSessionVM.selectedIndices.remove(index)
                                         } else {
                                           duplicateSessionVM.selectedIndices.insert(index)
                                         }
                                        duplicateSessionVM.toggleAthlete(athlete: athlete)
                                        print(duplicateSessionVM.selectedIndices)
                                    }

                                }
                            }

                        }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
                .padding()

            }
            .padding(.top)
        }
        
        var timePicker: some View {
            ZStack{
                if self.showTimePicker {
                    
                    Color.black
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture { showTimePicker.toggle() }
                    ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(colorScheme == .light ? .appBackground : .accentMidGround)
                        .frame(maxWidth: 250)
                        .frame(height: 220, alignment: .center)
                        .padding(.horizontal)
                        MyTimePicker(selection: $duplicateSessionVM.sessionTime, minuteInterval: 5, displayedComponents: .hourAndMinute)
                            .frame(maxWidth: 250)
                            .frame(height: 220, alignment: .center)
                    }
                }
            }
            .opacity(self.showTimePicker ? 1 : 0).animation(.easeIn, value: showTimePicker)
        }
        
        var datePicker: some View {
            ZStack{
                if self.showDatePicker {
                    
                    Color.black
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture { showDatePicker.toggle() }
                    
                       DateSeläctör(selectedDate: $duplicateSessionVM.sessionDate)
                        .onChange(of: duplicateSessionVM.sessionDate) { date in
                            if Calendar.current.isDateInToday(date) {
                                todayIsSelected = true
                                tomorrowIsSelected = false
                            } else if Calendar.current.isDateInTomorrow(date) {
                                todayIsSelected = false
                                tomorrowIsSelected = true
                            } else {
                                todayIsSelected = false
                                tomorrowIsSelected = false
                            }

                        }
                        }
                }
            
            .opacity(self.showDatePicker ? 1 : 0).animation(.easeIn, value: showDatePicker)
        }
    }


//struct DuplicateSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        DuplicateSessionView()
//    }
//}
