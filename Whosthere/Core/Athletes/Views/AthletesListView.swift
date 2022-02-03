//
//  AthletesListView.swift
//  Photopickertest
//
//  Created by Moose on 04.12.21.
//

import SwiftUI

struct AthletesListView: View {
    
    //MARK: Properties
    
    @EnvironmentObject private var vm: AthletesViewModel
    
    @State private var selectedAthlete: AthletesModel? = nil
    @State private var showDetailView: Bool = false
    
    
    //MARK: Body
    
    var body: some View {
        
        ZStack{
            Color.accentColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                //Header
                ScreenHeaderTextOnly(screenTitle: "Athletes")
                
                //Screen body
                VStack(spacing: 0) {
                    
                    athleteListButtonRow
                  
                    athletesList
                    
                    //Spacer to define the body-sheets size:
                    //Spacer().frame(maxWidth: .infinity)
                }
                .background(Color.backgroundColor
                                .clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 20))
                                .edgesIgnoringSafeArea(.bottom))
                
                
            }//VStack to seperate header and bodysheet
        }//ZStack for background
        .background(
            NavigationLink(destination: AthleteDetailLoadingView(athlete: $selectedAthlete),
                           isActive: $showDetailView,
                           label: { EmptyView() })
        )   //->NavigationLink in the background with empty view for lazy loading of detail view in List
    }//Body
    
    
    //MARK: Outsourced Components
    
    var athletesList: some View {
        List{
            ForEach(vm.allAthletes) { athlete in
                    ListRowView(athlete: athlete)
                            .listRowInsets(.init(top: 10, leading: 5, bottom: 10, trailing: 10))
                            .listRowBackground(Color.middlegroundColor)
                            .onTapGesture {
                                segue(athlete: athlete) //->
                            }
                            //.listRowSeperator(.hidden)->need update
            }
            
            
        }
        .listStyle(InsetGroupedListStyle())
    } //AthletesListView
    
    
    
    private func segue(athlete: AthletesModel) {
        selectedAthlete = athlete
        showDetailView.toggle()
    }
    
    private var athleteListButtonRow: some View {
        
        HStack{
            //Change AthletesListViewButton
            Button(action: {
                //Change List Appearance
            })
            {FrameButton(iconName: "HamburgerListIcon", iconColor: .textColor)}
            
            Spacer()
            
            //Sort Button
            Button(action: {
                //Make Sort Sheet Appear
            })
            {FrameButton(iconName: "SortIcon", iconColor: .textColor)
                    .padding(.horizontal, 8) }
            
            // Add Athlete Button
            NavigationLink(
                destination: AddAthleteView(),
                label: {
                    FrameButton(iconName: "AddAthleteIcon", iconColor: .textColor)
                })
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



    //MARK: Preview

struct AthletesListView_Previews: PreviewProvider {
    static var previews: some View {
        AthletesListView()
            .navigationBarHidden(true)
            .environmentObject(dev.athletesVM)
    }
   
}
