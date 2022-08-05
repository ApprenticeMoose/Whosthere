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
    

    @Environment(\.managedObjectContext) var context                        //Core Data moc
    @EnvironmentObject var appState: AppState                               //Accessing the athletes
    @EnvironmentObject var tabDetail: TabDetailVM
    
    
    @State private var birthToggle: Bool = false                          //Variable to switch between displaying birthdate and birthyear
    
    private var athlete: AthleteViewModel
    
    
    init(athlete: AthleteViewModel) {
        self.athlete = athlete
        print("Initializing Detail View for: \(String(describing: athlete.firstName))")
    }
  
    
    //MARK: -Body
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)                        //Grey background
            
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
                        .background(Color.accentColor
                                        .clipShape(CustomShape(corners: [.bottomLeft, .bottomRight], radius: 20))
                                        .edgesIgnoringSafeArea(.top))
                
                    Spacer()
                
                }
            
            }//end of ZStack for Color
            .navigationBarHidden(true)
        }//end of Body
    
            
    //MARK: -Dateformatter
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    
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
            withAnimation(.spring()){tabDetail.showDetail = false}
            appState.path.removeLast()
        }){
            NavigationButtonSystemName(iconName: "chevron.backward")
        }
        
        Spacer(minLength: 0)
        
        
        Spacer(minLength: 0)
        
            NBNavigationLink(value: Route.edit(athlete)) {
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

