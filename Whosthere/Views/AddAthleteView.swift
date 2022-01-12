//
//  ContentView.swift
//  Photopickertest
//
//  Created by Moose on 20.11.21.
//

import SwiftUI

struct AddAthleteView: View {
   
    //MARK: Properties

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var athletesViewModel: AthletesViewModel
    
    //Variables
    @State var firstNameTF = ""
    @State var lastNameTF = ""
    @State var birthDate = Date()
    @State var selectedYear = Calendar.current.component(.year, from: Date())
    @State var male = false
    @State var female = false
    @State var nonbinary = false

    //Toggle
    @State var show: Bool = false
    @State var toggleIsOn: Bool = false
    
    
    
    //MARK: Body
    
    var body: some View {
        //GeometryReader so the View doesnt move uppwards once the keyboard is actived
        GeometryReader { _ in
        ZStack{
            
            Color.accentColor.edgesIgnoringSafeArea(.all)
            ZStack{
            VStack{
                //header
                addAthleteHeader
                
                ZStack {
                    VStack(spacing: 0) {
                        //all that is in the screen body
                        
                        profilePicture
                        
                        LongTextField(textFieldDescription: "First Name",  firstNameTF: $firstNameTF)
                        
                        LongTextField(textFieldDescription: "Last Name", firstNameTF: $lastNameTF)
                        
                        HStack {
                            BirthdayField(show: $show, selectedDate: $birthDate, toggleIsOn: $toggleIsOn, selectedYear: $selectedYear)
                            GenderButtons(male: $male, female: $female, nonbinary: $nonbinary)
                        }
                        
                        
                        //Spacer to define the body-sheets size
    //                    Spacer()
    //                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            if textIsAppropriate() {
                                addAthletePressed()
                            }
                        })      {
                            BigAddButton(icon: "plus", description: "Add Athlete", textColor: .white, backgroundColor: Color.orangeAccentColor)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        
                        
                    }
                    .padding(.top, 20)
                    .background(Color.backgroundColor
                                    .clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 20))
                                .edgesIgnoringSafeArea(.bottom))
                    
                    
                } //ZStack for Popover
                
            }//VStack to seperate Header and ScreenBody/content
                if self.show{
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            show.toggle()
                        }
                    Popover(selectedDate: $birthDate, toggleIsOn: $toggleIsOn, show: $show, selectedYear: $selectedYear)
                    //.offset(x: -25, y: -90)
                }
            }//ZStackforpopover
              
        }//ZStack End
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    }//Body End
    
    
    
    // MARK: Functions
    

    func textIsAppropriate() -> Bool {
        if firstNameTF.count >= 2 && lastNameTF.count >= 1 {
            return true
        }
        return false
    }
    
    func addAthletePressed() {
        athletesViewModel.addAthlete(firstName: firstNameTF, lastName: lastNameTF)
        presentationMode.wrappedValue.dismiss()
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
                              .background(Color.accentColor)
                              .clipShape(Circle())
                              .foregroundColor(colorScheme == .light ? .greyFourColor : .greyTwoColor)
                              .padding()
                          Image(systemName: "person.fill")
                              .resizable()
                              .frame(width: 42, height: 42, alignment: .center)
                              .foregroundColor(colorScheme == .light ? .greyTwoColor : .greyOneColor)
                      }
              }
    
    var addAthleteHeader: some View {
        HStack{
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                NavigationButton(iconName: "chevron.backward")
            }
            
            Spacer(minLength: 0)
            
            Text("Add Athlete")
                .font(.title)
                .foregroundColor(.textUnchangedColor)
                .fontWeight(.medium)
            
            Spacer(minLength: 0)
            
            Button(action: {
                addAthletePressed()
            }){
                NavigationButton(iconName: "checkmark")
            }//Button
        }//HeaderHStackEnding
        .padding()
        
    }
    
    
}//Struct End


    // MARK: Subviews

struct LongTextField: View {
    
    @State var textFieldDescription: String
    @Binding var firstNameTF: String
    
    var body: some View {
        VStack{
            //Firstname
            Text(textFieldDescription)
                .font(.body)
                .foregroundColor(changeOpacity() ? Color.textColor.opacity(0.30) : Color.textColor)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
            
            TextField("", text: $firstNameTF)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.middlegroundColor)
                .foregroundColor(Color.textColor)
                .frame(height:44)
                .cornerRadius(10)
                .font(.headline)
        }
        .padding()
        .navigationBarHidden(true)
    }
    
    func changeOpacity() -> Bool {
        if firstNameTF.count >= 1 {
            return true
        }
        return false
    }
    
}


struct BirthdayField: View {
    
    @Binding var show: Bool
    
    @Binding var selectedDate: Date
    
    @Binding var toggleIsOn: Bool
    
    @Binding var selectedYear : Int
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        VStack{
            
            Text("Birthday")
                .font(.body)
                .foregroundColor(changeOpacity() ? Color.textColor.opacity(0.30) : Color.textColor)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
            
            ZStack{
                
                Rectangle()
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .foregroundColor(Color.middlegroundColor)
                    .background(Color.middlegroundColor)
                    .frame(height: 44)
                    .cornerRadius(10)
                    
                   
                if self.toggleIsOn {
                    Text(String(selectedYear))
                        .font(.body)
                        .foregroundColor(Color.textColor)
                        .fontWeight(.semibold)
                }
                else{
                    Text(dateFormatter.string(from: selectedDate))
                        .font(.body)
                        .foregroundColor(Color.textColor)
                        .fontWeight(.semibold)
                    
                }
                }
            .onTapGesture {
                show.toggle()
            }
            .frame(height: 44)
        }
        .padding()
    }
    /*
    func fieldEmpty() -> Bool {
        if
    }
     */
    
    func changeOpacity() -> Bool {
        if Calendar.current.isDateInToday(selectedDate) && selectedYear == Calendar.current.component(.year, from: Date()) {
            return false
        }
        return true
    }
}


struct GenderButtons: View {
    
    @Binding var male: Bool
    @Binding var female: Bool
    @Binding var nonbinary: Bool
    
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





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddAthleteView()
                .previewDevice("iPhone 11")
                .navigationBarHidden(true)
            AddAthleteView()
                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
            AddAthleteView()
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
        }
        .environmentObject(AthletesViewModel())
    }
}

    






struct Popover: View {
    @Binding var selectedDate: Date
    @Binding var toggleIsOn: Bool
    @Binding var show: Bool
    @State var currentYear = Calendar.current.component(.year, from: Date())
    @Binding var selectedYear : Int
    
    
    let endingDate: Date = Date()
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.middlegroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 425, alignment: .center)
                .padding(.horizontal)
            
            VStack(spacing: 10) {
                
               
                
                if self.toggleIsOn {
                    Picker("", selection: $selectedYear) {
                        ForEach(currentYear-100...currentYear, id: \.self) {
                                    Text(String($0))
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal, 30)
                        .frame(height: 300)
                }
                else{
                DatePicker("", selection: $selectedDate, in: ...endingDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .accentColor(.orangeAccentColor)
                    .labelsHidden()
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .frame(height: 300)
                }
                
                    Toggle(
                        isOn: $toggleIsOn,
                        label: {
                            Text("Select year of birth only")
                                   .font(.body)
                                   .fontWeight(.semibold)
                                    .foregroundColor(Color.textColor)
                            })
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        .toggleStyle(SwitchToggleStyle(tint: Color.orangeAccentColor))
                
                HStack{
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                    Text("Add now")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40)
                .background(Color.orangeAccentColor)
                .foregroundColor(Color.textUnchangedColor)
                .cornerRadius(10)
                .padding(.horizontal, 25)
                .onTapGesture {
                    show.toggle()
                }
                
                
                //make field clear if current date is shown (DateStyle = .none, or use Color.clear for Text field if it is the current date much like the opacity function
                //use ease in animation
                //add messege and detecting if first name is less then 2 characters and disable the add button
                //workout MVVM stuff so all data is saved, the list actually works and you can look at a rough detail athlete view -> save with Core Data -> Create nice and full athlete view
            }
               
        }
        
        
    }
}
