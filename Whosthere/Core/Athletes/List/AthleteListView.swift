//
//  AthletesListView.swift
//  Photopickertest
//
//  Created by Moose on 04.12.21.
//
import SwiftUI
import NavigationBackport

enum Route: Hashable {
    case detail(Athlete)
    case edit(Athlete)
    case editSession(Session)
    //case test(AthleteViewModel)
}
class AppState: ObservableObject {
    @Published var path = NBNavigationPath()
}


struct AthleteListView: View {
    
    //MARK: -Properties
    
    @Environment(\.colorScheme) var colorScheme                             //DarkMode
    
    //@State private var refreshID = UUID()                                 //For manually refreshing the list after update
    @State private var showAddSheet: Bool = false                           //Bool for AddSheet
    
    @EnvironmentObject var tabDetail: TabDetailVM
    @EnvironmentObject var appState: AppState                               //For Navigation
    
    @ObservedObject var datesVM: DatesVM
    @StateObject var athletesListVM = AthleteListVM()                       //Accessing the athletes
    //MARK: -Body
    
    var body: some View {
        NBNavigationStack(path: $appState.path){                            //NavigationStack
                VStack{
                    
                    HStack{
                        ScreenHeaderTextOnly(screenTitle: "Athletes")
                        athleteListButtonRow
                            .fullScreenCover(isPresented: $showAddSheet,
                                             //content: {AddAthleteView(athlete: nil, vm: AddAthleteViewModel(context: viewContext))})
                                             content: {AddAthleteView()})
                        
                    }

//Shows picture when list is empty
                    if athletesListVM.athletes.isEmpty {

                        emptyListPicture
                        
                    } else {
//AthletesList
                        ScrollView(showsIndicators: false){
                            LazyVStack{
                                let enumerated = Array(zip(athletesListVM.athletes.indices, athletesListVM.athletes))
                                ForEach(enumerated, id: \.1) {index, athlete in
                                
                            
                                    NBNavigationLink(value: Route.detail(athlete), label: {RowView(athlete: athlete)})
                                  
                                    if index != enumerated.count - 1 {
                                        Seperator()
                                    }
                            }
                            //.id(refreshID)
                            }
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.accentMidGround))
                            .padding(.horizontal)
                        }
                        .onAppear{
                            //withAnimation {
                                athletesListVM.fetchAthletes()
                            //}
                            }
                        
                        .nbNavigationDestination(for: Route.self) { route in
                                    switch route {
                                    case let .detail(athlete):
                                        AthleteDetailView(athlete: athlete)
                                            
                                    case let .edit(athlete):
                                        EditAthleteView(athlete: athlete,
                                                        goBackToRoot: { appState.path.removeLast(appState.path.count)})
                                      
                                    case let .editSession(session):
                                        EditSessionView(session: session, selectedDay: $datesVM.selectedDay, scrollToIndexOfSessions: $datesVM.scrollToIndexOfSessions)
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
            .fontWeight(.semibold)
           // .padding(.bottom, 10)
        
        Button {
            showAddSheet = true
        } label: {
            MediumButton(icon: "plus",
                            description: "Add athlete now",
                            textColor: .middlegroundColor,
                         backgroundColor: .textColor);
        }
        Spacer()
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
    init() {
        UITableView.appearance().backgroundColor = .clear
//    UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().tableHeaderView = .init(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        self.datesVM = DatesVM()
    }
    
}//Struct



        //MARK: Subviews
struct ListRowView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    //changes may be needed
    let athlete: Athlete
    
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
        Text(getInitials(firstName: athlete.firstName, lastName: athlete.lastName))
            .font(.body)
            .fontWeight(.semibold)
            .foregroundColor(.cardProfileLetter)
//                Image(systemName: "person")
//                    .resizable()
//                    .frame(width: 20, height: 20, alignment: .center)
//                    //.foregroundColor(colorScheme == .light ? .greyTwoColor : .greyOneColor)
//                    .foregroundColor(.cardProfileLetter)
    }
}
    
    func getInitials(firstName: String, lastName: String) -> String {
        let firstLetter = firstName.first?.uppercased() ?? ""
        let lastLetter = lastName.first?.uppercased() ?? ""
        return firstLetter + lastLetter
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
    var athlete: Athlete

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
