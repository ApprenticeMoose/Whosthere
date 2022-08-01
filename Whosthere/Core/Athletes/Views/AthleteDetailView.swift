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
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var tabData: TabViewModel
    
    
    @EnvironmentObject var appState: AppState
    
    // variable to switch between displaying birthdate and birthyear
    @State private var birthToggle: Bool = false
    
    //variables for passing along the data to edit view
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
   
    private var athlete: AthleteViewModel
    
    
    init(athlete: AthleteViewModel) {
        self.athlete = athlete
        //tabData.showDetail = true
//        if appState.path.count >= 1 {
//            tabData.showDetail = true
//        } else {
//            return
//        }
        print("Initializing Detail View for: \(String(describing: athlete.firstName))")
       
    }
    
    
    //MARK: -Body
    
    var body: some View {
        //self.tabData.showDetail = true
//        return
//        print(appState.path.count)
        return ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
//Header
                VStack{
                    
                    AthleteDetailHeaderButtons
                        .padding(.bottom, -10)

                    profilePicture
                        .padding(.top, -20)
                        .padding(.bottom, -10)
                
                    nameAndBirthday
                    
                   
                
                        }
                    //.onAppear(perform: {tabData.showDetail = true})
                        .background(Color.accentColor
                                        .clipShape(CustomShape(corners: [.bottomLeft, .bottomRight], radius: 20))
                                        .edgesIgnoringSafeArea(.top))
                        //.onAppear(perform: print("\(appState.path.count)"))
                
                    Spacer()
                    Button(action: {
                        appState.path.removeLast(appState.path.count)
                    }){
                        Text("pop to root")
                    }

                    Spacer()
                
                }
            
            }//end of ZStack for Color
            .navigationBarHidden(true)
        }//end of Body
    
            
    //MARK: -Functions
    

    
    
    // MARK: -Outsourced Components
    
    var nameAndBirthday: some View {
    
    VStack(spacing: UIScreen.main.bounds.height/70){
        HStack {
            Text(athlete.firstName)
                .font(.title3)
                .fontWeight(.bold)
            Text(athlete.lastName)
                .font(.title3)
                .fontWeight(.bold)
            }
            .foregroundColor(Color.textUnchangedColor)
        VStack{
           
            if let dateOfBirth = athlete.birthday {
                if athlete.showYear {
                    Text("\(String(describing: Calendar.current.component(.year, from: dateOfBirth)))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.textUnchangedColor)
                        .padding(.bottom, 15)
                } else {
                    Text(birthToggle == false ? "\(String(describing: Calendar.current.component(.year, from: dateOfBirth)))" : dateFormatter.string(from: dateOfBirth))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.textUnchangedColor)
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
                        .foregroundColor(Color.textUnchangedColor)
                        .opacity(0.7)

                    Image("PenIcon")
                        .foregroundColor(Color.textUnchangedColor)
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
            appState.path.removeLast()
            tabData.showDetail = false
            
        }){
            NavigationButtonSystemName(iconName: "chevron.backward")
        }
        
        Spacer(minLength: 0)
        
        
        Spacer(minLength: 0)
        
        
            NBNavigationLink(value: Route.test(athlete)) {
                NavigationButtonAssestsIcon(iconName: "PenIcon")
            }

        
    }//HeaderHStackEnding
    .padding()
}
    
    var profilePicture: some View {
        
        ZStack {
            Rectangle()
                .frame(minWidth: 120, maxWidth: 120, minHeight: 120, maxHeight: 120)
                .foregroundColor(Color.textUnchangedColor)
                .clipShape(Circle())
                .padding()
            
            Rectangle()
                .frame(minWidth: 0, maxWidth: 114, minHeight: 0, maxHeight: 114)
                .clipShape(Circle())
                .foregroundColor(colorScheme == .light ? .greyFourColor : .greyTwoColor)
                .padding()
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 42, height: 42, alignment: .center)
                .foregroundColor(colorScheme == .light ? .greyTwoColor : .greyOneColor)
        }
    }
}

