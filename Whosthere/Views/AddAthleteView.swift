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
    @State var firstNameTF = ""
    @State var lastNameTF = ""
    @State var birthDate = Date()

   
//    @State var birthday = ""
    @State var male = false
    @State var female = false
    @State var nonbinary = false

    @State var show: Bool = true
    
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
                            BirthdayField(show: $show, selectedDate: $birthDate)
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
                    Popover(selectedDate: $birthDate)
                    //.offset(x: -25, y: -90)
                }
            }//ZStackforpopover
              
        }//ZStack End
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    }//Body End
    
    
    
    // MARK: Functions
    
    func getXCoordinates(geo: GeometryProxy) -> Double {
        let xCoordinate = geo.frame(in: .global).midX
        return xCoordinate
    }
    
    func getYCoordinates(geo: GeometryProxy) -> Double {
        let yCoordinate = geo.frame(in: .global).midY
        return yCoordinate
    }
    
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
                //backbutton
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

struct GeometryGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = geometry.frame(in: .global)
        }

        return Rectangle().fill(Color.clear)
    }
}

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
    
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
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
                    
                   
                
                Text(dateFormatter.string(from: selectedDate))
                    .font(.body)
                    .foregroundColor(Color.textColor)
                    .fontWeight(.semibold)
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
        if Calendar.current.isDateInToday(selectedDate) {
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
    @State var toggleIsOn: Bool = true
    @State var selection = Date()
    @State var currentYear = Calendar.current.component(.year, from: Date())
    
    let endingDate: Date = Date()
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.middlegroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 360, alignment: .bottom)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                
                if self.toggleIsOn {
                    Picker("", selection: $selection) {
                        ForEach(currentYear...2020, id: \.self) {
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

                //Add Toggle with label show years only...then switch datepicker to .wheel
                //Add okay button to check out
                //use ease in animation
            }
               
        }
        
        
    }
}
