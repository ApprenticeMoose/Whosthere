//
//  EditAthleteView.swift
//  Whosthere
//
//  Created by Moose on 02.02.22.
//
import SwiftUI
import CoreData
import NavigationBackport


struct EditAthleteView: View {

//MARK: -Properties
    @Environment(\.presentationMode) var presentationMode                           //For dismissing views
    @Environment(\.colorScheme) var colorScheme                                     //DarkMode
 
    @ObservedObject var editVM: EditAthleteVM                                       //Accessing the variables for editing
    @EnvironmentObject var appState: AppState                                       //For Navigation
    @EnvironmentObject var tabDetail: TabDetailVM                                   //For TabBar hiding
    
    let goBackToRoot: () -> Void                                                    //For pop to root
    @State var male = false                                                         //For triggering the gender Buttons
    @State var female = false
    @State var nonbinary = false


    init(athlete: Athlete?, dataManager: DataManager = DataManager.shared, goBackToRoot: @escaping () -> Void) {
        self.goBackToRoot = goBackToRoot
//        self.context = context
//        self.athlete = athlete
        
        self.editVM = EditAthleteVM(athlete: athlete, dataManager: dataManager)
        
        if editVM.addedAthlete.gender == "male" {
            self._male = State(wrappedValue: true)
        } else if editVM.addedAthlete.gender == "female" {
            self._female = State(wrappedValue: true)
        } else if editVM.addedAthlete.gender == "nonbinary" {
            self._nonbinary = State(wrappedValue: true)
        }
        print("Initializing Edit View for: \(String(describing: athlete?.firstName))")
    }

    //Toggle
    @State var show: Bool = false                                               //Bool for showing Birthdaypicker
    @State var buttonFarbe : Color = .accentGold                                //Color for Button
    @State var showAlert: Bool = false                                          //Bool for Delete Alert

//MARK: -Body
    var body: some View {

        GeometryReader { _ in                               //GeometryReader so the View doesnt move uppwards once the keyboard is actived
//            ZStack{
//
//            Color.accentColor.edgesIgnoringSafeArea(.all)
            ZStack{
                VStack{
                    //header
                    editAthleteHeader

                    ZStack {
                        VStack(spacing: 0) {
                            //all that is in the screen body
                            profilePicture
                            

                            LongTextField(textFieldDescription: "First Name",  firstNameTF: $editVM.addedAthlete.firstName)

//                            Spacer()
//                                .frame(minHeight: 0, idealHeight: 40, maxHeight: 50)
                            
                            LongTextField(textFieldDescription: "Last Name", firstNameTF: $editVM.addedAthlete.lastName)
                            
//                            Spacer()
//                                .frame(minHeight: 0, idealHeight: 40, maxHeight: 50)
                            HStack {
                                BirthdayField(show: $show, selectedDate: $editVM.addedAthlete.birthday, showYear: $editVM.addedAthlete.showYear)
                                Spacer(minLength: 30)
                                
                                    //.frame(minWidth: 20 , idealWidth: 30, maxWidth: 60)
                                EditGenderButtons(gender: $editVM.addedAthlete.gender, male: $male, female: $female, nonbinary: $nonbinary)
                            }

                            Spacer()
                                .frame(minHeight: 0, idealHeight: 50, maxHeight: 60)
                    
                            
                            Spacer()
                            
                            HStack{
                            archiveButton
                                Spacer()
                            deleteButton
                            }

                            //Spacer(minLength: 25)
                            Rectangle()
                                .frame(height: 12)
                                .foregroundColor(.clear)

                        }
                        .padding(.top, 20)
                        

                    } //ZStack for Popover
                }//VStack to seperate Header and ScreenBody/content
                .background(Color.appBackground
                               // .clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 20))
                            .edgesIgnoringSafeArea(.all))
                ZStack{
                    if self.show {
                        
                        Color.black
                            .opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture { show.toggle() }

                        Popover(selectedDate: $editVM.addedAthlete.birthday, show: $show, selectedYear: $editVM.birthYear, showYear: $editVM.addedAthlete.showYear)
                            .onChange(of: editVM.addedAthlete.birthday) { _ in
                                print(editVM.addedAthlete.birthday)
                            }
                        }
                    }
                .opacity(self.show ? 1 : 0).animation(.easeIn, value: show)

                }//ZStackforpopover
            //}//ZStack End
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }//Body End
    
    //MARK: -Functions
    
    func deleteAthletePressed() {
        editVM.deleteAthlete()
        //withAnimation(.spring(dampingFraction: 1.0)){
        tabDetail.showDetail = false
        //}
        goBackToRoot()

            }
        
    
    //MARK: -Outsourced Components
    var editAthleteHeader: some View {
    
    HStack{

        Button(action: {
            appState.path.removeLast()
        }){
            //NavigationButtonSystemName(iconName: "chevron.backward")
            Image(systemName: "arrow.backward")
                .resizable()
                .foregroundColor(.header)
                .frame(width: 27, height: 20)
        }

        Spacer(minLength: 0)

        Text("Edit Athlete")
            .font(.title)
            .foregroundColor(.header)
            .fontWeight(.medium)

        Spacer(minLength: 0)

        Button(action: {
            editVM.saveAthlete()
            appState.path.removeLast()
        }){
            //NavigationButtonSystemName(iconName: "checkmark")
            Image(systemName: "checkmark")
                .resizable()
                .foregroundColor(.header)
                .frame(width: 26, height: 20)
        }//Button
        
    }//HeaderHStackEnding
    .padding()
}
    
    var profilePicture: some View {
    
    ZStack {
        ZStack {
            Rectangle()
                .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                .foregroundColor(Color.header)
                .clipShape(Circle())
                //.padding()
            
            Rectangle()
                .frame(minWidth: 0, maxWidth: 96, minHeight: 0, maxHeight: 96)
                .clipShape(Circle())
                .foregroundColor(colorScheme == .light ? .accentMidGround : .accentBigButton)
                //.padding()
            
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 42, height: 42, alignment: .center)
                .foregroundColor(colorScheme == .light ? .cardGrey2 : .cardProfileLetter)
        }
        
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
        }
    .padding(8)
}
    
    var archiveButton: some View{
    
    VStack{
        Button(action: {
            //add archive function
        }){
            HStack{
                //HStack{
                    Image(systemName: "archivebox")
                        .font(.system(size: 20))
                        .padding(.horizontal, 5)
//                    Text("Archive")
//                        .font(.headline)
//                }
//                .padding(.horizontal)
//
//                Spacer()
            }
            .frame(width: 44, height: 44)
            .background(Color.accentMidGround)
            .foregroundColor(Color.midTitle.opacity(0.8))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        //.frame(maxWidth: .infinity, alignment: .bottom)
    }
}
    
    var deleteButton: some View{
        
        VStack{
            Button(action: {
                showAlert.toggle()
            }){
                HStack{
//                    HStack{
                        Image(systemName: "trash")
                            .font(.system(size: 20))
                            .padding(.horizontal, 5)
//                        Text("Delete")
//                            .font(.headline)
//                    }
//                    .padding(.horizontal)
                    
//                    Spacer()
                }
                .frame(width: 44, height: 44)
                .background(Color.accentMidGround)
                .foregroundColor(Color.red)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Are you sure you want to delete this profile?\nAll references from sessions will be removed"),
                          message: Text("This action cannot be undone!"),
                          primaryButton: .destructive(Text("Delete"),
                          action: {
                           deleteAthletePressed()
                        }),
                          secondaryButton: .cancel())
                    })
                }
            }
}

struct EditGenderButtons: View {

@Binding var gender : String
@Binding var male : Bool
@Binding var female : Bool
@Binding var nonbinary : Bool

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
    .padding(.vertical)
    //.padding(.leading)
}

func changeOpacity() -> Bool {
        if  male || female || nonbinary == true { return true }
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
                                        .foregroundColor(Color.textColor)
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
}
