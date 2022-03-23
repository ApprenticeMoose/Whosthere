//
//  AthleteDetailView.swift
//  Whosthere
//
//  Created by Moose on 31.01.22.
//

import SwiftUI

//Is for lazyloading and checks if athlete is valid, then passses it to actual DetailView, and displays DetailView
//struct AthleteDetailLoadingView: View {
//
//    @Binding var athlete: AthletesModel?
//    @Binding var showDetailView: Bool
//
//    var body: some View {
//        ZStack{
//            if let athlete = athlete {
//                AthleteDetailView(athlete: athlete, showDetailView: $showDetailView)
//            }
//        }
//    }
//}

struct AthleteDetailView: View {
    
    // MARK: -Properties
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vm: AthletesViewModel
    
    // variable to switch between displaying birthdate and birthyear
    @State private var birthToggle: Bool = false
    
    //variables for passing along the data to edit view
    @State private var selectedAthlete: AthletesModel? = nil
    @State private var showEditView: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    private var athlete: AthletesModel
    @Binding var showDetailView: Bool
    
    init(athlete: AthletesModel, showDetailView: Binding<Bool>) {
        self.athlete = athlete
        self._showDetailView = showDetailView
        print("Initializing Detail View for: \(String(describing: athlete.firstName))")
    }
    
    
    //MARK: -Body
    
    var body: some View {
           
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
//Header
                VStack{
                    
                    AthleteDetailHeaderButtons
                        .padding(.bottom, -10)
                        .fullScreenCover(isPresented: $showEditView,
                                         
                                         content: {EditAthleteView(athlete: athlete, showDetailView: $showDetailView)})
                    
                    profilePicture
                        .padding(.top, -20)
                        .padding(.bottom, -10)
                
                    nameAndBirthday
                
                        }
                        .background(Color.accentColor
                                        .clipShape(CustomShape(corners: [.bottomLeft, .bottomRight], radius: 20))
                                        .edgesIgnoringSafeArea(.top))
//Content
                    Spacer()
                }
            
            }//end of ZStack for Color
//            .background(
//                NavigationLink(destination: EditAthleteLoadingView(athlete: $selectedAthlete, showDetailView: $showDetailView),
//                               isActive: $showEditView,
//                               label: { EmptyView() }))
            .navigationBarHidden(true)
        }//end of Body
    
            
    //MARK: -Functions
    
    private func segue(athlete: AthletesModel) {
        selectedAthlete = athlete
        showEditView.toggle()
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
        
        if Calendar.current.component(.year, from: Date()) == athlete.birthyear {
            
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
                .onTapGesture {
                    segue(athlete: athlete)
                }
        }
        else if Calendar.current.component(.year, from: athlete.birthday) == athlete.birthyear {
            
                Text(birthToggle == false ? "\(String(describing: athlete.birthyear))" : dateFormatter.string(from: athlete.birthday))
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
        else {
            
            Text("\(String(describing: athlete.birthyear))")
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
    }
}
    
    var AthleteDetailHeaderButtons: some View {
    
    HStack(){
        
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }){
            NavigationButtonSystemName(iconName: "chevron.backward")
        }
        
        Spacer(minLength: 0)
        
        
        Spacer(minLength: 0)
        
        
        Button(action: {
            showEditView.toggle()
        }){
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

