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
    
    @AppStorage("statisticsPerX") var perXStatistics = StatisticsPerX.perWeek
    
    @State var refresh: Bool = false
    @State var animate: Bool = false
    @State var showDateSelection: Bool = false
    @State var showPerXSheet: Bool = false
    
    
    var body: some View {
        ZStack{
            VStack{
                athleteDetailHeaderButtons
                
                attendancePanel
                
                ScrollView{
                    VStack{
                        ForEach(viewModel.modifiedSessions, id: \.self) { session in
                            Text("\(session.id)")
                        }
                    }
                }
                
                Spacer()
            }
            .onAppear(perform: {
                viewModel.fetchData()
                self.tabDetail.showDetail = true })
            .background(Color.appBackground)
            .navigationBarHidden(true)
            
            implementSelectKWSheet
        }
    }
    
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
                    if perXStatistics == StatisticsPerX.total { Text("total") }
                    else if perXStatistics == StatisticsPerX.perMonth { Text("per Month") }
                    else if perXStatistics == StatisticsPerX.perWeek { Text("per Week") }
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
           
            Text("20")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.clear)
                .padding()
                .padding(.leading)

            
            Spacer()
            
            KWButton
            //put kw button here
        }
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
        .padding(.horizontal)
        .padding(.top, 10)
        .animation(.easeInOut, value: animate)
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
}

/*struct StatisticsView_Previews: PreviewProvider {
  
    static var previews: some View {
        StatisticsView()
    }
}
*/
