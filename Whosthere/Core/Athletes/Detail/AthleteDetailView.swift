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
    
    @State var showKWPicker2: Bool = false
    @State var showKWPicker1: Bool = false
    @State var showXAttendedPicker: Bool = false
    @ObservedObject var detailVM: AthleteDetailVM
    
    @State var refresh: Bool = false
    
    @EnvironmentObject var station: Station
    @StateObject var dataDetailVM: DetailDataVM = DetailDataVM()
    @StateObject var datesVM = DatesVM()
    //@StateObject var station: Station = Station() //necessary so KWSelectionUpdates
    
    init(athlete: Athlete, dataManager: DataManager = DataManager.shared) {
        self.detailVM = AthleteDetailVM(athlete: athlete) ?? AthleteDetailVM(athlete2: athlete)
        //print("Initializing Detail View for: \(String(describing: detailVM.detailedAthlete.firstName))")

        }

    //MARK: -Body
    
    var body: some View {
       
           
                ZStack{
                   // GeometryReader{ p in
                    //ScrollView{
                    VStack(spacing: 0){
                        //Header
                        VStack{
                            
                            AthleteDetailHeaderButtons
                                .padding(.bottom, -10)
                            
                            profilePicture
                                .padding(.top, -20)
                                .padding(.bottom, -15)
                            
                            nameAndBirthday
                        }
                        //Body
                        attendancePanel
                        
                        DistributionPanel(dataDetailVM: dataDetailVM,showXAttendedPicker: $showXAttendedPicker, showPickerSelectKW: $showKWPicker1, refresh: $refresh)
                        
                       /* CourseOfAttendancePanel(dataDetailVM: dataDetailVM)
                            .frame(width: p.size.width, height: p.size.height/5, alignment: .center)
                        */
                        Spacer()
                        
                    }
                    .onAppear(perform: {
                        detailVM.fetchAthlete()
                        self.tabDetail.showDetail = true })
                    .background(Color.appBackground)
                    .navigationBarHidden(true)
                    
                    implementSelectKWSheet
                    
                    implemetPerXSheet
                    
                    implemetXAttendedSheet
                }//ZStack
          //  }//scrollview
     //  }
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
        
        NBNavigationLink(value: Route.edit(detailVM.detailedAthlete)) {
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
    
    var attendancePanel: some View {
        HStack{
            Text(dataDetailVM.selectedSessionAttendance.clean)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.header)
                .padding()
                .padding(.leading)
                .animation(.easeInOut, value: dataDetailVM.animate)
               /* .onAppear{
                    getModifiedSession()
                    getAttendanceCount()
                    fillDistributedSessions()
                    fillBarHeights()
                }*/
                .onReceive(station.$dateFilterAttendance, perform: {
                    print("filter changed \($0)")
                    getModifiedSession()
                    getAllModifiedSessions()
                    getAttendanceCount()
                    fillDistributedSessions()
                    fillAllSessionDistribution()
                    //withAnimation {
                    fillAllSessionsBarHeights()
                    fillCourseOfSessions()
                    //}
                    
                })
                .onReceive(station.$perXAttendance, perform: {
                    print("filter changed \($0)")
                    getModifiedSession()
                    getAllModifiedSessions()
                    getAttendanceCount()
                    fillDistributedSessions()
                    fillAllSessionDistribution()
                    fillAllSessionsBarHeights()
                    fillCourseOfSessions()

                })
             /*   .onReceive(dataDetailVM.$sessionBarHeights, perform: {
                    print("bar height changed \($0)")
                    if dataDetailVM.sessionBarHeights.contains(1.0) {
                        print("it contains it")
                    } else {
                        print("doesn't contain it")
                    }
                    print(dataDetailVM.sessionBarHeights)
                }
                )
                .onReceive(dataDetailVM.$modifiedArrayOfSessions, perform: {
                    print("modified sessions changed \($0)")}
                )
                .onReceive(dataDetailVM.$selectedSessionAttendance, perform: {
                    print("selected sessios changed \($0)")}
                )*/
            
            
            
            VStack(alignment: .leading, spacing: 2){
                Text("Attendances")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.header)
                HStack(spacing: 4){
                    if station.perXAttendance == .total { Text("total") }
                    else if station.perXAttendance == .perMonth { Text("per Month") }
                    else if station.perXAttendance == .perWeek { Text("per Week") }
                    Image(systemName: "chevron.down")
                        .font(.system(size: 9))
                }
                .font(.caption2)
                .foregroundColor(.cardGrey2)
                .onTapGesture {
                    withAnimation {
                        showKWPicker2.toggle()
                    }
                }
            }
            .background(Color.clear.disabled(refresh))
            
            
            Spacer()
            
            KWButton(station: station, showKWPicker1: $showKWPicker1)
            //put kw button here
        }
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    var implementSelectKWSheet: some View {
        VStack{
            Spacer()
            
            ActionSheetSelectKWDetail(showActionSheet: $showKWPicker1, refresh: $refresh, datesVM: DatesVM(), dataDetailVM: dataDetailVM, kw1: station.dateFilterAttendance.date1, kw2: station.dateFilterAttendance.date2).offset(y: self.showKWPicker1 ? 0 : UIScreen.main.bounds.height)

        }.background((showKWPicker1 ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
            withAnimation {
                showKWPicker1.toggle()
            }
        }))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var implemetPerXSheet: some View {
        VStack{
            Spacer()
            PerXAttendanceDetailActionSheet(showActionSheet: $showKWPicker2, dataDetailVM: dataDetailVM)
             .offset(y: self.showKWPicker2 ? 0 : UIScreen.main.bounds.height)

        }.background((showKWPicker2 ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
            withAnimation {
                showKWPicker2.toggle()
            }
        }))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var implemetXAttendedSheet: some View {
        VStack{
            Spacer()
            XAttendedDistributionActionSheet(showActionSheet: $showXAttendedPicker, dataDetailVM: dataDetailVM)
                .offset(y: self.showXAttendedPicker ? 0 : UIScreen.main.bounds.height)

        }.background((showXAttendedPicker ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
            withAnimation {
                showXAttendedPicker.toggle()
            }
        }))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func getAllModifiedSessions() {
        let allSessions = detailVM.allSessions
        let filteredSessions1 = allSessions.filter({ (session) -> Bool in
            return session.date >= UserDefaults.standard.dateFilterAttendance?.date1 ?? Date()
        })
        let filteredSessions2 = filteredSessions1.filter({ (session) -> Bool in
            return session.date <= UserDefaults.standard.dateFilterAttendance?.date2 ?? Date()
        })
        dataDetailVM.modifiedAllSessions = filteredSessions2
    }
    
    func getModifiedSession() {
        
        let allSessions = detailVM.arrayOfSessions
        let filteredSessions1 = allSessions.filter({ (session) -> Bool in
            return session.date >= UserDefaults.standard.dateFilterAttendance?.date1 ?? Date()
        })
        let filteredSessions2 = filteredSessions1.filter({ (session) -> Bool in
            return session.date <= UserDefaults.standard.dateFilterAttendance?.date2 ?? Date()
        })
        dataDetailVM.modifiedArrayOfSessions = filteredSessions2
        //print("got modified sessions")
    }
    
    
    func getAttendanceCount() {
        //necessary so average is not diluated by a selection that is in the future, where attendance is impossible
        var endDate: Date {
            if UserDefaults.standard.dateFilterAttendance?.date2 ?? Date() > Date().endOfWeek() {
                return Date().endOfWeek()
            } else {
                return UserDefaults.standard.dateFilterAttendance?.date2 ?? Date()
            }
        }
        switch UserDefaults.standard.perXAttendance {
        case .total:
            dataDetailVM.selectedSessionAttendance = Float(dataDetailVM.modifiedArrayOfSessions.count)
        case .perMonth:
            let perMonthNumber = Float(dataDetailVM.modifiedArrayOfSessions.count) / (Float(Calendar.current.numberOfDaysBetween(UserDefaults.standard.dateFilterAttendance?.date1 ?? Date(), and: endDate)) / 30.436875)
            dataDetailVM.selectedSessionAttendance = round(perMonthNumber * 10) / 10.0
        case .perWeek:
            let perWeekNumber = Float(dataDetailVM.modifiedArrayOfSessions.count) / Float(Calendar.current.numberOfDaysBetween(UserDefaults.standard.dateFilterAttendance?.date1 ?? Date(), and: endDate) / 7)
            dataDetailVM.selectedSessionAttendance = round(perWeekNumber * 10) / 10.0
        case .none:
            dataDetailVM.selectedSessionAttendance = Float(dataDetailVM.modifiedArrayOfSessions.count)
        }
    }
    
  
    func fillAllSessionDistribution(){
        var sessionsForWeekdays: [Session] = []
        var distributedSessions = [[Session]]()
        //distributionSessions.removeAll()
        (1...7).forEach { day in
            (dataDetailVM.modifiedAllSessions).forEach { session in
                
                if Calendar.current.dateComponents([.weekday], from: session.date).weekday == day {
                    sessionsForWeekdays.append(session)
                    //print(sessionsForWeekdays)
                }
            }
            
            distributedSessions.append(sessionsForWeekdays)
            sessionsForWeekdays.removeAll()
        }
        dataDetailVM.distributionAllSessions = distributedSessions
    }
    
    func fillCourseOfSessions() {
        var weekToCollect: [Session] = []
        var weekInt: Int = 0
        var weekDate: Date = Date()
        var courseOfSession = [(Int, [Session])]()
        var courseOfSessionSimplified = [(Date, Int)]()
        
        let startWeek = UserDefaults.standard.dateFilterAttendance?.date1.extractWeek() ?? 1
        let lastWeek = UserDefaults.standard.dateFilterAttendance?.date2.extractWeek() ?? 1
        
        (startWeek...lastWeek).forEach { week in
            (dataDetailVM.modifiedArrayOfSessions).forEach { session in
                weekInt = week
                weekDate = datesVM.getWeekOfYear(from: week, year: 2022) ?? Date()
                if Calendar.current.dateComponents([.weekOfYear], from: session.date).weekOfYear == week {
                    weekToCollect.append(session)
                }
            }
            
            courseOfSession.append((weekInt, weekToCollect))
            courseOfSessionSimplified.append((weekDate, weekToCollect.count))
            weekToCollect.removeAll()
        }
        dataDetailVM.courseOfAttendance = courseOfSession
        dataDetailVM.courseOfAttendanceSimplified = courseOfSessionSimplified
        print("course of attendance: \(dataDetailVM.courseOfAttendance)")
        print("courseSimplified: \(dataDetailVM.courseOfAttendanceSimplified)")
    }
    
    func fillDistributedSessions() {
        //print(modifiedArrayOfSessions)
        
        var sessionsForWeekdays: [Session] = []
        var distributedSessions = [[Session]]()
        //distributionSessions.removeAll()
        (1...7).forEach { day in
            (dataDetailVM.modifiedArrayOfSessions).forEach { session in
                
                if Calendar.current.dateComponents([.weekday], from: session.date).weekday == day {
                    sessionsForWeekdays.append(session)
                    //print(sessionsForWeekdays)
                }
            }
            
            distributedSessions.append(sessionsForWeekdays)
            sessionsForWeekdays.removeAll()
        }
        dataDetailVM.distributionSessions = distributedSessions
      //print(distributionSessions)
    }
    
    
    func fillAllSessionsBarHeights() {
        
        var sessionsCount: [Int] = []
       // print(distributionSessions)
        (dataDetailVM.distributionAllSessions).forEach { sessions in
            let count = sessions.count
            sessionsCount.append(count)
        }
        //print(sessionsCount)
        //find highest count -> make it 100
        guard let largestCount = sessionsCount.max() else {
            return print("no largest count")
        }
        //print(largestCount)
        var barHeightsProviso = [Float]()
        
        (sessionsCount).forEach { sessionCount in
            
            /*if sessionCount == largestCount {
                height = 100
            } else {*/
            var height: Float = (Float(sessionCount) / Float(largestCount)) * 100
            //}
            
            if height == 0 {
                height += 1
            }
            barHeightsProviso.append(height)
        }
        dataDetailVM.sessionAllBarHeights = barHeightsProviso
   // }
    //func fillBarHeights() {
        
        var sessionsCount2: [Int] = []
       // print(distributionSessions)
        (dataDetailVM.distributionSessions).forEach { sessions in
            let count = sessions.count
            sessionsCount2.append(count)
        }
        //print(sessionsCount)
        //find highest count -> make it 100
        //guard let largestCount2 = sessionsCount2.max() else {
        //    return print("no largest count")
        //}
        //print(largestCount)
        var barHeightsProviso2 = [Float]()
        
        (sessionsCount2).forEach { sessionCount in
            
            /*if sessionCount == largestCount {
                height = 100
            } else {*/
            var height: Float = (Float(sessionCount) / Float(largestCount)) * 100
            //}
            
            if height == 0 {
                height += 1
            }
            barHeightsProviso2.append(height)
        }
        dataDetailVM.sessionBarHeights = barHeightsProviso2
    }
}

struct KWButton: View {
    @ObservedObject var station: Station
    @Binding var showKWPicker1: Bool
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5).foregroundColor(Color.appBackground).frame(width: 94, height: 30)
            
            HStack(alignment: .lastTextBaseline){
                    Text("KW " + "50" + " - " + "50")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.clear)
               
                    //Arrow down
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.header)
                }
            
            HStack(alignment: .lastTextBaseline){
                if station.dateFilterAttendance.date1.extractWeek() == station.dateFilterAttendance.date2.extractWeek() {
                    Text("    KW " + "\(station.dateFilterAttendance.date1.extractWeek())    ")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.header)
                        
                } else {
                    Text("KW " + "\(station.dateFilterAttendance.date1.extractWeek())" + " - " + "\(station.dateFilterAttendance.date2.extractWeek())")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.header)
                }
                    //Arrow down
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.clear)
                }
        }
        .onTapGesture {
            withAnimation {
                showKWPicker1.toggle()
            }
        }
        .padding(.horizontal, 6)
    }
}
