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
    case statistics
    //case test(AthleteViewModel)
}
class AppState: ObservableObject {
    @Published var path = NBNavigationPath()
}


struct AthleteListView: View {
    
    //MARK: -Properties
    
    @Environment(\.colorScheme) var colorScheme                             //DarkMode
    @AppStorage("listGrid") var list: Bool = false
    //@State private var refreshID = UUID()                                 //For manually refreshing the list after update
    @State private var showAddSheet: Bool = false                           //Bool for AddSheet
    @State private var showActionSheet: Bool = false
    @State var animate = false
    
    @EnvironmentObject var tabDetail: TabDetailVM
    @EnvironmentObject var appState: AppState                               //For Navigation
    
    @ObservedObject var datesVM: DatesVM
    @StateObject var athletesListVM = AthleteListVM()                       //Accessing the athletes
    
    //MARK: -Body
    
    var body: some View {
        NBNavigationStack(path: $appState.path){                            //NavigationStack
            ZStack{
                VStack{
                    
                    HStack{
                        ScreenHeaderTextOnly(screenTitle: "Athletes")
                        athleteListButtonRow
                            .fullScreenCover(isPresented: $showAddSheet,
                                             //content: {AddAthleteView(athlete: nil, vm: AddAthleteViewModel(context: viewContext))})
                                             content: {AddAthleteView()})
                        
                    }
                    
                    //Shows picture when list is empty
                    
                    NBNavigationLink(value: Route.statistics, label: {StatisticsButton(list: $list)})
                        .nbNavigationDestination(for: Route.self) { route in
                            switch route {
                            case let .detail(athlete):
                                AthleteDetailView(athlete: athlete)
                                
                            case let .edit(athlete):
                                EditAthleteView(athlete: athlete,
                                                goBackToRoot: { appState.path.removeLast(appState.path.count)})
                                
                            case let .editSession(session):
                                EditSessionView(session: session, selectedDay: $datesVM.selectedDay, scrollToIndexOfSessions: $datesVM.scrollToIndexOfSessions)
                            case .statistics:
                                StatisticsView(viewModel: athletesListVM)
                            }
                        }

                    
                    if athletesListVM.athletes.isEmpty {
                        
                        emptyListPicture
                        
                    } else if list == true {
                        AthletesList(athleteArray: athletesListVM.athletes)
                            .onAppear{
                                athletesListVM.fetchAthletes()
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
                                case .statistics:
                                    Text("statistics")
                                }
                            }
                    } else if list == false {
                        //AthletesList
                        
                        AthletesGrid(athleteArray: athletesListVM.athletes)
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
                                case .statistics:
                                    Text("statistics")
                                }
                            }
                        
                    }//else
                    Spacer(minLength: 60)
                    //Spacer to define the body-sheets size:
                    //Spacer().frame(maxWidth: .infinity)
                    //Spacer().frame(maxHeight: .infinity)
                }
               // .animation(.easeInOut, value: animate)
                .background(Color.appBackground
                    .edgesIgnoringSafeArea(.all))
                
                implementListGridSheet
            }
            

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
 
       /* Button(action: {
            //Make Sort Sheet Appear
            withAnimation{
                list.toggle()
            }
            
        }){
            if list == true {
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .frame(width: 22, height: 20)
                    .foregroundColor(Color.header)
                    .padding(.horizontal, 8)
            } else {
                Image(systemName: "circle.grid.2x2")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.header)
                    .padding(.horizontal, 8)
            }
        }*/
        
        Button(action: {
            //Make Sort Sheet Appear
            withAnimation{
                tabDetail.showDetail.toggle()
                showActionSheet.toggle()
            }
            
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
    
    var implementListGridSheet: some View {
        VStack{
            Spacer()
            ChangeListGridSheet(showActionSheet: $showActionSheet, list: $list, animate: $animate)
                .offset(y: self.showActionSheet ? 0 : UIScreen.main.bounds.height)

        }.background((showActionSheet ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
            withAnimation {
                tabDetail.showDetail.toggle()
                showActionSheet.toggle()
            }
        }))
        .edgesIgnoringSafeArea(.bottom)
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
                .font(.body)
            Spacer()
        }
        .padding(.bottom, 2)
         
        }
        .padding(.top, 3)
        .background(
            Color.accentMidGround
        )
        
    }
    
    var emptyProfilePicture: some View {
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

struct AthletesGrid: View {
    var athleteArray: [Athlete]
    let preference = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View{
        VStack {
                    LazyVGrid(columns: preference, spacing: 16) {
                        
                        let enumerated = Array(zip(athleteArray.indices, athleteArray))
                        
                        ForEach(enumerated, id: \.1) { index, athlete in
                            NBNavigationLink(value: Route.detail(athlete), label: {AthleteCircleButton(athlete: athlete)})
                           
                        }
                    }

                }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
        .padding(.bottom)
        .padding(.horizontal)
    }
}

struct AthleteCircleButton: View {
    let athlete: Athlete
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View{
        VStack{
            ZStack{
                Circle()
                    .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                    .frame(height: 40)
                Text(getInitials(firstName: athlete.firstName, lastName: athlete.lastName))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.cardProfileLetter)
            }

            Text("\(athlete.firstName)")
                .font(.caption)
                .foregroundColor(.midTitle)
        }
        .padding(.horizontal, 2)
    }
    
    func getInitials(firstName: String, lastName: String) -> String {
        let firstLetter = firstName.first?.uppercased() ?? ""
        let lastLetter = lastName.first?.uppercased() ?? ""
        return firstLetter + lastLetter
    }
}

struct AthletesList: View {
    var athleteArray: [Athlete]
    var body: some View{
        ScrollView(showsIndicators: false){
            LazyVStack{
                let enumerated = Array(zip(athleteArray.indices, athleteArray))
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
    }
}


struct ChangeListGridSheet: View {
    

     @Environment(\.colorScheme) var colorScheme
     @Binding var showActionSheet: Bool
     
     @State var listBool: Bool = false
     @State var gridBool: Bool = false
     
     @Binding var list: Bool
    
     @Binding var animate: Bool
     
    @EnvironmentObject var tabDetail: TabDetailVM

     
    init(showActionSheet: Binding<Bool>, list: Binding<Bool>, animate: Binding<Bool>){
        self._showActionSheet = showActionSheet
        self._list = list
        self._animate = animate
        if list.wrappedValue == true {
             self._listBool = State(wrappedValue: true)
        } else if list.wrappedValue == false {
             self._gridBool = State(wrappedValue: true)
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
                         tabDetail.showDetail.toggle()
                     }
                     //do all the UserDefaults stuff
                     if listBool == true {
                         list = true
                         //UserDefaults.standard.xAttendedDistibution = ShowAttended.attendedNumber
                     } else if listBool == false {
                         //UserDefaults.standard.xAttendedDistibution = ShowAttended.attendedPercent
                         list = false
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
                     listBool = true
                     gridBool = false
                 } label: {
                     
                     Text("List")
                         .fontWeight(.semibold)
                         .foregroundColor(.midTitle)
                         .padding(.vertical, 12)
                         .opacity(listBool ? 1.0 : 0.3)
                     
                 }
                 
                 Button {
                     listBool = false
                     gridBool = true
                 } label: {
                     Text("Grid")
                         .fontWeight(.semibold)
                         .foregroundColor(.midTitle)
                         .padding(.vertical, 12)
                         .opacity(gridBool ? 1.0 : 0.3)
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
         .frame(width: UIScreen.main.bounds.width)
         .edgesIgnoringSafeArea(.bottom)
         
     }
     
 }

struct StatisticsButton: View {
    
    @Binding var list: Bool
    
    var body: some View {
     
            HStack{
                Image(systemName: "chart.xyaxis.line")
                    .font(.title3)
                    .padding(.leading, list ? 4 : 16)
                
                Text("Statistics")
                    .font(.body)
                    .fontWeight(.medium)
                    .offset(y: 1)
                    .padding(.horizontal, 14)
                   
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .padding(.trailing, 4)
            }
            .foregroundColor(.midTitle)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.accentMidGround))
            .padding(.horizontal)
            .padding(.bottom, 10)
            .padding(.top, 2)
        
    }
}
    

