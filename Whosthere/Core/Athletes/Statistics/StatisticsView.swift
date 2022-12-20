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
    
    @ObservedObject var viewModel: AthleteListVM
    
    var body: some View {
        VStack{
            AthleteDetailHeaderButtons
            
            ForEach(viewModel.athletes, id: \.self) {athlete in
                Text(athlete.firstName)
            }
            Spacer()
        }
        .onAppear(perform: {
            self.tabDetail.showDetail = true })
        .background(Color.appBackground)
        .navigationBarHidden(true)
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
}

/*struct StatisticsView_Previews: PreviewProvider {
  
    static var previews: some View {
        StatisticsView()
    }
}
*/
