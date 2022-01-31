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
            ZStack(alignment: .top){
                Color.accentColor
                    .cornerRadius(20)
                    .ignoresSafeArea()
                VStack (spacing: UIScreen.main.bounds.height/25){
                    ZStack(alignment:.top){
                    AthleteDetailHeaderButtons
                    profilePicture
                            .offset(y: UIScreen.main.bounds.height/30)
                    }
                    
                    VStack(spacing: UIScreen.main.bounds.height/35){
                        HStack {
                            Text(athlete.firstName)
                            Text(athlete.lastName)
                        }
                        .font(.title3)
                        .foregroundColor(Color.textUnchangedColor)
                        
                        Text(dateFormatter.string(from: athlete.birthday))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.textUnchangedColor)
                    }
                    Spacer().frame(height:15)
                }
                .padding(0)
                
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height/3.6)
            
            Spacer()
            
           
                
                
            
            Spacer()
            
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
                
            }){
                NavigationButtonAssestsIcon(iconName: "PenIcon")
            }//Button
        }//HeaderHStackEnding
        .padding()
        
    }
    
    var profilePicture: some View {
        
        ZStack {
            Rectangle()
                .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                .foregroundColor(Color.textUnchangedColor)
                .clipShape(Circle())
                .padding()
            
            Rectangle()
                .frame(minWidth: 0, maxWidth: 96, minHeight: 0, maxHeight: 96)
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
            AthleteDetailView(athlete: dev.athlete)
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
            AthleteDetailView(athlete: dev.athlete)
                .previewDevice("IPhone 8")
                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
            
        }
        
    }
}
