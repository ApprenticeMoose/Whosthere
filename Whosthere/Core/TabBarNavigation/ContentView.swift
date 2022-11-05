//
//  ContentView.swift
//  Whosthere
//
//  Created by Moose on 05.08.22.
//
import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .sessions
//    @Environment(\.managedObjectContext) var viewContext
//    @EnvironmentObject var athletesListVM: AthletesListViewModel
    @EnvironmentObject var tabDetail: TabDetailVM
    @State var showActionSheet: Bool = false
    @State var duplicationLabelOpacityActionSheet: Double = 0.0
  

    var body: some View {
        ZStack(alignment: .bottom) {
            
                switch selectedTab {
                case .sessions:
                    SessionsHomeView(datesVM: DatesVM(), showActionSheet: $showActionSheet)
                case .statistics:
                    StatisticsOverview()
                case .athletes:
                    AthleteListView()
                case .settings:
                    SettingsOverView()
                }
            

                TabBar()
                    .offset(y: _tabDetail.wrappedValue.showDetail ? 200 : 62)
                    
            VStack{
                Spacer()
                duplicationSuccessLabel
                    //.offset(y: 50)
                ActionSheetDuplicateDeleteSesssion(session: tabDetail.sessionForSheet, showActionSheet: $showActionSheet, sessionHomeVM: SessionHomeVM(), datesVM: DatesVM(), duplicationLabelOpacityActionSheet: $duplicationLabelOpacityActionSheet).offset(y: self.showActionSheet ? 0 : UIScreen.main.bounds.height)

            }.background((showActionSheet ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
                //tabDetail.showDetail.toggle()
                withAnimation {
                    showActionSheet.toggle()
                }
            }))
            .edgesIgnoringSafeArea(.bottom)
            
            
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Color.clear.frame(height: 44)
        }
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
                    .opacity(duplicationLabelOpacityActionSheet)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
