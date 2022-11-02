//
//  EditSessionView.swift
//  Whosthere
//
//  Created by Moose on 27.09.22.
//

import SwiftUI
import NavigationBackport

struct EditSessionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var selectedDay: Date
    @Binding var scrollToIndexOfSessions: Date
    @State var duplicationLabelOpacity: Double = 0.0
    
    @State var todayIsSelected: Bool = false
    @State var tomorrowIsSelected: Bool = false
    
    @State var showTimePicker: Bool = false
    @State var showDatePicker: Bool = false
    @State var showAddAthleteSheet: Bool = false
    @State var showActionSheet: Bool = false
    
    @ObservedObject var editSessionVM: EditSessionVM
    @ObservedObject var datesVM: DatesVM
    @ObservedObject var duplicateSessionVM: DuplicateSessionVM
    
    var athleteArray = [UUID]()
    
    var athletesToCheck: [Athlete] {
        switch datesVM.station.sortAthletes {
       case .firstNameFromA:
            return editSessionVM.athletes.sorted(by: {$0.firstName < $1.firstName } )
       case .firstNameFromZ:
            return editSessionVM.athletes.sorted(by: {$0.firstName > $1.firstName } )
       case .genderFemaleFirst:
            return editSessionVM.athletes.sorted(by: {$0.gender > $1.gender } )
       case .genderMaleFirst:
            return editSessionVM.athletes.sorted(by: {$0.gender < $1.gender } )
       case .dateAddedFromOldest:
            return editSessionVM.athletes.sorted(by: {$0.dateAdded < $1.dateAdded } )
       case .dateAddedFromNewest:
            return editSessionVM.athletes.sorted(by: {$0.dateAdded > $1.dateAdded } )
       
       }
   }
    
   

     
    
    
    @EnvironmentObject var appState: AppState                                       //For Navigation
    @EnvironmentObject var tabDetail: TabDetailVM                                   //For Tabbar hiding
    
    let preference = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(session: Session?, dataManager: DataManager = DataManager.shared, selectedDay: Binding<Date>, scrollToIndexOfSessions: Binding<Date>) {
        self.editSessionVM = EditSessionVM(session: session, dataManager: dataManager)
        self.datesVM = DatesVM()
        self.duplicateSessionVM = DuplicateSessionVM(session: session)
        self._selectedDay = selectedDay
        self._scrollToIndexOfSessions = scrollToIndexOfSessions
        
        if editSessionVM.sessionDate == editSessionVM.mergeTimeAndDate(time: editSessionVM.sessionTime, date: Date()) {
            self._todayIsSelected = State(wrappedValue: true)
        } else if editSessionVM.sessionDate == editSessionVM.mergeTimeAndDate(time: editSessionVM.sessionTime, date: datesVM.setDateToTomorrow()) {
            self._tomorrowIsSelected = State(wrappedValue: true) }
        
       //For initializing the checkmarks
        //creating an array with the IDs of all the athletes so the can later be compared
        for athlete in editSessionVM.athletes {
            athleteArray.append(athlete.id) }
        

            //creating dictionary with key of index and value of id, exactly like the tuple used to select the checkmarks in the view
        let arrayOfAthletes = Dictionary(uniqueKeysWithValues: zip(athleteArray.indices, athleteArray))
        
        //running through all the athletes and if the session has an athlete, the key is added to the selectedIndicies and that triggers the checkmark
        if let session = session {
        for (key, value) in arrayOfAthletes {
            for id in session.athleteIDs {
                if id == value {
                    editSessionVM.selectedIndices.insert(key)
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
                editSessionHeader
                
                time

                dates

                athletes

                Spacer()

        //Delete Butttons
                    
                HStack{
                    duplicateSessionButton(duplicationLabelOpacity: $duplicationLabelOpacity, editSessionVM: editSessionVM, datesVM: datesVM)
                    Spacer()
                    duplicationSuccessLabel
                    Spacer()
                    deleteSessionButton(editSessionVM: editSessionVM)
                }

                }.frame(minHeight: geometry.size.height)
            }.frame(width: geometry.size.width)
                VStack{
                    Spacer()
                    
                    SortAthletesActionSheet(editSessionVM: editSessionVM, showActionSheet: $showActionSheet).offset(y: self.showActionSheet ? 0 : UIScreen.main.bounds.height)

                }.background((showActionSheet ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
                    //tabDetail.showDetail.toggle()
                    withAnimation {
                        showActionSheet.toggle()
                    }
                }))
                .edgesIgnoringSafeArea(.bottom)

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
    
    var editSessionHeader: some View {
        HStack{
            Button(action: {
                
                if editSessionVM.duplicatedIsTrue == false {
                     datesVM.selectedDay = editSessionVM.sessionDate

                } else {

                    //selectedDay = datesVM.setDateToStartOfWeek(date: editSessionVM.selectedDayFromDuplication)
                }//that maddness is to control whcich sessions are shown after going back...the normal ones or the duplicated session
                appState.path.removeLast()
                tabDetail.showDetail = false
            }){
                //NavigationButtonSystemName(iconName: "chevron.backward")
                Image(systemName: "arrow.backward")
                    .resizable()
                    .foregroundColor(.header)
                    .frame(width: 27, height: 20)
            }
            
            Spacer(minLength: 0)
            
            Text("Edit Session")
                .font(.title)
                .foregroundColor(.header)
                .fontWeight(.medium)
            
            Spacer(minLength: 0)
            
            Button(action: {
                editSessionVM.saveSession()
                editSessionVM.duplicatedIsTrue = false
                selectedDay = datesVM.setDateToStartOfWeek(date: editSessionVM.sessionDate) //so it sets the selected day to the first of the week and the buttons recognize that
                scrollToIndexOfSessions = datesVM.mergeTimeAndDate(time: editSessionVM.sessionTime, date: editSessionVM.sessionDate)
                print("EditSession: \(datesVM.mergeTimeAndDate(time: editSessionVM.sessionTime, date: editSessionVM.sessionDate))")
                appState.path.removeLast()
                tabDetail.showDetail = false
                //datesVM.scrollToIndexOfSessions = editSessionVM.sessionDate
                
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
                    
                    
                    Text("\(datesVM.extractDate(date: datesVM.roundMinutesDown(date: editSessionVM.sessionTime), format: "HH:mm"))")
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
                editSessionVM.sessionDate = Date()
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
                editSessionVM.sessionDate = datesVM.setDateToTomorrow()
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
                
                Text("\(datesVM.extractDate(date: editSessionVM.sessionDate, format: "dd. MMM"))")
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
            HStack{
                Text("Athletes")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 30)
                    .offset(y: 6)
                
                Spacer()
                
                Button {
                    //open sort action sheet
                    withAnimation {
                        showActionSheet.toggle()
                    }
                   //athletesToCheck = athletesToCheck.sorted(by: {$0.firstName < $1.firstName } )
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16))
                        .foregroundColor(Color.midTitle)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 6)
                        .offset(y: 9)
                }

            }
            
            
            VStack {
                        LazyVGrid(columns: preference, spacing: 16) {

                            //ForEach(editSessionVM.athletes, id: \.self) { athlete in
                            ForEach(athletesToCheck, id: \.self) { athlete in

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
                                    //.id(athlete.id)
                                    .opacity(editSessionVM.selectedAthletes.contains(athlete.id) ? 0.3 : 1.0)
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .foregroundColor(.midTitle)
                                            .frame(width: 21, height: 16, alignment: .center)
                                            .opacity(editSessionVM.selectedAthletes.contains(athlete.id) ? 1.0 : 0.0)
                                    }
                                   
                                    
                                    Text("\(athlete.firstName)")
                                        .font(.caption)
                                        .opacity(editSessionVM.selectedAthletes.contains(athlete.id) ? 0.5 : 1.0)
                                }
                                .onTapGesture {
                                    if editSessionVM.selectedAthletes.contains(athlete.id) {
                                        editSessionVM.selectedAthletes.remove(athlete.id)
                                     } else {
                                         editSessionVM.selectedAthletes.insert(athlete.id)
                                     }
                                    editSessionVM.toggleAthlete(athlete: athlete)
                                }

                            }
                            Button {
                                //add athlete
                                showAddAthleteSheet.toggle()
                            } label: {
                                VStack{
                                    
                                    ZStack{
                                        Circle()
                                            .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                            .frame(height: 45)
                                        Image(systemName: "person.badge.plus")
                                            .font(.system(size: 20))
                                            .font(.caption2)
                                            .foregroundColor(.cardProfileLetter)
                                            .offset(x: 1)
                                    }
                                    
                                    Text("Add")
                                        .font(.caption)
                                }
                                .fullScreenCover(isPresented: $showAddAthleteSheet, content: {
                                    AddAthleteView()
                                })
                          }

                        }

                    }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
            .padding()

        }
        //.padding(.top)
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
                    MyTimePicker(selection: $editSessionVM.sessionTime, minuteInterval: 5, displayedComponents: .hourAndMinute)
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
                
                   DateSeläctör(selectedDate: $editSessionVM.sessionDate)
                    .onChange(of: editSessionVM.sessionDate) { date in
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
    
    var duplicationSuccessLabel: some View {
        HStack(spacing: 4){
            Text("Session has been duplicated")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Image(systemName: "checkmark")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 8, height: 8)
                .font(Font.title.weight(.bold))
        }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.successLabel)
                    )
                    .opacity(duplicationLabelOpacity)
    }
}


struct deleteSessionButton: View{
    
    @State var showAlert: Bool = false
    @ObservedObject var editSessionVM: EditSessionVM
    
    @EnvironmentObject var appState: AppState                                       //For Navigation
    @EnvironmentObject var tabDetail: TabDetailVM
    
    
    var body: some View {
    VStack{
        Button(action: {
            showAlert.toggle()
        }){
            HStack{
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                        .padding(.horizontal, 5)
            }
            .frame(width: 44, height: 44)
            .background(Color.accentMidGround)
            .foregroundColor(Color.red)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Are you sure you want to delete this session?"),
                      message: Text("This action cannot be undone!"),
                      primaryButton: .destructive(Text("Delete"),
                      action: {
                    editSessionVM.deleteSession()
                    tabDetail.showDetail = false
                    appState.path.removeLast()
                    }),
                      secondaryButton: .cancel())
                })
            }
            //.frame(maxWidth: .infinity, alignment: .bottom)
        }
    }
}

struct duplicateSessionButton: View{
    
    
    @State var showSheet: Bool = false
    @Binding var duplicationLabelOpacity: Double
    @ObservedObject var editSessionVM: EditSessionVM
    @ObservedObject var datesVM: DatesVM
    //@ObservedObject var duplicateSessionVM: DuplicateSessionVM
    
    @EnvironmentObject var appState: AppState                                       //For Navigation
    @EnvironmentObject var tabDetail: TabDetailVM
    
    var body: some View {
    VStack{
        Button(action: {
            showSheet.toggle()
        }){
            HStack{
                    Image(systemName: "doc.on.doc.fill")
                        .font(.system(size: 20))
                        .padding(.horizontal, 5)
            }
            .frame(width: 44, height: 44)
            .background(Color.accentMidGround)
            .foregroundColor(Color.midTitle.opacity(0.8))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .fullScreenCover(isPresented: $showSheet, content: {
                DuplicateSessionView(session: editSessionVM.editedSession, selectedDay: $datesVM.selectedDay
                                     , duplicationLabelOpacity: $duplicationLabelOpacity
                )
            })
            }
        }
    }
}

//--------------------------------------
struct SortAthletesActionSheet: View {
    
    @ObservedObject var editSessionVM: EditSessionVM
    @Environment(\.colorScheme) var colorScheme
    //let session: Session
    @Binding var showActionSheet: Bool
    
    @State var alphabeticallyIsSelected: Bool = false
    @State var dateAddedIsSelected: Bool = false
    @State var genderIsSelected: Bool = false
    
    @State var alphaTog: Bool = false
    @State var dateAddedTog: Bool = false
    @State var genderTog: Bool = false
    
    init(editSessionVM: EditSessionVM, showActionSheet: Binding<Bool>){
        self.editSessionVM = editSessionVM
        self._showActionSheet = showActionSheet
        if station.sortAthletes == .firstNameFromA {
            self._alphabeticallyIsSelected = State(wrappedValue: true)
            self._alphaTog = State(wrappedValue: true)
        } else if station.sortAthletes == .firstNameFromZ {
            self._alphabeticallyIsSelected = State(wrappedValue: true)
            self._alphaTog = State(wrappedValue: false)
        }else if station.sortAthletes == .dateAddedFromOldest {
            self._dateAddedIsSelected = State(wrappedValue: true)
            self._dateAddedTog = State(wrappedValue: true)
        } else if station.sortAthletes == .dateAddedFromNewest {
            self._dateAddedIsSelected = State(wrappedValue: true)
            self._dateAddedTog = State(wrappedValue: false)
        }else if station.sortAthletes == .genderFemaleFirst {
            self._genderIsSelected = State(wrappedValue: true)
            self._genderTog = State(wrappedValue: true)
        } else if station.sortAthletes == .genderMaleFirst {
            self._genderIsSelected = State(wrappedValue: true)
            self._genderTog = State(wrappedValue: false)
        }
    }
    
    //@Preference(\.testDefault) var testDefault
    
    @ObservedObject var station = Station()
    
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
                            if alphabeticallyIsSelected && alphaTog == true {
                                let firstNameFromA = Sort.firstNameFromA
                                UserDefaults.standard.sortAthletes = firstNameFromA
                            } else if alphabeticallyIsSelected == true && alphaTog == false {
                                let firstNameFromZ = Sort.firstNameFromZ
                                UserDefaults.standard.sortAthletes = firstNameFromZ
                            } else if dateAddedIsSelected && dateAddedTog == true {
                                let dateFromOldest = Sort.dateAddedFromOldest
                                UserDefaults.standard.sortAthletes = dateFromOldest
                            } else if dateAddedIsSelected == true && dateAddedTog == false {
                                let dateFromNewest = Sort.dateAddedFromNewest
                                UserDefaults.standard.sortAthletes = dateFromNewest
                            } else if genderIsSelected && genderTog == true {
                                let femaleFirst = Sort.genderFemaleFirst
                                UserDefaults.standard.sortAthletes = femaleFirst
                            } else if genderIsSelected == true && genderTog == false {
                                let maleFirst = Sort.genderMaleFirst
                                UserDefaults.standard.sortAthletes = maleFirst
                            }
                            
                            
                        } label: {
                            HStack{
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .foregroundColor(.midTitle)
                                    .frame(width: 20, height: 15.3)
//                                    Text("Apply")
//                                        .font(.headline)
                            }
                            .padding(.vertical, 10)
                            .padding(.leading, 10)
                            .padding(.trailing, 5)
                            .offset(y: -3)
                            //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                            //.background(Color.accentBigButton)
                            //.foregroundColor(Color.accentBigButton)
                            //.cornerRadius(10)
                            //.padding()
                        }
                }
                //.padding(.horizontal)
                .padding(.vertical, 1)
                
                
            
                       
                    
                
                
            VStack{
            Button {
                if alphabeticallyIsSelected == false {
                    dateAddedIsSelected = false
                    genderIsSelected = false
                    alphabeticallyIsSelected = true
                    
                } else {
                    alphaTog.toggle()
                }

                
                
            } label: {
                HStack{
                    Text("Alphabetically")
                    .fontWeight(.semibold)
                    
                    Image(systemName: "arrow.down")
                        .font(.system(size: 13))
                        .padding(.horizontal, 0.5)
                        .rotationEffect(alphaTog ? .degrees(0) : .degrees(180))
                    
                    Spacer()
                }
                .foregroundColor(.midTitle)
                .padding(.vertical, 12)
                .opacity(alphabeticallyIsSelected ? 1.0 : 0.3)
                
            }
            
            Button {
                if dateAddedIsSelected == false {
                    dateAddedIsSelected = true
                    genderIsSelected = false
                    alphabeticallyIsSelected = false

                } else {
                    dateAddedTog.toggle()
                }

            } label: {
                HStack{
                    Text("Date Added")
                    .fontWeight(.semibold)
                    Image(systemName: "arrow.down")
                        .font(.system(size: 13))
                        .padding(.horizontal, 0.5)
                        .rotationEffect(dateAddedTog ? .degrees(0) : .degrees(180))
                    
                    Spacer()
                }
                .foregroundColor(.midTitle)
                .padding(.vertical, 12)
                .opacity(dateAddedIsSelected ? 1.0 : 0.3)
            }
            
            Button {
                if genderIsSelected == false {
                    dateAddedIsSelected = false
                    genderIsSelected = true
                    alphabeticallyIsSelected = false
                } else {
                    genderTog.toggle()
                }
            } label: {
                HStack{
                    Text("Gender")
                    .fontWeight(.semibold)
                    
                    
                        if genderTog == false {
                            Image("FemaleIcon")
                                .resizable()
                                .frame(width: 8.41, height: 13)
                                .padding(.horizontal, 0.5)
                        } else {
                            Image("MaleIcon")
                                .resizable()
                                .frame(width: 13, height: 13)
                                .padding(.horizontal, 0.5)
                        }
                    
                    
                    
                    Spacer()
                }
                .foregroundColor(.midTitle)
                .padding(.vertical, 12)
                .opacity(genderIsSelected ? 1.0 : 0.3)
                
            }
                
            

        }
            .padding(.horizontal, 4)
            .padding(.bottom, 5)

            
        }
            .padding(.vertical)
            .padding(.horizontal)
            .background(Color.appBackground.clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 20)))
            .edgesIgnoringSafeArea(.bottom)
            
    }
    
    }
