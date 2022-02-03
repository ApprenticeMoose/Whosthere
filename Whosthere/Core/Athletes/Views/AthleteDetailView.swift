//
//  AthleteDetailView.swift
//  Whosthere
//
//  Created by Moose on 31.01.22.
//

import SwiftUI


struct AthleteDetailLoadingView: View {
    
    @Binding var athlete: AthletesModel?
    
  
    
    var body: some View {
        ZStack{
            if let athlete = athlete {
                AthleteDetailView(athlete: athlete)
            }
        }
    }
}


struct AthleteDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State private var birthToggle: Bool = false
    @State private var opacity: Double = 1
    
    @State private var selectedAthlete: AthletesModel? = nil
    @State private var showDetailView: Bool = false
    
    let athlete: AthletesModel
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    init(athlete: AthletesModel) {
        self.athlete = athlete
        print("Initializing Detail View for: \(String(describing: athlete.firstName))")
    }
    
    var body: some View {
           
        ZStack{
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
                .background(Color.accentColor
                                .clipShape(CustomShape(corners: [.bottomLeft, .bottomRight], radius: 20))
                                .edgesIgnoringSafeArea(.top))
                Spacer()
        }
            
            }//end of ZStack for Color
        .background(
            NavigationLink(destination: EditAthleteLoadingView(athlete: $selectedAthlete),
                           isActive: $showDetailView,
                           label: { EmptyView() }))
        .navigationBarHidden(true)
        }//end of Body
    
            
       
    
    
    
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
                segue(athlete: athlete)
            }){
                NavigationButtonAssestsIcon(iconName: "PenIcon")
            }
                    
                
                                
           
        }//HeaderHStackEnding
        .padding()
        
    }
    
    private func segue(athlete: AthletesModel) {
        selectedAthlete = athlete
        showDetailView.toggle()
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

struct AthleteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            AthleteDetailView(athlete: dev.athlete)
                .previewDevice("iPhone 12 Pro Max")
                .navigationBarHidden(true)
          
            
        }
        
    }
}