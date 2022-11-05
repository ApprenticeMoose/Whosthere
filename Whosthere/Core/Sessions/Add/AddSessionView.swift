//
//  AddSessionView.swift
//  Whosthere
//
//  Created by Moose on 30.08.22.
//
import SwiftUI

struct AddSessionView: View {
        
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var todayIsSelected = true
    @State var tomorrowIsSelected = false
    
    @State var showTimePicker: Bool = false
    @State var showDatePicker: Bool = false
    @State var showAddAthleteSheet: Bool = false
        
    @ObservedObject var addSessionVM: AddSessionVM
    @ObservedObject var datesVM: DatesVM
    
    let preference = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
        
    var athletesToCheck: [Athlete] {
        switch datesVM.station.sortAthletes {
       case .firstNameFromA:
            return addSessionVM.athletes.sorted(by: {$0.firstName < $1.firstName } )
       case .firstNameFromZ:
            return addSessionVM.athletes.sorted(by: {$0.firstName > $1.firstName } )
       case .genderFemaleFirst:
            return addSessionVM.athletes.sorted(by: {$0.gender > $1.gender } )
       case .genderMaleFirst:
            return addSessionVM.athletes.sorted(by: {$0.gender < $1.gender } )
       case .dateAddedFromOldest:
            return addSessionVM.athletes.sorted(by: {$0.dateAdded < $1.dateAdded } )
       case .dateAddedFromNewest:
            return addSessionVM.athletes.sorted(by: {$0.dateAdded > $1.dateAdded } )
       
       }
   }
    
    init(dataManager: DataManager = DataManager.shared) {
        self.addSessionVM = AddSessionVM(dataManager: dataManager)
        self.datesVM = DatesVM()
    }

    var body: some View {
        ZStack{
            GeometryReader { geometry in
            ScrollView{
                VStack{
                    addSessionHeader
            
                    time
                
                //VStack (alignment: .leading, spacing: 0){
                    
                    date
                        
                    athletes
                        
                    Spacer()
                    
                    addSessionButton
                        
                //}//VStack
                    
                }.frame(minHeight: geometry.size.height)
            }.frame(width: geometry.size.width)
                
                
                    timePicker
                    .opacity(self.showTimePicker ? 1 : 0).animation(.easeIn, value: showTimePicker)
                    
                    datePicker
                    .opacity(self.showDatePicker ? 1 : 0).animation(.easeIn, value: showDatePicker)
            }
        }
    }
    
    func getInitials(firstName: String, lastName: String) -> String {
        let firstLetter = firstName.first?.uppercased() ?? ""
        let lastLetter = lastName.first?.uppercased() ?? ""
        return firstLetter + lastLetter
    }
    
    var addSessionHeader: some View {
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
            
            Text("Add Session")
                .font(.title)
                .foregroundColor(.header)
                .fontWeight(.medium)
            
            Spacer(minLength: 0)
            
            Button(action: {
                addSessionVM.saveSession()
                datesVM.scrollToIndexOfSessions = datesVM.extractDateWithoutTime(date: addSessionVM.sessionDate)
                presentationMode.wrappedValue.dismiss()
                
            }){
                Image(systemName: "checkmark")
                    .resizable()
                    .foregroundColor(.header)
                    .frame(width: 26, height: 20)
            }//Button
        }//HeaderHStackEnding
        .padding(.horizontal, 22)
        .padding(.top, 15)
    }
    
    var addSessionButton: some View{
    Button(action: {
        addSessionVM.saveSession()
        datesVM.scrollToIndexOfSessions = datesVM.extractDateWithoutTime(date: addSessionVM.sessionDate)
        presentationMode.wrappedValue.dismiss()
        }) {
        HStack{
            Image(systemName: "plus")
                .font(.system(size: 20))
            Text("Add Session")
                .font(.headline)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
        .background(Color.accentBigButton)
        .foregroundColor(Color.white)
        .cornerRadius(10)
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
    }
    
    var time: some View {
        VStack (alignment: .leading, spacing: 0){
            
            Text("Time")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal, 30)
                .offset(y: 6)
            
            
            HStack{
                
                
                ZStack {
                    
                    
                    Rectangle()
                        .background(Color.accentMidGround)
                        .foregroundColor(.accentMidGround)
                        .frame(width: 105, height: 40)
                        .cornerRadius(10)
                    
                    
                    Text("\(datesVM.extractDate(date: datesVM.roundMinutesDown(date: addSessionVM.sessionTime), format: "HH:mm"))")
                    //.font(.title3)
                        .fontWeight(.semibold)
                    
                    
                    
                }
                
                .onTapGesture {
                    //show time selection
                    showTimePicker.toggle()
                }
                
                //ZStack that has padding but is clear so it is just for view formatting
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 105, height: 40)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 8)
                //ZStack for View formatting
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 105, height: 40)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding(.top)
    }
    
    var date: some View {
     VStack (alignment: .leading, spacing: 0){
     Text("Date")
         .font(.title3)
         .fontWeight(.semibold)
         .padding(.horizontal, 30)
         .offset(y: 6)
     
     
     HStack{
         
         
         ZStack {
             if todayIsSelected {
                 RoundedRectangle(cornerRadius: 10)
                     .stroke(Color.accentBigButton.opacity(0.3), lineWidth: 1.0)
                     .frame(width: 105, height: 40)
                     .background(
                         RoundedRectangle(cornerRadius: 10)
                             .fill(Color.accentSmallButton)
                     )
             } else {
                 RoundedRectangle(cornerRadius: 10)
                     .foregroundColor(.accentMidGround)
                     .frame(width: 105, height: 40)
             }
             
             
             Text("Today")
                 .fontWeight(.semibold)
                 .foregroundColor(todayIsSelected ? Color.white: colorScheme == .light ? Color.detailGray2 : Color.cardGrey1)
         }
         
         .onTapGesture {
             //show time selection
             addSessionVM.sessionDate = Date()
             todayIsSelected = true
             tomorrowIsSelected = false
         }
         
         
         ZStack {
             if tomorrowIsSelected {
                 RoundedRectangle(cornerRadius: 10)
                     .stroke(Color.accentBigButton.opacity(0.3), lineWidth: 1.0)
                     .frame(width: 105, height: 40)
                     .background(
                         RoundedRectangle(cornerRadius: 10)
                             .fill(Color.accentSmallButton)
                     )
             } else {
                 RoundedRectangle(cornerRadius: 10)
                     .foregroundColor(.accentMidGround)
                     .frame(width: 105, height: 40)
             }
             
             Text("Tomorrow")
                 .fontWeight(.semibold)
                 .foregroundColor(tomorrowIsSelected ? Color.white: colorScheme == .light ? Color.detailGray2 : Color.cardGrey1)
         }
         .padding(.horizontal, 8)
         .onTapGesture {
             //show time selection
             addSessionVM.sessionDate = datesVM.setDateToTomorrow()
             todayIsSelected = false
             tomorrowIsSelected = true
         }
         
         ZStack {
             Rectangle()
             //                        .padding(.vertical, 10)
             //                        .padding(.horizontal)
                 .background(Color.accentMidGround)
                 .foregroundColor(.accentMidGround)
                 .frame(width: 105, height: 40)
                 .cornerRadius(10)
             
             Text("\(datesVM.extractDate(date: addSessionVM.sessionDate, format: "dd. MMM"))")
                 .fontWeight(.semibold)
         }
         //.padding()
         .onTapGesture {
             //show time selection
             showDatePicker.toggle()
         }
         
     }
     .padding()
 }
    }
    
    var athletes: some View {
        VStack (alignment: .leading, spacing: 0){
            
            Text("Athletes")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal, 30)
                .offset(y: 6)

            
            VStack {
                        LazyVGrid(columns: preference, spacing: 16) {
                            
//                            let enumerated = Array(zip(addSessionVM.athletes.indices, addSessionVM.athletes))
                            //ForEach(enumerated, id: \.1) { index, athlete in
                                ForEach(athletesToCheck, id: \.self) { athlete in

                                VStack{
                                    ZStack{
                                    ZStack{
                                        Circle()
                                            .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                            .frame(height: 45)
                                        Text(getInitials(firstName: athlete.firstName, lastName: athlete.lastName))
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.cardProfileLetter)
                                    }
                                    .opacity(addSessionVM.selectedAthletes.contains(athlete.id) ? 0.3 : 1.0)
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .foregroundColor(.midTitle)
                                            .frame(width: 21, height: 16, alignment: .center)
                                            .opacity(addSessionVM.selectedAthletes.contains(athlete.id) ? 1.0 : 0.0)
                                    }
                                   
                                    
                                    Text("\(athlete.firstName)")
                                        .font(.caption)
                                        .foregroundColor(.cardText)
                                        .opacity(addSessionVM.selectedAthletes.contains(athlete.id) ? 0.5 : 1.0)
                                }
                                .onTapGesture {
                                    if addSessionVM.selectedAthletes.contains(athlete.id) {
                                        addSessionVM.selectedAthletes.remove(athlete.id)
                                     } else {
                                         addSessionVM.selectedAthletes.insert(athlete.id)
                                     }
                                    addSessionVM.toggleAthlete(athlete: athlete)
                                }

                            }
                            Button {
                                //add athlete
                                showAddAthleteSheet.toggle()
                            } label: {
                                VStack{
                                    
                                    ZStack{
                                        Circle()
                                            .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                            .frame(height: 45)
                                        Image(systemName: "person.badge.plus")
                                            .font(.system(size: 20))
                                            .font(.caption2)
                                            .foregroundColor(.cardProfileLetter)
                                            .offset(x: 1)
                                    }
                                    
                                    Text("Add")
                                        .font(.caption)
                                        .foregroundColor(.cardText)
                                }
                                .fullScreenCover(isPresented: $showAddAthleteSheet, content: {
                                    AddAthleteView()
                                })
                          }
                        }
                    }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.accentMidGround))
            .padding()

        }
        .padding(.top)
    }
    
    var timePicker: some View {
        ZStack{
            if self.showTimePicker {
                
                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showTimePicker.toggle() }
                ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(colorScheme == .light ? .appBackground : .accentMidGround)
                    .frame(maxWidth: 250)
                    .frame(height: 220, alignment: .center)
                    .padding(.horizontal)
                    MyTimePicker(selection: $addSessionVM.sessionTime, minuteInterval: 5, displayedComponents: .hourAndMinute)
                        .frame(maxWidth: 250)
                        .frame(height: 220, alignment: .center)
                }
            }
        }
    }
    
    var datePicker: some View {
        ZStack{
            if self.showDatePicker {
                
                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showDatePicker.toggle() }
                
                   DateSeläctör(selectedDate: $addSessionVM.sessionDate)
                    .onChange(of: addSessionVM.sessionDate) { date in
                        if Calendar.current.isDateInToday(date) {
                            todayIsSelected = true
                            tomorrowIsSelected = false
                        } else if Calendar.current.isDateInTomorrow(date) {
                            todayIsSelected = false
                            tomorrowIsSelected = true
                        } else {
                            todayIsSelected = false
                            tomorrowIsSelected = false
                        }

                    }
                    }
            }
    }
}


struct TimePicker: View {
    @Binding var selectedTime: Date
    @Environment(\.colorScheme) var colorScheme
        
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(colorScheme == .light ? .appBackground : .accentMidGround)
                .frame(maxWidth: 250)
                .frame(height: 220, alignment: .center)
                .padding(.horizontal)
            
            VStack(alignment: .leading ,spacing: 10) {
                
                
                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .colorScheme(colorScheme == .light ? .light : .dark)
                    .accentColor(.accentSmallButton)
                    .labelsHidden()
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .frame(height: 300)
                    
                
            }
        }
    }
}

struct MyTimePicker: UIViewRepresentable {

    @Binding var selection: Date
    let minuteInterval: Int
    let displayedComponents: DatePickerComponents

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<MyTimePicker>) -> UIDatePicker {
        let picker = UIDatePicker()
        
        // listen to changes coming from the date picker, and use them to update the state variable
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged), for: .valueChanged)
        picker.preferredDatePickerStyle = .wheels
        return picker
    }

    func updateUIView(_ picker: UIDatePicker, context: UIViewRepresentableContext<MyTimePicker>) {
        picker.minuteInterval = minuteInterval
        picker.date = selection

        switch displayedComponents {
        case .hourAndMinute:
            picker.datePickerMode = .time
        case .date:
            picker.datePickerMode = .date
        case [.hourAndMinute, .date]:
            picker.datePickerMode = .dateAndTime
        default:
            break
        }
    }

    class Coordinator {
        let datePicker: MyTimePicker
        init(_ datePicker: MyTimePicker) {
            self.datePicker = datePicker
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            datePicker.selection = sender.date
        }
    }
}


struct DateSeläctör: View {
    @Binding var selectedDate: Date
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(colorScheme == .light ? .appBackground : .accentMidGround)
                .frame(maxWidth: .infinity)
                .frame(height: 315, alignment: .center)
                .padding(.horizontal)
            
            VStack(alignment: .leading ,spacing: 10) {
                
                
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .colorScheme(colorScheme == .light ? .light : .dark)
                    .accentColor(.accentSmallButton)
                    .labelsHidden()
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .frame(height: 300)
                
            }
        }
    }
}



//struct AddSessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddSessionView(vm: AthletesListViewModel(context: NSManagedObjectContext))
//    }
//}
