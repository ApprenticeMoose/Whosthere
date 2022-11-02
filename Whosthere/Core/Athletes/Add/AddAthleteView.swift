//
//  ContentView.swift
//  Photopickertest
//
//  Created by Moose on 20.11.21.
//
import SwiftUI


struct AddAthleteView: View {

    //MARK: Properties
    @Environment(\.presentationMode) var presentationMode                       //For dismissing views
    @Environment(\.colorScheme) var colorScheme                                 //DarkMode
    
    @ObservedObject var addVM: AddAthleteVM                              //Accessing the variables for adding
    
    init(dataManager: DataManager = DataManager.shared) {
        self.addVM = AddAthleteVM(dataManager: dataManager)
    }
                                                                         
    @State var show: Bool = false                                               //Bool for showing Birthdaypicker
    @State var buttonFarbe : Color = .orangeAccentColor                         //Color for Button


    //MARK: Body
    var body: some View {
        //GeometryReader so the View doesnt move upwards once the keyboard is actived
        GeometryReader { _ in
//        ZStack{
//
//            Color.accentColor.edgesIgnoringSafeArea(.all)
            ZStack{
                VStack{
                    //header
                    addAthleteHeader

                    ZStack {
                        VStack(spacing: 0) {
                            //all that is in the screen body
                            profilePicture

                            LongTextField(textFieldDescription: "First Name",  firstNameTF: $addVM.addedAthlete.firstName)
                            
                        

                            LongTextField(textFieldDescription: "Last Name", firstNameTF: $addVM.addedAthlete.lastName)

                            HStack {
                                BirthdayField(show: $show, selectedDate: $addVM.addedAthlete.birthday, showYear: $addVM.addedAthlete.showYear)
                                GenderButtons(gender: $addVM.addedAthlete.gender)
                            }

                            Spacer()

                            addButton
                        }
                        .padding(.top, 20)
                    } //ZStack for Popover
                }//VStack to seperate Header and ScreenBody/content
                .background(Color.appBackground.edgesIgnoringSafeArea(.all))
                
                calendarPopover
            }//ZStackforpopover
//        }//ZStack End
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}//Body End

    //MARK: Outsourced components
    var addButton: some View{
    Button(action: {
        if addVM.textIsAppropriate()
            {
            if addVM.addedAthlete.showYear == false {addVM.birthYear = addVM.getBirthYear()}
            
            addVM.saveAthlete()
            presentationMode.wrappedValue.dismiss()
        }
    }){
        HStack{
            Image(systemName: "plus")
                .font(.system(size: 20))
            Text("Add Athlete")
                .font(.headline)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 55)
        .background(addVM.textIsAppropriate() ? Color.accentBigButton : buttonDisabledColor)
        .foregroundColor(addVM.textIsAppropriate() ? Color.white : colorScheme == .light ? Color.white : Color.cardGrey2)
        .cornerRadius(10)
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
}

    var profilePicture: some View {

            ZStack {

                Rectangle()
                    .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                    .foregroundColor(Color.header)
                    .clipShape(Circle())
                    .padding()

                Rectangle()
                    .frame(minWidth: 0, maxWidth: 96, minHeight: 0, maxHeight: 96)
                    .clipShape(Circle())
                    .foregroundColor(colorScheme == .light ? .accentMidGround : .accentBigButton)
                    .padding()

                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 42, height: 42, alignment: .center)
                    .foregroundColor(colorScheme == .light ? .cardGrey2 : .cardProfileLetter)
                

     //       }



                ZStack{
                    Circle()
                        .strokeBorder(Color.header, lineWidth: 1)
                        .background(Circle().foregroundColor(.accentSmallButton))
                        .frame(width: 34, height: 34)
                    Image("AddCameraIcon")
                        .resizable()
                        .frame(width: 17, height: 17, alignment: .center)
                        .foregroundColor(.white)
                    }
                    .offset(x: 40, y: -30)
                }}

    var addAthleteHeader: some View {
        HStack{
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                //NavigationButtonSystemName(iconName: "chevron.backward")
                Image(systemName: "arrow.backward")
                    .resizable()
                    .foregroundColor(.header)
                    .frame(width: 27, height: 20)
            }

            Spacer(minLength: 0)

            Text("Add Athlete")
                .font(.title)
                .foregroundColor(.header)
                .fontWeight(.medium)

            Spacer(minLength: 0)

            Button(action: {
                if addVM.textIsAppropriate() {
                    addVM.saveAthlete()
                    presentationMode.wrappedValue.dismiss()
                }
            }){
                Image(systemName: "checkmark")
                    .resizable()
                    //.font(.headline)
                    .foregroundColor(.header)
                    .frame(width: 26, height: 20)
                    //.offset(y: -3)
                //NavigationButtonSystemName(iconName: "checkmark")
            }//Button
        }//HeaderHStackEnding
        .padding(.horizontal, 22)
        .padding(.top, 15)
}

    var buttonDisabledColor: Color {
        return colorScheme == .light ? .greyTwoColor : .darkModeDisabledButtonColor
}
    
    var calendarPopover: some View {
        ZStack{
            if self.show {
                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { show.toggle() }

                Popover(selectedDate: $addVM.addedAthlete.birthday, show: $show, selectedYear: $addVM.birthYear, showYear: $addVM.addedAthlete.showYear)
                }
            }
            .opacity(self.show ? 1 : 0).animation(.easeIn, value: show)
    }

}//Struct End

    // MARK: Subviews
struct LongTextField: View {

    @Environment(\.colorScheme) var colorScheme
    @State var textFieldDescription: String
    @Binding var firstNameTF: String

    var body: some View {
        VStack{
            //Firstname
            Text(textFieldDescription)
                .font(.body)
                //.foregroundColor(changeOpacity() ? Color.headerText.opacity(0.30) : Color.headerText)
                .foregroundColor(Color.subTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.top, 15)

            TextField("", text: $firstNameTF)
                .autocapitalization(.words)
                .padding(.vertical, 10)
                .padding(.horizontal)
                //.background(colorScheme == .light ? Color.detailWhiteIsh : Color.sheetCard)
                .background(Color.accentMidGround)
                //.foregroundColor(colorScheme == .light ? Color.accentGreen : Color.detailWhiteIsh)
                .foregroundColor(.midTitle)
                .frame(height:44)
                .cornerRadius(10)
                .font(.headline)

                //.textInputAutocapitalization(.words)
        }
        .padding(.horizontal)
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
    
    @Environment(\.colorScheme) var colorScheme

    @Binding var show: Bool

    @Binding var selectedDate: Date

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
                .foregroundColor(Color.subTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)

            ZStack{

                Rectangle()
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.accentMidGround)
                    //.foregroundColor(colorScheme == .light ? Color.accentGreen : Color.detailWhiteIsh)
                    .foregroundColor(.accentMidGround)
                    .frame(height: 44)
                    .cornerRadius(10)
                    



                if self.showYear {
                    Text(String(Calendar.current.component(.year, from: selectedDate)))
                        .font(.body)
                        .foregroundColor(makeClear() ? Color.clear : Color.midTitle)
                        .fontWeight(.semibold)
                }
                else{
                    VStack{
                        Text(dateFormatter.string(from: selectedDate))
                        .font(.body)
                        .foregroundColor(makeClear() ? Color.clear : Color.midTitle)
                        .fontWeight(.semibold)
                    }
//                    .onAppear(perform: selectedYear = Calendar.current.component(.year, from: selectedDate))
                }
            }
            .onTapGesture {
                show.toggle()
            }
            .frame(height: 44)
            .frame(minWidth: 150, idealWidth: 150, maxWidth: 160)
        }
        .padding()
    }

    
    //function to check if the selected date is not today so if another date is selected the birthday header can be grayed out with a tertiary statement in the foregroundcolor modifier
    func changeOpacity() -> Bool {
        if Calendar.current.isDateInToday(selectedDate) {
            return false
        }
        return true
    }

    //function to check if the selected date is not today so the birthdayfield can be clear at the beginning
    func makeClear() -> Bool {
        if Calendar.current.isDateInToday(selectedDate) {
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
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View{
        VStack(alignment: .leading){
            //Gender
            Text("Gender")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(Color.subTitle)
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
                        if male {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.accentBigButton.opacity(0.3), lineWidth: 1.0)
                                .frame(width: 44, height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.accentSmallButton)
                                )
                                
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 44, height: 44)
                                .foregroundColor(Color.accentMidGround)
                        }
                      
                        Image("MaleIcon")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundColor(male ? Color.white: colorScheme == .light ? Color.detailGray2 : Color.cardGrey1)
                    }
                }

                Button(action: {
                    gender = "female"
                    female.toggle()
                    male = false
                    nonbinary = false
                }) {
                    ZStack {
                        if female {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.accentBigButton.opacity(0.3), lineWidth: 1.0)
                                .frame(width: 44, height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.accentSmallButton)
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 44, height: 44)
                                .foregroundColor(Color.accentMidGround)
                        }
                      
                        Image("FemaleIcon")
                            .resizable()
                            .frame(width: 15, height: 23.1)
                            .foregroundColor(female ? Color.white: colorScheme == .light ? Color.detailGray2 : Color.cardGrey1)
                    }
                }

                Button(action: {
                    gender = "nonbinary"
                    nonbinary.toggle()
                    male = false
                    female = false
                }) {
                    ZStack {
                        if nonbinary {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.accentBigButton.opacity(0.3), lineWidth: 1.0)
                                .frame(width: 44, height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.accentSmallButton)
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 44, height: 44)
                                .foregroundColor(Color.accentMidGround)
                        }
                      
                        Image("NonBinaryIcon")
                            .foregroundColor(nonbinary ? Color.white: colorScheme == .light ? Color.detailGray2 : Color.cardGrey1)
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

struct Popover: View {
    @Binding var selectedDate: Date
    @Binding var show: Bool
    @State var currentYear = Calendar.current.component(.year, from: Date())
    @Binding var selectedYear : Int
    @Binding var showYear: Bool
    @Environment(\.colorScheme) var colorScheme

    @State var year: Int

    let endingDate: Date = Date()


    init(selectedDate: Binding<Date>, show: Binding<Bool>, selectedYear: Binding<Int>, showYear: Binding<Bool>) {
        self._selectedDate = selectedDate
        self._show = show
        self._selectedYear = selectedYear
        self._showYear = showYear
        let startYear = Calendar.current.component(.year, from: selectedDate.wrappedValue)
        self._year = State<Int>(initialValue: startYear)

    }


    func adjustYear(year: Int, date: Date) -> Date {
        var j = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: selectedDate)
        j.year = year
        selectedDate = Calendar.current.date(from: j) ?? selectedDate
        return selectedDate
    }



    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(colorScheme == .light ? .appBackground : .accentMidGround)
                .frame(maxWidth: .infinity)
                .frame(height: 425, alignment: .center)
                .padding(.horizontal)

            VStack(alignment: .leading ,spacing: 10) {

                if self.showYear {
                    Picker("", selection: $year) {
                        ForEach(currentYear-100...currentYear, id: \.self) {
                                    Text(String($0))
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                            .labelsHidden()
                            .padding(.horizontal, 20)
                            .frame(height: 300)
                            .onAppear{
                                year = Calendar.current.component(.year, from: selectedDate)
                            }

                } else {
                    DatePicker("", selection: $selectedDate, in: ...endingDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .colorScheme(colorScheme == .light ? .light : .dark)
                        .accentColor(.accentSmallButton)
                        .labelsHidden()
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                        .frame(height: 300)
                        .onAppear{
                            selectedDate = adjustYear(year: year, date: selectedDate)
                        }
                }

                    Toggle(
                        isOn: $showYear,
                        label: {
                            Text("Select year of birth only")
                                   .font(.body)
                                   .fontWeight(.semibold)
                                    .foregroundColor(Color.header)
                        })
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        .toggleStyle(SwitchToggleStyle(tint: Color.accentSmallButton))

                HStack{
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                    Text("Add now")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40)
                .background(Color.accentSmallButton)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 25)
                .onTapGesture {
                    if self.showYear {
                    selectedDate = adjustYear(year: year, date: selectedDate)

                        show.toggle()
                    } else {

                        show.toggle()
                    }
                }
            }
        }
    }
}



    //MARK: Notes
///*
//1. on iphone se the keyboard covers the last name text field...move it up somehow?
// ->
//https://stackoverflow.com/questions/56491881/move-textfield-up-when-the-keyboard-has-appeared-in-swiftui
//
//2.Capitailze first letter of name for good
// ->
// https://stackoverflow.com/questions/34558515/trying-to-capitalize-the-first-letter-of-each-word-in-a-text-field-using-swift#34558603
//
// */
