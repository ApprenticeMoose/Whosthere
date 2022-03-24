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
    @ObservedObject var addVM: AddAthleteViewModel

    
    //Toggle
    @State var show: Bool = false
    @State var showPrompt: Bool = false
    @State var buttonFarbe : Color = .orangeAccentColor
    
    
    //MARK: Body
    
    var body: some View {
        //GeometryReader so the View doesnt move upwards once the keyboard is actived
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
                            
                            LongTextField(textFieldDescription: "First Name",  firstNameTF: $addVM.firstName)
                            
                            LongTextField(textFieldDescription: "Last Name", firstNameTF: $addVM.lastName)
                            
                            HStack {
                                BirthdayField(show: $show, selectedDate: $addVM.birthDate, /*selectedYear: $addVM.birthYear,*/ showYear: $addVM.showYear)
                                GenderButtons(gender: $addVM.gender)
                            }
                            
//Spacer to define the body-sheets size
//                      Spacer().frame(maxWidth: .infinity)
                            
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
                            .onTapGesture { show.toggle() }
                       
                        Popover(selectedDate: $addVM.birthDate, show: $show, selectedYear: $addVM.birthYear, showYear: $addVM.showYear)
                        }
                    }
                    .opacity(self.show ? 1 : 0).animation(.easeIn)
            }//ZStackforpopover
        }//ZStack End
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}//Body End
    
    
    
    // MARK: Functions
    
    //function to adjust the year variable according to the selected birthdate variable->is called when add athlete button is pressed
    func getBirthYear() -> Int {
        if addVM.birthDate != Date()
            {
            addVM.birthYear = Calendar.current.component(.year, from: addVM.birthDate)
            }
        return addVM.birthYear
    }
    
    //function that connects all the selected variables to the model via the viewmodel and closes view afterwards
    func addAthlete() {
        let athlete = AthletesModel(firstName: addVM.firstName, lastName: addVM.lastName, birthday: addVM.birthDate, birthyear: addVM.birthYear, gender: addVM.gender, showYear: addVM.showYear)
        athletesViewModel.addAthlete.send(athlete)
        presentationMode.wrappedValue.dismiss()
    }
    
    
    //MARK: Outsourced components
    
    var addButton: some View{
    Button(action: {
        if addVM.textIsAppropriate()
        {
            if addVM.showYear == false {
                addVM.birthYear = getBirthYear()
            }
            addAthlete()
        }
    }){
        HStack{
            Image(systemName: "plus")
                .font(.system(size: 20))
            Text("Add Athlete")
                .font(.headline)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 55)
        .background(addVM.textIsAppropriate() ? Color.orangeAccentColor : buttonDisabledColor)
        .foregroundColor(.textUnchangedColor)
        .cornerRadius(10)
        .padding()
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
                NavigationButtonSystemName(iconName: "chevron.backward")
            }
            
            Spacer(minLength: 0)
            
            Text("Add Athlete")
                .font(.title)
                .foregroundColor(.textUnchangedColor)
                .fontWeight(.medium)
            
            Spacer(minLength: 0)
            
            Button(action: {
                addAthlete()
            }){
                NavigationButtonSystemName(iconName: "checkmark")
            }//Button
        }//HeaderHStackEnding
        .padding()
}
    
    var buttonDisabledColor: Color {
        return colorScheme == .light ? .greyTwoColor : .darkModeDisabledButtonColor
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
    
    //@Binding var selectedYear : Int
    
    @Binding var showYear: Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        VStack{
            
            Text("Birthday")
                .font(.body)
                .foregroundColor(/*changeOpacity() ? Color.textColor.opacity(0.30) :*/ Color.textColor)
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
                    
                   
                if self.showYear {
//                    Text(String(selectedYear))
//                        .font(.body)
//                        .foregroundColor(makeClear() ? Color.clear : Color.textColor)
//                        .fontWeight(.semibold)
                }
                else{
                    VStack{
                    Text(dateFormatter.string(from: selectedDate))
                        .font(.body)
                        .foregroundColor(/*makeClear() ? Color.clear :*/ Color.textColor)
                        .fontWeight(.semibold)
                    }
//                    .onAppear(perform: selectedYear = Calendar.current.component(.year, from: selectedDate))
                }
            }
            .onTapGesture {
                show.toggle()
            }
            .frame(height: 44)
        }
        .padding()
    }
    
    //function to check if the selected date is not today so if another date is selected the birthday header can be grayed out with a tertiary statement in the foregroundcolor modifier
   /*
    func changeOpacity() -> Bool {
        if Calendar.current.isDateInToday(selectedDate) && selectedYear == Calendar.current.component(.year, from: Date()) {
            return false
        }
        return true
    }
    
    
    function to check if the selected date is not today so the birthdayfield can be clear at the beginning
    func makeClear() -> Bool {
        if Calendar.current.isDateInToday(selectedDate) && selectedYear == Calendar.current.component(.year, from: Date()) {
            return true
        }
        return false
    }
    
    func getBirthYear() -> Int {
        if selectedDate != Date() {
            selectedYear = Calendar.current.component(.year, from: selectedDate)
        }
        return selectedYear
    }
    */
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

//class Component: ObservableObject {
//    @Binding var selectedDate: Date
//
//    lazy var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: selectedDate)
//}

protocol Year {
    var year: Binding<Int> { mutating get
        mutating set
    }
}

struct Popover: View {
    @Binding var selectedDate: Date
    //@Binding var toggleIsOn: Bool
    @Binding var show: Bool
    @State var currentYear = Calendar.current.component(.year, from: Date())
    @Binding var selectedYear : Int
    @Binding var showYear: Bool
    
//    init(selectedDate: Binding<Date>, show: Binding<Bool>, selectedYear: Binding<Int>, showYear: Binding<Bool>) {
//        self._selectedDate = selectedDate
//        self._show = show
//        self._selectedYear = selectedYear
//        self._showYear = showYear
//    }

     lazy var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: selectedDate)
    
//    func setYear(newYear: Int) -> Date {
//        component.year = newYear
//
//    }
    
    private var year: Binding<Int> { Binding (
        get: {Calendar.current.component(.year, from: selectedDate)},
        set:  {_ in
//            component.year = year.wrappedValue
//            selectedDate = Calendar.current.date(from: component) ?? selectedDate
        }
        //Set the selectedDate to datecomponents.year = year
    )
 }
    
    
    /* //For checking the date
     component.year = year
     Calendar.current.date(from: component)
     */
    
    
    
    let endingDate: Date = Date()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.middlegroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 425, alignment: .center)
                .padding(.horizontal)
            
            VStack(alignment: .leading ,spacing: 10) {
            
                if self.showYear {
                    Picker("", selection: year) {
                        ForEach(currentYear-100...currentYear, id: \.self) {
                                    Text(String($0))
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                            .labelsHidden()
                            .padding(.horizontal, 20)
                            .frame(height: 300)
                } else {
                    DatePicker("", selection: $selectedDate, in: ...endingDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .accentColor(.orangeAccentColor)
                        .labelsHidden()
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                        .frame(height: 300)
                }
                
                    Toggle(
                        isOn: $showYear,
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
                    print(selectedDate)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddAthleteView(addVM: AddAthleteViewModel())
                .previewDevice("iPhone 12 Pro Max")
                .navigationBarHidden(true)
            AddAthleteView(addVM: AddAthleteViewModel())
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
            AddAthleteView(addVM: AddAthleteViewModel())
                .previewDevice("IPhone 8")
                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
        }
        .environmentObject(AthletesViewModel())
    }
}




    //MARK: Notes
/*
1. on iphone se the keyboard covers the last name text field...move it up somehow?
 ->
https://stackoverflow.com/questions/56491881/move-textfield-up-when-the-keyboard-has-appeared-in-swiftui
 
2.Capitailze first letter of name for good
 ->
 https://stackoverflow.com/questions/34558515/trying-to-capitalize-the-first-letter-of-each-word-in-a-text-field-using-swift#34558603
 
3. work out MVVM stuff so all data is saved, the list actually works and you can look at a rough detail athlete view -> save with Core Data -> Create nice and full athlete view
 */
