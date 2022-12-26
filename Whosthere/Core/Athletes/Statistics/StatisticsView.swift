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
    
    @State var refresh: Bool = false
    @State var animate: Bool = false
    @State var showDateSelection: Bool = false
    @State var showPerXSheet: Bool = false
    
    
    var body: some View {
        ZStack{
            VStack{
                athleteDetailHeaderButtons
                
                attendancePanel
                
                listRanking
                
                Spacer()
            }
            
            .background(Color.appBackground)
            .navigationBarHidden(true)
            
            implementSelectKWSheet
            implemetPerXSheet
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
                self.tabDetail.showDetail = true })
            .onChange(of: animate, perform: { newValue in
                withAnimation {
                    viewModel.getAthleteSessionsListContent()
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
        .padding(.top, 10)
        
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
                        
                        ProfilePictureStatsView(athlete: value.1)
                        
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
        .frame(height: 225)
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
}


struct ProfilePictureStatsView: View {
    
    @Environment(\.colorScheme) var colorScheme

    let athlete: Athlete
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 35, height: 35)
                .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                //.foregroundColor(.sheetButton)
                .padding(.horizontal, 10)
            Text(getInitials(firstName: athlete.firstName, lastName: athlete.lastName))
                .font(.system(size: 14))
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
/*struct StatisticsView_Previews: PreviewProvider {
  
    static var previews: some View {
        StatisticsView()
    }
}
*/
