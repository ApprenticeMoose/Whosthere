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
    @Binding var showDetailView: Bool

    var body: some View {
        ZStack{
            if let athlete = athlete {
                EditAthleteView(athlete: athlete, showDetailView: $showDetailView)
            }
        }
    }
}

struct EditAthleteView: View {

//MARK: -Properties

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var athletesViewModel: AthletesViewModel
    @ObservedObject var editVM: EditAthleteViewModel


    //Variables
    let athlete: AthletesModel
    
    //Passing this varible in from the athleteslistview so Edit & Detai View can be dismissed simultaniously when athletes deleted and user returns to the list view
    @Binding var showDetailView: Bool


    @State var male = false
    @State var female = false
    @State var nonbinary = false


    init(athlete: AthletesModel, showDetailView: Binding<Bool>) {
        self.athlete = athlete
        self._showDetailView = showDetailView
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
                                BirthdayField(show: $show, selectedDate: $editVM.birthDate, toggleIsOn: $toggleIsOn, selectedYear: $editVM.birthYear)
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

                        Popover(selectedDate: $editVM.birthDate, toggleIsOn: $toggleIsOn, show: $show, selectedYear: $editVM.birthYear)

                        }
                    }
                    .opacity(self.show ? 1 : 0).animation(.easeIn)

                }//ZStackforpopover
            }//ZStack End
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }//Body End

    
    //MARK: -Functions
    
    func editAthlete() {
        let athlete = AthletesModel(id: editVM.id, firstName: editVM.firstName, lastName: editVM.lastName, birthday: editVM.birthDate, birthyear: editVM.birthYear, gender: editVM.gender)
        athletesViewModel.updateAthlete.send(athlete)
        presentationMode.wrappedValue.dismiss()
    }
    
    func deleteAthletePressed(athlete: AthletesModel) {
        
        athletesViewModel.deleteAthlete.send(athlete)
            
        //to double dismiss and get back to ListView
        DispatchQueue.main.async {
            showDetailView = false
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
              }
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
            editAthlete()
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
    
}
