//
//  AthletesListView.swift
//  Photopickertest
//
//  Created by Moose on 04.12.21.
//

import SwiftUI

struct AthletesListView: View {
    
    @EnvironmentObject var athletesViewModel: AthletesViewModel
    
    
    
    var body: some View {
        
        ZStack{
            
            Color.accentColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                //header
                ScreenHeaderTextOnly(screenTitle: "Athletes")
                
                
                VStack(spacing: 0) {
                    //all that is in the screen body
                    
                    athleteListButtonRow
                  
                    athletesList
                    
                    //Spacer to define the body-sheets size
//                    Spacer()
//                        .frame(maxWidth: .infinity)
                }
                .background(Color.backgroundColor
                                .clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 20))
                                .edgesIgnoringSafeArea(.bottom))
                
                
            }//VStack to seperate header and bodysheet
        }//ZStack for background
    }//Body
    
    
    
    
    var athletesList: some View {
        List{
            ForEach(athletesViewModel.savedEntities) {athlete in
               ListRowView(athlete: athlete)
                    .listRowInsets(.init(top: 10, leading: 5, bottom: 10, trailing: 10))
                    .listRowBackground(Color.middlegroundColor)
                    //.listRowSeperator(.hidden)->need update
            }
        }
        .listStyle(InsetGroupedListStyle())
       
        
    } //AthletesListView
    
    //initializer for adjusting List View
    init() {
    UITableView.appearance().backgroundColor = .clear
    UITableViewCell.appearance().backgroundColor = .clear
    UITableView.appearance().tableHeaderView = .init(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
    }//InitializerList
    
}//Struct

struct ListRowView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let athlete: AthletesEntity
    
    var body: some View {
        HStack {
            emptyProfilePicture
            
            Text(athlete.firstname ?? "No Name")
                .font(.title3)
            Spacer()
        }
        .padding(.vertical, 5)
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


extension AthletesListView {
    
    private var athleteListButtonRow: some View {
        
        HStack{
            
            //Change AthletesListViewButton
            Button(action: {
                //Change List Appearance
            })
                {
                    FrameButton(iconName: "HamburgerListIcon", iconColor: .textColor)
                }
            
            Spacer()
            
            //Sort Button
            Button(action: {
                //Make Sort Sheet Appear
            })
                {
                    FrameButton(iconName: "SortIcon", iconColor: .textColor)
                        .padding(.horizontal, 8)
                }
            
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
}

