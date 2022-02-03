//
//  EditAthleteView.swift
//  Whosthere
//
//  Created by Moose on 02.02.22.
//

import SwiftUI

//MARK: LoadingView for Lazy Loading of EditView below

struct EditAthleteLoadingView: View {
    
    @Binding var athlete: AthletesModel?
    
    var body: some View {
        ZStack{
            if let athlete = athlete {
                EditAthleteView(athlete: athlete)
            }
        }
    }
}


struct EditAthleteView: View {
    
    //MARK: Properties

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    
    @EnvironmentObject var athletesViewModel: AthletesViewModel
    
    //Variables
    let athlete: AthletesModel
    
    @State var firstNameTF:String
    @State var lastNameTF:String
    @State var birthDate:Date
    @State var birthYear:Int
    @State var gender:String
   

    init(athlete: AthletesModel) {
        self.athlete = athlete
        self._firstNameTF = State(wrappedValue: athlete.firstName)
        self._lastNameTF = State(wrappedValue: athlete.lastName)
        self._birthDate = State(wrappedValue: athlete.birthday)
        self._birthYear = State(wrappedValue: athlete.birthyear)
        self._gender = State(wrappedValue: athlete.gender)
        print("Initializing Edit View for: \(String(describing: athlete.firstName))")
    }
    
    //Toggle
    @State var show: Bool = false
    @State var toggleIsOn: Bool = false
    @State var showPrompt: Bool = false
    @State var buttonFarbe : Color = .orangeAccentColor
    
    
   
    
    var body: some View {
        //GeometryReader so the View doesnt move uppwards once the keyboard is actived
        GeometryReader { _ in
        ZStack{
            
            Color.accentColor.edgesIgnoringSafeArea(.all)
            ZStack{
            VStack{
                //header
                editAthleteHeader
                
                ZStack {
                    VStack(spacing: 0) {
                        //all that is in the screen body
                        
                        profilePicture
                        
                        LongTextField(textFieldDescription: "First Name",  firstNameTF: $firstNameTF)
                        
                        LongTextField(textFieldDescription: "Last Name", firstNameTF: $lastNameTF)
                        
                        HStack {
                            BirthdayField(show: $show, selectedDate: $birthDate, toggleIsOn: $toggleIsOn, selectedYear: $birthYear)
                            EditGenderButtons(gender: $gender)
                        }
                        
                        
                        //Spacer to define the body-sheets size
    //                    Spacer()
    //                        .frame(maxWidth: .infinity)
                        
                        Spacer()
                        
                        
                        
                    }
                    .padding(.top, 20)
                    .background(Color.backgroundColor
                                    .clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 20))
                                .edgesIgnoringSafeArea(.bottom))
                    
                    
                } //ZStack for Popover
                
            }//VStack to seperate Header and ScreenBody/content
               
                ZStack{
                if self.show {
                    Color.black
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            //withAnimation(.easeOut(duration: 0.5)){
                            show.toggle()
                            //}
                        }
                   
                    Popover(selectedDate: $birthDate, toggleIsOn: $toggleIsOn, show: $show, selectedYear: $birthYear)
                
                }
                }
                .opacity(self.show ? 1 : 0).animation(.easeIn)
                
            }//ZStackforpopover
              
        }//ZStack End
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    }//Body End
    
    
    var profilePicture: some View {
        ZStack {
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
            
            
                ZStack{
                Circle()
                    .strokeBorder(Color.textUnchangedColor, lineWidth: 1)
                    .background(Circle().foregroundColor(colorScheme == .light ? Color.greyFourColor : Color.greyTwoColor))
                    .frame(width: 34, height: 34)
                Image("AddCameraIcon")
                    .resizable()
                    .frame(width: 17, height: 17, alignment: .center)
                    .foregroundColor(.orangeAccentColor)
                }
                .offset(x: 40, y: -30)
            }
              }
    
    var editAthleteHeader: some View {
        HStack{
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                NavigationButtonSystemName(iconName: "chevron.backward")
            }
            
            Spacer(minLength: 0)
            
            Text("Edit Athlete")
                .font(.title)
                .foregroundColor(.textUnchangedColor)
                .fontWeight(.medium)
            
            Spacer(minLength: 0)
            
            Button(action: {
                //addAthletePressed()
            }){
                NavigationButtonSystemName(iconName: "checkmark")
            }//Button
        }//HeaderHStackEnding
        .padding()
        
    }
    
}

struct EditAthleteView_Previews: PreviewProvider {
    static var previews: some View {
        EditAthleteView(athlete: dev.athlete)
    }
}


struct EditGenderButtons: View {
    
    @Binding var gender : String
    @State var male = false
    @State var female = false
    @State var nonbinary = false
    let maleString = "male"
    
//    init(gender: String){
//        self._gender = gender
//        if (gender.contains(maleString)) {
//            male = true
//        } else if gender.contains("female") {
//            female = true
//        } else if gender.contains("nonbinary") {
//            nonbinary = true
//        }
//    }
    
    var body: some View{
        VStack(alignment: .leading){
            //Gender
            Text("Gender")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(changeOpacity() ? Color.textColor.opacity(0.30) : Color.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
            
            
            
            HStack {
                //Buttons for gender
                Button(action: {
                    gender = "male"
                    male.toggle()
                    female = false
                    nonbinary = false
                }) {
                    ZStack {
                        Rectangle()
                            .frame(width: 44, height: 44)
                            .cornerRadius(10)
                            .foregroundColor(male ? Color.accentColor: Color.middlegroundColor)
                        Image("MaleIcon")
                            .foregroundColor(male ? Color.textUnchangedColor: Color.textColor)
                    }
                }
                
                Button(action: {
                    gender = "female"
                    female.toggle()
                    male = false
                    nonbinary = false
                }) {
                    ZStack {
                        Rectangle()
                            .frame(width: 44, height: 44)
                            .cornerRadius(10)
                            .foregroundColor(female ? Color.accentColor: Color.middlegroundColor)
                        Image("FemaleIcon")
                            .foregroundColor(female ? Color.textUnchangedColor: Color.textColor)
                    }
                }
                
                Button(action: {
                    gender = "nonbinary"
                    nonbinary.toggle()
                    male = false
                    female = false
                }) {
                    ZStack {
                        Rectangle()
                            .frame(width: 44, height: 44)
                            .cornerRadius(10)
                            .foregroundColor(nonbinary ? Color.accentColor: Color.middlegroundColor)
                        Image("NonBinaryIcon")
                            .foregroundColor(nonbinary ? Color.textUnchangedColor: Color.textColor)
                    }
                }
    }
           
}//VStack
        .padding()
    }
    
    func changeOpacity() -> Bool {
        if  male || female || nonbinary == true {
            return true
        }
        return false
    }
    
    
  
}
