//
//  StatisticsView.swift
//  Whosthere
//
//  Created by Moose on 18.12.22.
//

import SwiftUI

struct StatisticsView: View {
    
    @Environment(\.colorScheme) var colorScheme                             //DarkMode

    @EnvironmentObject var appState: AppState
    @EnvironmentObject var tabDetail: TabDetailVM
    @EnvironmentObject var station: Station
    
    @StateObject var viewModel = StatisticsVM()
    
    @AppStorage("statisticsPerX") var perXStatistics = PerRange.perWeek
    @AppStorage("statisitcsDistribution") var statsDistribution = ShowStatsDistribution.sessions
    
    @State var refresh: Bool = false
    @State var animate: Bool = false
    @State var showDateSelection: Bool = false
    @State var showPerXSheet: Bool = false
    
    @State var showDistributionPerX: Bool = false
    
    var body: some View {
        ZStack{
            VStack(spacing: 5){
                athleteDetailHeaderButtons
                
                attendancePanel
                
                listRanking
                
                DistributionPanelStatistics(viewModel: viewModel, showXAttendedPicker: $showDistributionPerX, refresh: $refresh, animate: $animate, showDistribution: $statsDistribution)
                
                Spacer()
            }
            
            .background(Color.appBackground)
            .navigationBarHidden(true)
            
            implementSelectKWSheet
            implemetPerXSheet
            implementDistributionSheet
            
        }
        
    }
    
// - MARK: Functions
    
    func getRanking(index: Int, value: Float) -> String {
        
        let dict = viewModel.athletesWithSessions.sorted{ $0.1 > $1.1 }
        let enumerated = Array(zip(dict.indices, dict))
        
        var ranking: String = "\(index + 1)."
        var number = 0
        
        if index != 0 {
            while index >= number && enumerated[index - number].1.1 == value {
                ranking = "\(index + 1 - number)."
                number += 1
            }
           /* repeat {
                for count in 1...
                {
                   
                    ranking = "\(index + 1 - count)."
                
                }} while enumerated[index + 2 - number].1.1 == value*/
        } else {
            ranking = "1."
        }
        number = 0
        return ranking
        
    }
    
    
// - MARK: UI Variables
    
    var athleteDetailHeaderButtons: some View {
    
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
                
        Text("Statistics")
            .font(.title)
            .foregroundColor(.header)
            .fontWeight(.medium)
                
        Spacer(minLength: 0)
        
        Button(action: {

        }){
            Image(systemName: "arrow.backward")
                .resizable()
                .foregroundColor(.clear)
                .frame(width: 27, height: 20)
        }

        
    }//HeaderHStackEnding
    .padding(.horizontal, 25)
    .padding(.top, 25)
}
    
    var attendancePanel: some View {
        HStack{
      
            VStack(alignment: .leading, spacing: 2){
                Text("Attendances")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.header)
                HStack(spacing: 4){
                    if perXStatistics == PerRange.total { Text("total") }
                    else if perXStatistics == PerRange.perMonth { Text("per Month") }
                    else if perXStatistics == PerRange.perWeek { Text("per Week") }
                    Image(systemName: "chevron.down")
                        .font(.system(size: 9))
                }
                .font(.caption2)
                .foregroundColor(.cardGrey2)
                
                .onTapGesture {
                    withAnimation {
                        showPerXSheet.toggle()
                    }
                }
            }
           // .padding()
            .padding(.leading)
            .background(Color.clear.disabled(refresh))
            .onReceive(station.$dateFilterStatistics, perform: {
                print("filter changed \($0)")
                viewModel.getAllModifiedSessions()
            })
            .onAppear(perform: {
                viewModel.fetchData()
                viewModel.getAthleteSessionsListContent()
                viewModel.getDistributionData()
                print(viewModel.attendedDistribution)
                self.tabDetail.showDetail = true })
            .onChange(of: animate, perform: { newValue in
                withAnimation {
                    viewModel.getAthleteSessionsListContent()
                    viewModel.getDistributionData()
                }
            })
            .onChange(of: perXStatistics, perform: { newValue in
                withAnimation {
                    viewModel.getAthleteSessionsListContent()
                }
            })
           
            Text("20")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.clear)
                .padding()
                .padding(.leading)

            
            Spacer()
            
            KWButton
                .animation(.easeInOut, value: animate)
            //put kw button here
        }
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
        .padding(.horizontal)
        .padding(.top, 15)
        
    }
    
    var KWButton: some View {
       
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
                    if station.dateFilterStatistics.date1.extractWeek() == station.dateFilterStatistics.date2.extractWeek() {
                        Text("    KW " + "\(station.dateFilterStatistics.date1.extractWeek())    ")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.header)
                            
                    } else {
                        Text("KW " + "\(station.dateFilterStatistics.date1.extractWeek())" + " - " + "\(station.dateFilterStatistics.date2.extractWeek())")
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
                    showDateSelection.toggle()
                }
            }
            .padding(.horizontal, 6)
    }

    var listRanking: some View {
        ScrollView(showsIndicators: false){
            LazyVStack{
                let dict = viewModel.athletesWithSessions.sorted{ $0.1 > $1.1 }
                let enumerated = Array(zip(dict.indices, dict))
             
                ForEach(enumerated, id: \.0) { index, value in
                    
                    HStack{
                        Text(
                            getRanking(index: index, value: value.1)
                            )
                            .foregroundColor(.mainText)
                            .font(.body)
                            .fontWeight(.medium)
                        
                        ProfilePictureStatsView(athlete: value.0)
                        
                        Text("\(value.0.firstName)")
                            .foregroundColor(.mainText)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(value.1.clean)")
                            .foregroundColor(.mainText)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.vertical, 3)
                    if index != enumerated.count - 1 {
                        Seperator(color: Color.appBackground)
                    }
                }
            }
         
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.accentMidGround))
            .padding(.horizontal)
        }
        .frame(height: 240)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.accentMidGround))
        .padding(.horizontal)
    }
    
 
    
    
    
    var implementSelectKWSheet: some View {
        VStack{
            Spacer()
            
            ActionSheetSelectKW(showActionSheet: $showDateSelection, refresh: $refresh, animate: $animate, datesVM: DatesVM(), kw1: station.dateFilterStatistics.date1, kw2: station.dateFilterStatistics.date2, type: ActionSheetCall.statistics).offset(y: self.showDateSelection ? 0 : UIScreen.main.bounds.height)

        }.background((showDateSelection ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
            withAnimation {
                showDateSelection.toggle()
            }
        }))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var implemetPerXSheet: some View {
        VStack{
            Spacer()
            PerXAttendanceActionSheet(showActionSheet: $showPerXSheet, animate: $animate, type: ActionSheetCall.statistics, perX: $perXStatistics)
             .offset(y: self.showPerXSheet ? 0 : UIScreen.main.bounds.height)

        }.background((showPerXSheet ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
            withAnimation {
                showPerXSheet.toggle()
            }
        }))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var implementDistributionSheet: some View {
        VStack{
            Spacer()
            StatsDistributionActionSheet(showActionSheet: $showDistributionPerX, animate: $animate, userDefault: $statsDistribution)
             .offset(y: self.showDistributionPerX ? 0 : UIScreen.main.bounds.height)

        }.background((showDistributionPerX ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
            withAnimation {
                showDistributionPerX.toggle()
            }
        }))
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct ProfilePictureStatsView: View {
    
    @Environment(\.colorScheme) var colorScheme

    let athlete: Athlete
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                //.foregroundColor(.sheetButton)
                .padding(.horizontal, 10)
            Text(getInitials(firstName: athlete.firstName, lastName: athlete.lastName))
                .font(.system(size: 13))
                .fontWeight(.semibold)
                .foregroundColor(.cardProfileLetter)
        }
    }
    
    func getInitials(firstName: String, lastName: String) -> String {
        let firstLetter = firstName.first?.uppercased() ?? ""
        let lastLetter = lastName.first?.uppercased() ?? ""
        return firstLetter + lastLetter
    }
}

struct DistributionPanelStatistics: View {
    @Environment(\.colorScheme) var colorScheme                     //DarkMode
    
    @ObservedObject var viewModel: StatisticsVM
    @Binding var showXAttendedPicker: Bool
    @Binding var refresh: Bool
    @Binding var animate: Bool
    @Binding var showDistribution:  ShowStatsDistribution
    @EnvironmentObject var station: Station
    
    
    var weekDays = [("Mo", 1),("Tu", 2), ("We", 3), ("Th", 4), ("Fr", 5), ("Sa", 6), ("Su", 0)]
    
    var distributionCount: [Int] {
        var sessionsCount: [Int] = []
        (viewModel.distributionSessions).forEach { sessions in
            let count = sessions.count
            sessionsCount.append(count)
        }
        return sessionsCount
    }
    
    var barHeights: [Float] {
        return viewModel.sessionBarHeights
    }
    
    var body: some View {
        VStack(spacing: 2){
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 2){
                    Text("Distribution")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.header)
                    HStack(spacing: 4){
                        if showDistribution == .sessions { Text("of Sessions") }
                        else if showDistribution == .attendanceCount { Text("# attended") }
                        else if showDistribution == .attendancePercent { Text("% attended") }
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9))
                    }
                    .font(.caption2)
                    .foregroundColor(.cardGrey2)
                    .onTapGesture {
                        withAnimation {
                            showXAttendedPicker.toggle()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 4)
                .background(Color.clear.disabled(refresh))
                .onAppear{
                    viewModel.getDistributionData()
                }
                
                
                Spacer()
                HStack{
                    if showDistribution == .sessions {
                        Text("\(viewModel.modifiedSessions.count)")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.header)
                            .padding()
                    } else if showDistribution == .attendanceCount {
                        Text("\(viewModel.averageAttendedDistributionNumber.clean)")
                       // Text("1.3")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.header)
                            .padding()
                    }
                    
                    /*else if station.xAttendedDistribution == .attendedPercent {
                        if viewModel.modifiedAllSessions.count > 0 {
                        Text(calculateAttendedPercantage(
                        attended: viewModel.modifiedArrayOfSessions.count,
                        all: viewModel.modifiedAllSessions.count) + "%")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.header)
                        .padding()
                        } */else {
                            Text("-")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(.header)
                                .padding()
                        }
                }
            }
            .animation(.easeInOut, value: animate)
            
            
            // }
            
            HStack(alignment: .bottom){
                
                ForEach(weekDays, id: \.1) { day, index in
                    HStack{
                        Spacer()
                        ZStack(alignment: .bottom){
                            VStack(spacing: 2){
                                
                                if viewModel.modifiedSessions.isEmpty {
                                    
                                    ZStack(alignment: .bottom){
                                        VStack(spacing: 2){
                                            Text("0")
                                                .font(.caption2)
                                                .foregroundColor(.clear)
                                            
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 34, height: 100)
                                                .foregroundColor(.clear)
                                                .padding(.bottom, 6)
                                        }
                                        
                                        
                                        VStack(spacing: 2){
                                            if showDistribution == .sessions {
                                                Text("0")
                                                    .font(.caption2)
                                                    .foregroundColor(.cardBarText) }
                                            else {
                                                    Text("0")
                                                        .font(.caption2)
                                                        .foregroundColor(.clear)
                                                }
                                            
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 34, height: 1)
                                                .foregroundColor(.cardBar)
                                                .padding(.bottom, 6)
                                        }
                                    }
                                    
                                } else {
                                    VStack(spacing: 2){
                                        if showDistribution == .sessions  {
                                            Text("\(viewModel.distributionSessions[index].count)")
                                                .font(.caption2)
                                                .foregroundColor(viewModel.distributionSessions[index].count == 0 ? .cardBarText.opacity(0.2) : .cardBarText)
                                        } else {
                                            Text("0")
                                                .font(.caption2)
                                                .foregroundColor(.clear)
                                        }
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: 34, height: showDistribution == .sessions ? CGFloat(viewModel.sessionBarHeights[index]) : //showDistribution == .attendanceCount ?
                                                   CGFloat(viewModel.sessionAttendeddBarHeights[index]) )
                                            .foregroundColor(.cardBar)
                                            .padding(.bottom, 6)
                                    }
                                    
                                }
                                Text(day)
                                    .font(.footnote)
                                    .foregroundColor(.cardGrey2)
                                    .padding(.bottom)
                            }
                            .animation(.easeInOut, value: animate)
                            
                            VStack(spacing: 2){
                                
                                if viewModel.modifiedSessions.isEmpty {
                                    
                                    ZStack(alignment: .bottom){
                                        VStack(spacing: 2){
                                            Text("0")
                                                .font(.caption2)
                                                .foregroundColor(.clear)
                                            
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 34, height: 100)
                                                .foregroundColor(.clear)
                                                .padding(.bottom, 6)
                                        }
                                        VStack(spacing: 2){
                                            if showDistribution == .sessions || showDistribution == .attendanceCount{
                                                Text("0")
                                                    .font(.caption2)
                                                    .foregroundColor(.header)
                                            }
                                            else if showDistribution == .attendancePercent {
                                                Text("-%")
                                                    .font(.caption2)
                                                    .foregroundColor(.header)
                                            }
                                            
                                            
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 34, height: 1)
                                                .foregroundColor(colorScheme == .light ? .accentBigButton : .appBackground)
                                                .padding(.bottom, 6)
                                        }
                                    }
                                    
                                } else {
                                    VStack(spacing: 2){
                                        if showDistribution == .sessions {
                                            Text("\(viewModel.distributionSessions[index].count)")
                                                .font(.caption2)
                                                .foregroundColor(viewModel.distributionSessions[index].count == 0 ? .header.opacity(0.2) : .header)
                                        } else if showDistribution == .attendanceCount {
                                            Text("\((viewModel.attendedDistribution[index].0 / viewModel.attendedDistribution[index].1).clean)")
                                                .font(.caption2)
                                                .foregroundColor(viewModel.attendedDistribution[index].0 == 0.0 ? .header.opacity(0.2) : .header)
                                        }
                                        else if station.xAttendedDistribution == .attendedPercent {
                                            if viewModel.distributionSessions[index].count > 0 {
                                                Text(calculateAttendedPercantage(
                                                    attended: viewModel.distributionSessions[index].count,
                                                    all: viewModel.distributionSessions[index].count) + "%")
                                                .font(.caption2)
                                                .foregroundColor(viewModel.distributionSessions[index].count == 0 ? .header.opacity(0.2) : .header)
                                                
                                            } else {
                                                Text("-%")
                                                    .font(.caption2)
                                                    .foregroundColor(viewModel.distributionSessions[index].count == 0 ? .header.opacity(0.2) : .header)
                                            }
                                        }
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: 34, height: showDistribution == .sessions ? CGFloat(viewModel.sessionBarHeights[index]) :
                                                   CGFloat(viewModel.sessionAttendeddBarHeights[index]))
                                            .foregroundColor(colorScheme == .light ? .accentBigButton : .appBackground)
                                            .padding(.bottom, 6)
                                    }
                                    
                                }
                                Text(day)
                                    .font(.footnote)
                                    .foregroundColor(.cardGrey2)
                                    .padding(.bottom)
                            }
                            .animation(.easeInOut, value: animate)
                        }
                        Spacer()
                    }
                    
                }
            }
            .padding(.horizontal, 2)
            
            
        }
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
        .padding()
        .padding(.top, 6)
    }
    
    func calculateAttendedPercantage(attended: Int, all: Int) -> String {
        
        return String(round(Float(attended) / Float(all) * 100).clean)
    }
    
   /* func getAverageAttendedNumber() -> Float {
        var arrayHolder = [Float]()
        for index in 0...6 {
            arrayHolder.append(viewModel.attendedDistribution[index].0 / viewModel.attendedDistribution[index].1)
        }
        return arrayHolder.reduce(0, +) / 7.0
    }*/
}



struct StatsDistributionActionSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var showActionSheet: Bool
    @Binding var animate: Bool
    @Binding var userDefault: ShowStatsDistribution
    
    @State var attendedSessions: Bool = false
    @State var attendedNumber: Bool = false
    @State var attendedPercantage: Bool = false
       

   // @EnvironmentObject var station: Station

    
    init(showActionSheet: Binding<Bool>, animate: Binding<Bool>, userDefault: Binding<ShowStatsDistribution>){
        self._showActionSheet = showActionSheet
        self._animate = animate
        self._userDefault = userDefault
        if self.userDefault == ShowStatsDistribution.attendanceCount {
            self._attendedNumber = State(wrappedValue: true)
        } else if self.userDefault == ShowStatsDistribution.attendancePercent  {
            self._attendedPercantage = State(wrappedValue: true)
        } else if self.userDefault == ShowStatsDistribution.sessions  {
            self._attendedSessions = State(wrappedValue: true)
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
                
                Text("Show")
                    .fontWeight(.semibold)
                    .font(.title3)
                    .foregroundColor(.midTitle)
                
                Spacer()
                
                //Apply button
                Button {
                    withAnimation {
                        showActionSheet.toggle()
                    }
                    //do all the UserDefaults stuff
                    if attendedNumber == true {
                        userDefault = ShowStatsDistribution.attendanceCount
                    } else if attendedPercantage == true {
                        userDefault = ShowStatsDistribution.attendancePercent
                    } else if attendedSessions == true {
                        userDefault = ShowStatsDistribution.sessions
                    }
                    animate.toggle()
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
                    attendedSessions = true
                    attendedNumber = false
                    attendedPercantage = false
                } label: {
                    
                    Text("Sessions")
                        .fontWeight(.semibold)
                        .foregroundColor(.midTitle)
                        .padding(.vertical, 12)
                        .opacity(attendedSessions ? 1.0 : 0.3)
                }
                
                Button {
                    attendedSessions = false
                    attendedNumber = true
                    attendedPercantage = false
                } label: {
                    
                    Text("Avg. # attended")
                        .fontWeight(.semibold)
                        .foregroundColor(.midTitle)
                        .padding(.vertical, 12)
                        .opacity(attendedNumber ? 1.0 : 0.3)
                    
                }
                
                Button {
                    attendedSessions = false
                    attendedNumber = false
                    attendedPercantage = true
                } label: {
                    Text("% attended")
                        .fontWeight(.semibold)
                        .foregroundColor(.midTitle)
                        .padding(.vertical, 12)
                        .opacity(attendedPercantage ? 1.0 : 0.3)
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




/*struct StatisticsView_Previews: PreviewProvider {
  
    static var previews: some View {
        StatisticsView()
    }
}
*/
