//
//  AthleteDetailView.swift
//  Whosthere
//
//  Created by Moose on 31.01.22.
//

import SwiftUI
import NavigationBackport



struct AthleteDetailView: View {
    
    // MARK: -Properties
    
    @Environment(\.presentationMode) var presentationMode                   //For dismissing views
    @Environment(\.colorScheme) var colorScheme                             //DarkMode
    

    @EnvironmentObject var appState: AppState
    @EnvironmentObject var tabDetail: TabDetailVM
    
    @State private var birthToggle: Bool = false                          //Variable to switch between displaying birthdate and birthyear
    @State var showKWPicker1: Bool = false
    
    @ObservedObject var detailVM: AthleteDetailVM
    
    
    init(athlete: Athlete, dataManager: DataManager = DataManager.shared) {
        self.detailVM = AthleteDetailVM(athlete: athlete) ?? AthleteDetailVM(athlete2: athlete)
        print("Initializing Detail View for: \(String(describing: detailVM.detailAthlete.firstName))")
        print("\(Date().endOfWeek())")
    }
  
    var sessionsArray: [Session] {
        var arrayOfSessions: [Session] = []
        //ForEach(detailVM.detailAthlete.sessionIDs, id: \.self) {sessionID in
        for sessionID in detailVM.detailAthlete.sessionIDs {
                if let session = detailVM.getSessions(with: sessionID) {
                    arrayOfSessions.append(session)
                }
            }
        return arrayOfSessions
    }
    
    var date1ToCheck: Date {
        var date = Date()
        for (key, _) in detailVM.station.dateFilterAttendance {
            date = key
        }
        return date
    }
    
    var date2ToCheck: Date {
        var date = Date()
        for (_, value) in detailVM.station.dateFilterAttendance {
            date = value
        }
        return date
    }
    
    var selectedSessionAttendance: Int {
        let allSessions = sessionsArray
        let filteredSessions1 = allSessions.filter({ (session) -> Bool in
            return session.date >= date1ToCheck
        })
        let filteredSessions2 = filteredSessions1.filter({ (session) -> Bool in
            return session.date <= date2ToCheck
        })
        return filteredSessions2.count
    }
    
    //MARK: -Body
    
    var body: some View {
        ZStack{
            VStack{
//Header
                VStack{
                    
                    AthleteDetailHeaderButtons
                        .padding(.bottom, -10)

                    profilePicture
                        .padding(.top, -20)
                        .padding(.bottom, -15)
                
                    nameAndBirthday
                
                }
                .onAppear{
                    print("detail reloaded")
                }
                
                HStack{
                    Text("\(selectedSessionAttendance)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.headerText)
                        .padding()
                        .padding(.leading)
                    
                    Spacer()
                    
                    
                    //Make the button a zstack instaed and have the background and chevron on seperate level so it doesnt move with the text
                    
                    Button {
                        withAnimation {
                            showKWPicker1.toggle()
                        }
                    } label: {
                        
                        HStack(alignment: .lastTextBaseline){
                            if date1ToCheck.extractWeek() == date2ToCheck.extractWeek() {
                                Text("    KW " + "\(date1ToCheck.extractWeek())    ")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.headerText)
                                    
                            } else {
                                Text("KW " + "\(date1ToCheck.extractWeek())" + " - " + "\(date2ToCheck.extractWeek())")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.headerText)
                            }
                                //Arrow down
                                Image(systemName: "chevron.down")
                                    .font(.caption2)
                                    .foregroundColor(.headerText)
                            }
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(Color.appBackground).frame(width: 100, height: 30))
                            .padding()
                        
                    }

                    
                    
                }
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
                .padding()
                
                 Spacer()
                
                }
            .onAppear(perform: { self.tabDetail.showDetail = true })
            .background(Color.appBackground)
            .navigationBarHidden(true)
            
            VStack{
                Spacer()
                
                ActionSheetSelectKWDetail(showActionSheet: $showKWPicker1, datesVM: DatesVM(), kw1: date1ToCheck, kw2: date2ToCheck).offset(y: self.showKWPicker1 ? 0 : UIScreen.main.bounds.height)

            }.background((showKWPicker1 ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
                //tabDetail.showDetail.toggle()
                withAnimation {
                    showKWPicker1.toggle()
                }
            }))
            .edgesIgnoringSafeArea(.bottom)
           
            }//ZStack
        }//end of Body
    
            
    //MARK: -Dateformatter
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    
    // MARK: -Outsourced Components
    
    var nameAndBirthday: some View {
    
    VStack(spacing: UIScreen.main.bounds.height/80){
        HStack(spacing: 6) {
            Text(detailVM.detailedAthlete.firstName)
                .font(.title3)
                .fontWeight(.bold)
            Text(detailVM.detailedAthlete.lastName)
                .font(.title3)
                .fontWeight(.bold)
            }
            .foregroundColor(Color.header)
        VStack{
           
            if let dateOfBirth = detailVM.detailedAthlete.birthday {
                if detailVM.detailedAthlete.showYear {
                    Text("\(String(describing: Calendar.current.component(.year, from: dateOfBirth)))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.header)
                        .padding(.bottom, 15)
                } else {
                    Text(birthToggle == false ? "\(String(describing: Calendar.current.component(.year, from: dateOfBirth)))" : dateFormatter.string(from: dateOfBirth))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.header)
                            .onTapGesture {
                                withAnimation(.easeOut){
                                birthToggle.toggle()
                                }
                            }
                            .padding(.bottom, 15)
                }
                
            } else {
                HStack{
                    Text("Add birthday")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.header)
                        .opacity(0.7)

                    Image("PenIcon")
                        .foregroundColor(Color.header)
                        .opacity(0.7)
                        .padding(.horizontal, -3)
                    }
                    .padding(.bottom, 15)
                   
            }
        }
    }
}
    
    var AthleteDetailHeaderButtons: some View {
    
    HStack(){
        
        Button(action: {

            tabDetail.showDetail = false
            
            appState.path.removeLast()
            
        }){
            Image(systemName: "arrow.backward")
                .resizable()
                .foregroundColor(.header)
                .frame(width: 27, height: 20)
        }
        
        Spacer(minLength: 0)
        
        
        Spacer(minLength: 0)
        
        NBNavigationLink(value: Route.edit(detailVM.detailAthlete)) {
                Image("PenIcon")
                    .resizable()
                    .foregroundColor(.header)
                    .frame(width: 25, height: 25)
            }

        
    }//HeaderHStackEnding
    .padding(.horizontal, 25)
    .padding(.top, 25)
}
    
    var profilePicture: some View {
        
        ZStack {
            Rectangle()
                .frame(minWidth: 108, maxWidth: 108, minHeight: 108, maxHeight: 108)
                .foregroundColor(Color.header)
                .clipShape(Circle())
                .padding()
            
            Rectangle()
                .frame(minWidth: 0, maxWidth: 104, minHeight: 0, maxHeight: 104)
                .clipShape(Circle())
                .foregroundColor(colorScheme == .light ? .accentMidGround : .accentBigButton)
                .padding()
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 42, height: 42, alignment: .center)
                .foregroundColor(colorScheme == .light ? .cardGrey2 : .cardProfileLetter)
        }
    }
}

