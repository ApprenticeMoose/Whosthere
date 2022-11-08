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
    @State var showKWPicker2: Bool = false
    
    @ObservedObject var detailVM: AthleteDetailVM
    
    
    init(athlete: Athlete, dataManager: DataManager = DataManager.shared) {
        self.detailVM = AthleteDetailVM(athlete: athlete) ?? AthleteDetailVM(athlete2: athlete)
        print("Initializing Detail View for: \(String(describing: detailVM.detailedAthlete.firstName))")
        print("\(detailVM.station.dateFilterAttendance)")
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
                    Text(detailVM.selectedSessionAttendance.clean)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.headerText)
                        .padding()
                        .padding(.leading)
                        .onChange(of: detailVM.selectedSessionAttendance) { v in
                            print("Attendance changed")
                        }
                    
                    
                    
                    VStack(alignment: .leading, spacing: 2){
                        Text("Attendances")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.headerText)
                        HStack(spacing: 4){
                            if detailVM.station.perXAttendance == .total { Text("total") }
                            else if detailVM.station.perXAttendance == .perMonth { Text("per Month") }
                            else if detailVM.station.perXAttendance == .perWeek { Text("per Week") }
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
                    
                    
                    Spacer()
                    
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
                                    .foregroundColor(.headerText)
                            }
                        
                        HStack(alignment: .lastTextBaseline){
                            if detailVM.station.dateFilterAttendance.date1.extractWeek() == detailVM.station.dateFilterAttendance.date2.extractWeek() {
                                Text("    KW " + "\(detailVM.station.dateFilterAttendance.date1.extractWeek())    ")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.headerText)
                                    
                            } else {
                                Text("KW " + "\(detailVM.station.dateFilterAttendance.date1.extractWeek())" + " - " + "\(detailVM.station.dateFilterAttendance.date2.extractWeek())")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.headerText)
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
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
                .padding()
                
                 Spacer()
                Text("\(detailVM.station.dateFilterAttendance.date2)")
                 Spacer()
                
                }
            .onAppear(perform: { self.tabDetail.showDetail = true })
            .background(Color.appBackground)
            .navigationBarHidden(true)
            
            VStack{
                Spacer()
                
                ActionSheetSelectKWDetail(showActionSheet: $showKWPicker1, datesVM: DatesVM(), kw1: detailVM.station.dateFilterAttendance.date1, kw2: detailVM.station.dateFilterAttendance.date2).offset(y: self.showKWPicker1 ? 0 : UIScreen.main.bounds.height)

            }.background((showKWPicker1 ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
                //tabDetail.showDetail.toggle()
                withAnimation {
                    showKWPicker1.toggle()
                }
            }))
            .edgesIgnoringSafeArea(.bottom)
           
            VStack{
                Spacer()
                PerXAttendanceDetailActionSheet(showActionSheet: $showKWPicker2)
                 .offset(y: self.showKWPicker2 ? 0 : UIScreen.main.bounds.height)

            }.background((showKWPicker2 ? Color.black.opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
                //tabDetail.showDetail.toggle()
                withAnimation {
                    showKWPicker2.toggle()
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
}

