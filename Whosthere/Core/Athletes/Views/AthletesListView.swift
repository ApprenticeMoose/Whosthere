//
//  AthletesListView.swift
//  Photopickertest
//
//  Created by Moose on 04.12.21.
//

import SwiftUI
import NavigationBackport

enum Route: Hashable {
    case detail(AthleteViewModel)
    case edit(AthleteViewModel)
    //case test(AthleteViewModel)
}
class AppState: ObservableObject {
    @Published var path = NBNavigationPath()
}


struct AthletesListView: View {
    
    //MARK: -Properties
    
    @Environment(\.colorScheme) var colorScheme                             //DarkMode
    
    @State private var refreshID = UUID()                                   //For manually refreshing the list after update
    @State private var showAddSheet: Bool = false                           //Bool for AddSheet
    
    
    @EnvironmentObject var appState: AppState                               //For Navigation
    @Environment(\.managedObjectContext) var viewContext                    //Core Data moc
    @ObservedObject private var athletesListVM: AthletesListViewModel       //Accessing the athletes
    @EnvironmentObject var tabDetail: TabDetailVM                           //For hiding tabbar
    
    //MARK: -Body
    
    var body: some View {
        NBNavigationStack(path: $appState.path){                            //NavigationStack
//        ZStack{
//            Color.accentGreen.edgesIgnoringSafeArea(.all)                   //GreenAccentHeader
        
//            VStack{
                                                                            //Header
               
                
                
                                                                            //Screen body
                VStack{
                    
                    HStack{
                        ScreenHeaderTextOnly(screenTitle: "Athletes")
                        athleteListButtonRow
                            .fullScreenCover(isPresented: $showAddSheet,
                                             content: {AddAthleteView(vm: AddAthleteViewModel(context: viewContext))})
                        
                    }

                                                                            //Shows picture when list is empty
                    if athletesListVM.athletes.isEmpty {

                        emptyListPicture
                                                                            //Shows List if it has componenets
                    } else {
                                                                            //AthletesList
//                        List(athletesListVM.athletes) { athlete in
//                            NBNavigationLink(value: Route.detail(athlete), label: {RowView(athlete: athlete)})
//                        }
//                        .listRowBackground(Color.mainCard)
//                        .id(refreshID)
                        
                        ScrollView(showsIndicators: false){
                            LazyVStack{
                                let enumerated = Array(zip(athletesListVM.athletes.indices, athletesListVM.athletes))
                                ForEach(enumerated, id: \.1) { index, athlete in
                                
                            
                                    NBNavigationLink(value: Route.detail(athlete), label: {RowView(athlete: athlete)})
                                  
                                    if index != enumerated.count - 1 {
                                        Seperator()
                                    }

                                    
                                         
                                    
                                    
                                    
                                
                            }
                            .id(refreshID)
                            }
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.accentMidGround))
                            .padding(.horizontal)
                        }
                        
                        .nbNavigationDestination(for: Route.self) { route in
                                    switch route {
                                    case let .detail(athlete):
                                        AthleteDetailView(athlete: athlete)
                                            .environmentObject(AthletesListViewModel(context: viewContext))
                                            .onAppear(perform:
                                                        //{withAnimation(.spring())
                                                {self.tabDetail.showDetail = true}
                                            //}
                                            )
                                            .onDisappear(perform: {self.refreshID = UUID()})
                                    case let .edit(athlete):
                                        EditAthleteView(athlete: athlete
                                                        , context: viewContext
                                                        , goBackToRoot: { appState.path.removeLast(appState.path.count)})
                                      
                                    }
                                }
                        
                        }//else
                    Spacer(minLength: 60)
                    //Spacer to define the body-sheets size:
                    //Spacer().frame(maxWidth: .infinity)
                    //Spacer().frame(maxHeight: .infinity)
                }
                .background(Color.appBackground
                    .edgesIgnoringSafeArea(.all))
                
                
//            }//VStack to seperate header and bodysheet
//        }//ZStack for background
        .navigationBarTitle("My Title")
        .navigationBarHidden(true)
        
        }//NavigationStack
    }//Body

    
    //MARK: -Functions
    

    
    //MARK: -Outsourced Components
    
    var emptyListPicture: some View {
    
    VStack{
        Spacer()
        
        Image("Seeding")
            .resizable()
            .frame(height: 230)
            .frame(width: 230)
            .padding()
            .padding(.bottom, 15)
            
        
        Text("Start growing your team")
           // .padding(.bottom, 10)
        
        Button {
            showAddSheet = true
        } label: {
            MediumButton(icon: "plus",
                            description: "Add athlete now",
                            textColor: .textColor,
                         backgroundColor: .middlegroundColor);
        }
    }
}
        

    
    private var athleteListButtonRow: some View {
    
    HStack{
 
        Button(action: {
            //Make Sort Sheet Appear
        }){
            Image(systemName: "slider.horizontal.3")
                .resizable()
                .frame(width: 24, height: 22)
                .foregroundColor(Color.header)
                .padding(.horizontal, 14)
        }
        
        // Add Athlete Button
        Button(action: {
            showAddSheet.toggle()
        }){
            Image(systemName: "plus")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.header)
        }
        
    }//HStackButtonsEnd
    .padding(.horizontal, 22)
    .padding(.top, 20)
}
    
    //initializer for adjusting List View to look as intended
    init(vm: AthletesListViewModel) {
        UITableView.appearance().backgroundColor = .clear
//    UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().tableHeaderView = .init(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))

    self.athletesListVM = vm
    }
    
}//Struct




        //MARK: Subviews

    struct ListRowView: View {
        
        @Environment(\.colorScheme) var colorScheme
        
        //changes may be needed
        let athlete: AthleteViewModel
        
        var body: some View {
            VStack{
            HStack {
                emptyProfilePicture
                
                Text(athlete.firstName)
                    .foregroundColor(.mainText)
                    .font(.title3)
                Spacer()
            }
            .padding(.bottom, 4)
             
            }
            .padding(.top, 5)
            .background(
                Color.accentMidGround
            )
            
        }
        
        
        
        var emptyProfilePicture: some View {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                    //.foregroundColor(.sheetButton)
                    .padding(.horizontal, 10)
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    //.foregroundColor(colorScheme == .light ? .greyTwoColor : .greyOneColor)
                    .foregroundColor(colorScheme == .light ? .cardGrey2 : .cardProfileLetter)
            }
        }
    }

struct ScreenHeaderTextOnly: View {
    
    let screenTitle: String
    
    var body: some View {
        
        HStack{
            
//            Spacer(minLength: 0)
            
            Text(screenTitle)
                .font(.largeTitle)
                .foregroundColor(.header)
                .fontWeight(.semibold)
            
            Spacer(minLength: 0)
            
        }
        .padding(.horizontal, 22)
        .padding(.top, 20)
    }
}

struct RowView: View {
    //so the detail view can observe the model and can update immediately
    @ObservedObject var athlete: AthleteViewModel

    var body: some View {
        ListRowView(athlete: athlete)
//                .listRowInsets(.init(top: 10, leading: 5, bottom: 10, trailing: 10))
//                .listRowBackground(Color.mainCard)
    }

}


struct Seperator: View {
    var isLast: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        HStack{
            Rectangle().fill(Color.appBackground).frame(width: UIScreen.main.bounds.width, height: 1)
                .padding(.horizontal, 10)
            Spacer()
        }
        .padding(.top, 0)
    }
    
}
