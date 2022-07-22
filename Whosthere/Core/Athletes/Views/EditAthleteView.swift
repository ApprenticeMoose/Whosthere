//
//  EditAthleteView.swift
//  Whosthere
//
//  Created by Moose on 02.02.22.
//

import SwiftUI

//MARK: LoadingView for Lazy Loading of EditView below


struct EditAthleteView: View {

//MARK: -Properties

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc

    //@EnvironmentObject var athletesViewModel: AthletesViewModel
    @ObservedObject var editVM: EditAthleteViewModel


    //Variables
    let athlete: Athlete
    

    


    @State var male = false
    @State var female = false
    @State var nonbinary = false


    init(athlete: Athlete) {
        self.athlete = athlete
        self.editVM = EditAthleteViewModel(athlete)

        if editVM.gender.contains("male") {
            self._male = State(wrappedValue: true)
           print("male is included")
        } else if editVM.gender.contains("female") {
            self._female = State(wrappedValue: true)
        } else if editVM.gender.contains("nonbinary") {
            self._nonbinary = State(wrappedValue: true)
        }
        print("Initializing Edit View for: \(String(describing: athlete.firstName))")
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemBlue
    }

    //Toggle
    @State var show: Bool = false
    @State var toggleIsOn: Bool = false
    @State var showPrompt: Bool = false
    @State var buttonFarbe : Color = .orangeAccentColor
    @State var showAlert: Bool = false


//MARK: -Body

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

                            LongTextField(textFieldDescription: "First Name",  firstNameTF: $editVM.firstName)

                            LongTextField(textFieldDescription: "Last Name", firstNameTF: $editVM.lastName)

                            HStack {
                                BirthdayField(show: $show, selectedDate: $editVM.birthDate, /*selectedYear: $editVM.birthYear,*/ showYear: $editVM.showYear)
                                EditGenderButtons(gender: $editVM.gender, male: $male, female: $female, nonbinary: $nonbinary)
                            }

                            Spacer()
                            Spacer()

                            archiveButton
                            deleteButton

    //Spacer to define the body-sheets size
    //                     Spacer().frame(maxWidth: .infinity)

                            Spacer(minLength: 25)

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

                        Popover(selectedDate: $editVM.birthDate.bound, show: $show, selectedYear: $editVM.birthYear, showYear: $editVM.showYear)

                        }
                    }
                .opacity(self.show ? 1 : 0).animation(.easeIn, value: show)

                }//ZStackforpopover
            }//ZStack End
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }//Body End

    
    //MARK: -Functions
    //-MARK: Insert Core Data here
    func editAthlete(athlete: Athlete) {
        athlete.id = editVM.id
        athlete.firstName = editVM.firstName
        athlete.lastName = editVM.lastName
        athlete.birthday = editVM.birthDate
        athlete.gender = editVM.gender
        athlete.showYear = editVM.showYear

        try? moc.save()

        presentationMode.wrappedValue.dismiss()
    }
    
    func deleteAthletePressed(athlete: Athlete) {
        
        
        moc.delete(athlete)
        
        try? moc.save()
        
        presentationMode.wrappedValue.dismiss()

            }
        
    
    //MARK: -Outsourced Components

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
            editAthlete(athlete: athlete)
        }){
            NavigationButtonSystemName(iconName: "checkmark")
        }//Button
        
    }//HeaderHStackEnding
    .padding()
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
    
    var archiveButton: some View{
    
    VStack{
        Button(action: {
            //add archive function
        }){
            HStack{
                HStack{
                    Image(systemName: "archivebox")
                        .font(.system(size: 20))
                        .padding(.horizontal, 5)
                    Text("Archive")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40)
            .background(Color.middlegroundColor)
            .foregroundColor(.blue)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}
    
    var deleteButton: some View{
        
        VStack{
            Button(action: {
                showAlert.toggle()
            }){
                HStack{
                    HStack{
                        Image(systemName: "trash")
                            .font(.system(size: 20))
                            .padding(.horizontal, 5)
                        Text("Delete")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40)
                .background(Color.middlegroundColor)
                .foregroundColor(.red)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Are you sure you want to delete this profile?"),
                          message: Text("This action cannot be undone!"),
                          primaryButton: .destructive(Text("Delete"),
                          action: {
                            deleteAthletePressed(athlete: athlete)
                        }),
                          secondaryButton: .cancel())
                    })
                }
                .frame(maxWidth: .infinity, alignment: .bottom)
            }
}

    struct EditGenderButtons: View {

@Binding var gender : String
@Binding var male : Bool
@Binding var female : Bool
@Binding var nonbinary : Bool




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
        if  male || female || nonbinary == true { return true }
        return false
    }
}
    
    struct Popover: View {
        @Binding var selectedDate: Date
        //@Binding var toggleIsOn: Bool
        @Binding var show: Bool
        @State var currentYear = Calendar.current.component(.year, from: Date())
        @Binding var selectedYear : Int
        @Binding var showYear: Bool
      
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
        
//        func checkIfDateChangend(date: Date) -> Bool {
//            if date != Date() {
//                noYear = false
//            }
//            return noYear
//        }
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.middlegroundColor)
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
                            .accentColor(.orangeAccentColor)
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
}
