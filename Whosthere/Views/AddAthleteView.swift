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
    @State var birthYear = Calendar.current.component(.year, from: Date())
    @State var gender = ""
   

    //Toggle
    @State var show: Bool = false
    @State var toggleIsOn: Bool = false
    @State var showPrompt: Bool = false
    @State var buttonFarbe : Color = .orangeAccentColor
    
    
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
                            BirthdayField(show: $show, selectedDate: $birthDate, toggleIsOn: $toggleIsOn, selectedYear: $birthYear)
                            GenderButtons(gender: $gender)
                        }
                        
                        
                        //Spacer to define the body-sheets size
    //                    Spacer()
    //                        .frame(maxWidth: .infinity)
                        
                        Spacer()
                        
                        addButton
                        
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
    
    
    
    // MARK: Functions
    

    func textIsAppropriate() -> Bool {
        if firstNameTF.count >= 2 && lastNameTF.count >= 1 {
            return true
        }
        return false
    }
    
    var buttonDisabledColor: Color {
        return colorScheme == .light ? .greyTwoColor : .darkModeDisabledButtonColor
        }
    
    func addAthletePressed() {
        athletesViewModel.addAthlete(firstName: firstNameTF, lastName: lastNameTF)
        presentationMode.wrappedValue.dismiss()
    }
    
    var addButton: some View{
        Button(action: {
           if textIsAppropriate() {
                addAthletePressed()
            }
        })      {
            HStack{
                Image(systemName: "plus")
                    .font(.system(size: 20))
                Text("Add Athlete")
                    .font(.headline)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 55)
            .background(textIsAppropriate() ? Color.orangeAccentColor : buttonDisabledColor)
            .foregroundColor(.textUnchangedColor)
            .cornerRadius(10)
            .padding()
                         
//                                        backgroundColor: textIsAppropriate() ? Color.orangeAccentColor : colorScheme == .light ? .greyTwoColor : .greyOneColor)
                //.disabled(textIsAppropriate())
        }
        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
    }
    
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
                .autocapitalization(.words)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.middlegroundColor)
                .foregroundColor(Color.textColor)
                .frame(height:44)
                .cornerRadius(10)
                .font(.headline)
                
                //.textInputAutocapitalization(.words)
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
                        .foregroundColor(makeClear() ? Color.clear : Color.textColor)
                        .fontWeight(.semibold)
                }
                else{
                    Text(dateFormatter.string(from: selectedDate))
                        .font(.body)
                        .foregroundColor(makeClear() ? Color.clear : Color.textColor)
                        .fontWeight(.semibold)
                    
                }
                }
            .onTapGesture {
                //withAnimation(.default){
                show.toggle()
                //}
            }
            .frame(height: 44)
        }
        .padding()
    }
    
    //function to check if the selected date is not today so if another date is selected the birthday header can be grayed out with a tertiary statement in the foregroundcolor modifier
    func changeOpacity() -> Bool {
        if Calendar.current.isDateInToday(selectedDate) && selectedYear == Calendar.current.component(.year, from: Date()) {
            return false
        }
        return true
    }
    
    
    //function to check if the selected date is not today so the birthdayfield can be clear at the beginning
    func makeClear() -> Bool {
        if Calendar.current.isDateInToday(selectedDate) && selectedYear == Calendar.current.component(.year, from: Date()) {
            return true
        }
        return false
    }
}


struct GenderButtons: View {
    
    @Binding var gender : String
    @State var male = false
    @State var female = false
    @State var nonbinary = false
    
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





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddAthleteView()
                .previewDevice("iPhone 12 Pro Max")
                .navigationBarHidden(true)
            AddAthleteView()
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
            AddAthleteView()
                .previewDevice("IPhone 8")
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
            
            VStack(alignment: .leading ,spacing: 10) {
                
               
                
                if self.toggleIsOn {
                    Picker("", selection: $selectedYear) {
                        ForEach(currentYear-100...currentYear, id: \.self) {
                                    Text(String($0))
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal, 20)
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
                    //withAnimation(.easeOut(duration: 0.5)){
                    show.toggle()
                  // }
                }
                
                
               
            }
               
        }
        
        
    }
}

/*
1. on iphone se the keyboard covers the last name text field...move it up somehow?
 ->
https://stackoverflow.com/questions/56491881/move-textfield-up-when-the-keyboard-has-appeared-in-swiftui
 
2.Capitailze first letter of name for good
 ->
 https://stackoverflow.com/questions/34558515/trying-to-capitalize-the-first-letter-of-each-word-in-a-text-field-using-swift#34558603
 
3. work out MVVM stuff so all data is saved, the list actually works and you can look at a rough detail athlete view -> save with Core Data -> Create nice and full athlete view
 */
