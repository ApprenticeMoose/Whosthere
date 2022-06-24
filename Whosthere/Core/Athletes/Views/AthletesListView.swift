//
//  AthletesListView.swift
//  Photopickertest
//
//  Created by Moose on 04.12.21.
//

import SwiftUI

struct AthletesListView: View {
    
    //MARK: -Properties
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var vm: AthletesViewModel
    
    @State private var selectedAthlete: AthletesModel? = nil
    @State private var showDetailView: Bool = false
    @State private var showAddSheet: Bool = false
    
    
    
    //MARK: -Body
    
    var body: some View {
        
        ZStack{
            Color.accentColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                //Header
                ScreenHeaderTextOnly(screenTitle: "Athletes")
                   
                
                //Screen body
                VStack(spacing: 0) {
                    
                    athleteListButtonRow
                        .fullScreenCover(isPresented: $showAddSheet,
                                         content: {AddAthleteView(addVM: AddAthleteViewModel())})
                        
                    
//Shows picture when list is empty
                    if vm.allAthletes.isEmpty {
                        
                        emptyListPicture
                        
//Shows List if it has componenets
                    } else {
                        
                    athletesList
                        
                    }
                    //Spacer to define the body-sheets size:
                    Spacer().frame(maxWidth: .infinity)
                }
                .background(Color.backgroundColor
                                .clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 20))
                                .edgesIgnoringSafeArea(.bottom))
                
                
            }//VStack to seperate header and bodysheet
        }//ZStack for background
        .navigationBarTitle("My Title")
        .navigationBarHidden(true)
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
            .padding(.bottom, 15)
        
        NavigationLink(
            destination: AddAthleteView(addVM: AddAthleteViewModel()),
            label: {
                MediumButton(icon: "plus",
                                description: "Add athlete now",
                                textColor: .textColor,
                                backgroundColor: .middlegroundColor)})
        
        Spacer()
        Spacer()
    }
}
    
    var athletesList: some View {
    
        List(vm.allAthletes) { athlete in
        //ForEach(vm.allAthletes) { athlete in
            NavigationLink(destination: AthleteDetailView(athlete: athlete, showDetailView: $showDetailView)) {
                RowView(athlete: athlete)
                    
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .listRowBackground(Color.middlegroundColor)
//                        .onTapGesture {
//                            segue(athlete: athlete) //->
//                        }
                        //.listRowSeperator(.hidden)->need update
                }
    .listStyle(InsetGroupedListStyle())
    
}
    
    private var athleteListButtonRow: some View {
    
    HStack{
        //Change AthletesListViewButton
        Button(action: {
            //Change List Appearance
        }){
            FrameButton(iconName: "HamburgerListIcon", iconColor: .textColor)
        }
        
        Spacer()
        
        //Sort Button
        Button(action: {
            //Make Sort Sheet Appear
        }){
            FrameButton(iconName: "SortIcon", iconColor: .textColor)
                .padding(.horizontal, 8)
        }
        
        // Add Athlete Button
        Button(action: {
            showAddSheet.toggle()
        }){
            FrameButton(iconName: "AddAthleteIcon", iconColor: .textColor)
        }
        
    }//HStackButtonsEnd
    .padding(.horizontal, 22)
    .padding(.vertical, 20)
}
    
    //initializer for adjusting List View to look as intended
    init() {
    UITableView.appearance().backgroundColor = .clear
    UITableViewCell.appearance().backgroundColor = .clear
    UITableView.appearance().tableHeaderView = .init(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
    }
    
}//Struct


    //MARK: -Preview

    struct AthletesListView_Previews: PreviewProvider {
        static var previews: some View {
            AthletesListView()
                .navigationBarHidden(true)
                .environmentObject(dev.athletesVM)
        }
}

    //MARK: Subviews

struct ListRowView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    //changes may be needed
    let athlete: AthletesModel
    
    var body: some View {
        HStack {
            emptyProfilePicture
            
            Text(athlete.firstName)
                .font(.title3)
            Spacer()
        }
        .padding(.vertical, 5)
        .background(
            Color.white.opacity(0.001)
        )
        
    }
    
    
    
    var emptyProfilePicture: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(colorScheme == .light ? .greyFourColor : .greyTwoColor)
                .padding(.horizontal, 10)
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(colorScheme == .light ? .greyTwoColor : .greyOneColor)
        }
    }
}

struct ScreenHeaderTextOnly: View {
    
    let screenTitle: String
    
    var body: some View {
        
        HStack{
            
            Spacer(minLength: 0)
            
            Text(screenTitle)
                .font(.title)
                .foregroundColor(.textUnchangedColor)
                .fontWeight(.medium)
            
            Spacer(minLength: 0)
            
        }
        .padding()
    }
}

struct RowView: View {
    //so the detail view can observe the model and can update immediately
    @ObservedObject var athlete: AthletesModel
    
    var body: some View {
        ListRowView(athlete: athlete)
                .listRowInsets(.init(top: 10, leading: 5, bottom: 10, trailing: 10))
                .listRowBackground(Color.middlegroundColor)
    }
    
}
