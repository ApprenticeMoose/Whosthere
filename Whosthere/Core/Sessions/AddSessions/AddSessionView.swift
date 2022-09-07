////
////  AddSessionView.swift
////  Whosthere
////
////  Created by Moose on 30.08.22.
////
//
//import SwiftUI
//
//struct AddSessionView: View {
//    
//    //var type: DatePickerComponents? = .date
//    
//    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.colorScheme) var colorScheme
//    
//    @State var todayIsSelected = true
//    @State var tomorrowIsSelected = false
//    
////    @State var selectedTime = Date()
////    @State var selectedDate = Date()
//    
//    //@State var isSelected = false
//    //@State private var selectedIndices = Set<Int>()
//    
//    @State var showTimePicker: Bool = false
//    @State var showDatePicker: Bool = false
//    
//    @ObservedObject private var athletesListVM: AthletesListViewModel
//    @Environment(\.managedObjectContext) var viewContext
//    
//    @ObservedObject var addSessionVM: AddSessionViewModel
//    
//    @ObservedObject var datesVM: DatesViewModel
//    
//        let preference = [
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible())
//        ]
//    
//    func getInitials(firstName: String, lastName: String) -> String {
//        let firstLetter = firstName.first?.uppercased() ?? ""
//        let lastLetter = lastName.first?.uppercased() ?? ""
//        return firstLetter + lastLetter
//    }
//    
//    init(vmA: AthletesListViewModel, vmS: AddSessionViewModel){
//        self.datesVM = DatesViewModel()
//        self.athletesListVM = vmA
//        self.addSessionVM = vmS
//    }
//
//    var body: some View {
//        ZStack{
//            ScrollView{
//                addSessionHeader
//                
//          //Time
//                VStack (alignment: .leading, spacing: 0){
//                    
//                    Text("Time")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                        .padding(.horizontal, 30)
//                        .offset(y: 6)
//                    
//                    
//                    HStack{
//                        
//                        
//                        ZStack {
//                            
//                            
//                            Rectangle()
//                                .background(Color.accentMidGround)
//                                .foregroundColor(.accentMidGround)
//                                .frame(width: 105, height: 40)
//                                .cornerRadius(10)
//                            
//                            
//                            Text("\(datesVM.extractDate(date: datesVM.roundMinutesDown(date: addSessionVM.sessionTime), format: "HH:mm"))")
//                            //.font(.title3)
//                                .fontWeight(.semibold)
//                            
//                            
//                            
//                        }
//                        
//                        .onTapGesture {
//                            //show time selection
//                            showTimePicker.toggle()
//                        }
//                        
//                        //ZStack that has padding but is clear so it is just for view formatting
//                        ZStack {
//                            Rectangle()
//                                .foregroundColor(.clear)
//                                .frame(width: 105, height: 40)
//                                .cornerRadius(10)
//                        }
//                        .padding(.horizontal, 8)
//                        //ZStack for View formatting
//                        ZStack {
//                            Rectangle()
//                                .foregroundColor(.clear)
//                                .frame(width: 105, height: 40)
//                                .cornerRadius(10)
//                        }
//                    }
//                    .padding()
//                }
//                .padding(.top)
//                
//       //Date
//                VStack (alignment: .leading, spacing: 0){
//                    
//                    Text("Date")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                        .padding(.horizontal, 30)
//                        .offset(y: 6)
//                    
//                    
//                    HStack{
//                        
//                        
//                        ZStack {
//                            if todayIsSelected {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.accentBigButton.opacity(0.3), lineWidth: 1.0)
//                                    .frame(width: 105, height: 40)
//                                    .background(
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .fill(Color.accentSmallButton)
//                                    )
//                            } else {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .foregroundColor(.accentMidGround)
//                                    .frame(width: 105, height: 40)
//                            }
//                            
//                            
//                            Text("Today")
//                                .fontWeight(.semibold)
//                                .foregroundColor(todayIsSelected ? Color.white: colorScheme == .light ? Color.detailGray2 : Color.cardGrey1)
//                        }
//                        
//                        .onTapGesture {
//                            //show time selection
//                            addSessionVM.sessionDate = Date()
//                            todayIsSelected = true
//                            tomorrowIsSelected = false
//                        }
//                        
//                        
//                        ZStack {
//                            if tomorrowIsSelected {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.accentBigButton.opacity(0.3), lineWidth: 1.0)
//                                    .frame(width: 105, height: 40)
//                                    .background(
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .fill(Color.accentSmallButton)
//                                    )
//                            } else {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .foregroundColor(.accentMidGround)
//                                    .frame(width: 105, height: 40)
//                            }
//                            
//                            Text("Tomorrow")
//                                .fontWeight(.semibold)
//                                .foregroundColor(tomorrowIsSelected ? Color.white: colorScheme == .light ? Color.detailGray2 : Color.cardGrey1)
//                        }
//                        .padding(.horizontal, 8)
//                        .onTapGesture {
//                            //show time selection
//                            addSessionVM.sessionDate = datesVM.setDateToTomorrow()
//                            todayIsSelected = false
//                            tomorrowIsSelected = true
//                        }
//                        
//                        ZStack {
//                            Rectangle()
//                            //                        .padding(.vertical, 10)
//                            //                        .padding(.horizontal)
//                                .background(Color.accentMidGround)
//                                .foregroundColor(.accentMidGround)
//                                .frame(width: 105, height: 40)
//                                .cornerRadius(10)
//                            
//                            Text("\(datesVM.extractDate(date: addSessionVM.sessionDate, format: "dd. MMM"))")
//                                .fontWeight(.semibold)
//                        }
//                        //.padding()
//                        .onTapGesture {
//                            //show time selection
//                            showDatePicker.toggle()
//                        }
//                        
//                    }
//                    .padding()
//                    
//                    
//        //Athletes
//                    
//                    VStack (alignment: .leading, spacing: 0){
//                        
//                        Text("Athletes")
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                            .padding(.horizontal, 30)
//                            .offset(y: 6)
//                        
//                        
//                        //HStack{
//                            
//                        
////                        LazyVGrid(columns: columns, alignment: .center) {
////                            ForEach(0..<10) { index in
////                                VStack{
////                                    Circle()
////                                        .frame(height: 45)
////                                    Text("Athlete \(index)")
////                                }
////                            }
////                        }
////                        .padding()
////                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
////                        .padding()
//                        
//                        VStack {
//                                    LazyVGrid(columns: preference, spacing: 16) {
//                                        
////                                        ForEach(athletesListVM.athletes.dropLast(athletesListVM.athletes.count % 4), id: \.self) { athlete in
//                                        //ForEach(athletesListVM.athletes, id: \.self) { athlete in
//                                        let enumerated = Array(zip(athletesListVM.athletes.indices, athletesListVM.athletes))
//                                        ForEach(enumerated, id: \.1) { index, athlete in
//                                            VStack{
//                                                ZStack{
//                                                ZStack{
//                                                    Circle()
//                                                        .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
//                                                        .frame(height: 45)
//                                                    Text(getInitials(firstName: athlete.firstName, lastName: athlete.lastName))
//                                                        .font(.subheadline)
//                                                        .fontWeight(.semibold)
//                                                        .foregroundColor(.cardProfileLetter)
//                                                }
//                                                .opacity(addSessionVM.selectedIndices.contains(index) ? 0.3 : 1.0)
//                                                    Image(systemName: "checkmark")
//                                                        .resizable()
//                                                        .foregroundColor(.accentBigButton)
//                                                        .frame(width: 21, height: 16, alignment: .center)
//                                                        .opacity(addSessionVM.selectedIndices.contains(index) ? 1.0 : 0.0)
//                                                }
//                                               
//                                                
//                                                Text("\(athlete.firstName)")
//                                                    .font(.caption)
//                                                    .opacity(addSessionVM.selectedIndices.contains(index) ? 0.5 : 1.0)
//                                            }
//                                            .onTapGesture {
//                                                if addSessionVM.selectedIndices.contains(index) {
//                                                            addSessionVM.selectedIndices.remove(index)
//                                                          } else {
//                                                            addSessionVM.selectedIndices.insert(index)
//                                                          }
//                                                print(addSessionVM.selectedIndices)
//                                            }
//
//                                        }
//                                    }
//                                    
////                            LazyHStack() {
////                                ForEach(athletesListVM.athletes.suffix(athletesListVM.athletes.count % 4), id: \.self) { athlete in
////                                            VStack{
////                                                Circle()
////                                                    .frame(height: 45)
////                                                Text("\(athlete.firstName)")
////                                                    .font(.caption)
////                                            }
////                                        }
////                                    }
////                            .padding(.top, 8)
//                                }
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
//                        .padding()
//                        
//                        
////                            ZStack {
////
////
////                                Rectangle()
////                                    .background(Color.accentMidGround)
////                                    .foregroundColor(.accentMidGround)
////                                    .frame(maxWidth: .infinity)
////                                    .cornerRadius(10)
////                                    .padding()
////
////
////
////
////
////
////
////                            }
//                            
//                            
//                            
//                            //ZStack that has padding but is clear so it is just for view formatting
////                            ZStack {
////                                Rectangle()
////                                    .foregroundColor(.clear)
////                                    .frame(width: 105, height: 40)
////                                    .cornerRadius(10)
////                            }
////                            .padding(.horizontal, 8)
////                            //ZStack for View formatting
////                            ZStack {
////                                Rectangle()
////                                    .foregroundColor(.clear)
////                                    .frame(width: 105, height: 40)
////                                    .cornerRadius(10)
////                            }
////                        //}
////                        .padding()
//                    }
//                    .padding(.top)
//                    
//                    
//             //AddSessionButton
//                    
//                    addSessionButton
//                    
//                    
////                    Text("Sessions Date+Time: \(datesVM.mergeTimeAndDate(time: selectedTime, date: selectedDate))")
////                        .padding()
////                    Text("Today: \(String(todayIsSelected))")
////                        .padding()
////                    Text("Tomorrow: \(String(tomorrowIsSelected))")
////                        .padding()
////                    Text("Date: \(selectedDate)")
////
////
////                    Text("Today: \(Date())")
////
////                    Text("Tomorrow: \(datesVM.setDateToTomorrow())")
//                        
//                    Spacer()
//                }
//                
//                
//                
//            }
//            ZStack{
//                if self.showTimePicker {
//                    
//                    Color.black
//                        .opacity(0.4)
//                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture { showTimePicker.toggle() }
//                    ZStack{
//                    RoundedRectangle(cornerRadius: 15)
//                        .foregroundColor(colorScheme == .light ? .appBackground : .accentMidGround)
//                        .frame(maxWidth: 250)
//                        .frame(height: 220, alignment: .center)
//                        .padding(.horizontal)
//                        MyTimePicker(selection: $addSessionVM.sessionTime, minuteInterval: 5, displayedComponents: .hourAndMinute)
//                            .frame(maxWidth: 250)
//                            .frame(height: 220, alignment: .center)
//                    }
//                }
//            }
//            .opacity(self.showTimePicker ? 1 : 0).animation(.easeIn, value: showTimePicker)
//            
//            ZStack{
//                if self.showDatePicker {
//                    
//                    Color.black
//                        .opacity(0.4)
//                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture { showDatePicker.toggle() }
//                    
//                       DateSeläctör(selectedDate: $addSessionVM.sessionDate)
//                        .onChange(of: addSessionVM.sessionDate) { date in
//                            if Calendar.current.isDateInToday(date) {
//                                todayIsSelected = true
//                                tomorrowIsSelected = false
//                            } else if Calendar.current.isDateInTomorrow(date) {
//                                todayIsSelected = false
//                                tomorrowIsSelected = true
//                            } else {
//                                todayIsSelected = false
//                                tomorrowIsSelected = false
//                            }
//
//                        }
//                        }
//                }
//            .opacity(self.showDatePicker ? 1 : 0).animation(.easeIn, value: showDatePicker)
//            
//        }
//    }
//    
//    var addSessionHeader: some View {
//        HStack{
//            Button(action: {
//                presentationMode.wrappedValue.dismiss()
//            }){
//                //NavigationButtonSystemName(iconName: "chevron.backward")
//                Image(systemName: "arrow.backward")
//                    .resizable()
//                    .foregroundColor(.header)
//                    .frame(width: 27, height: 20)
//            }
//            
//            Spacer(minLength: 0)
//            
//            Text("Add Session")
//                .font(.title)
//                .foregroundColor(.header)
//                .fontWeight(.medium)
//            
//            Spacer(minLength: 0)
//            
//            Button(action: {
//                addSessionVM.save()
//                presentationMode.wrappedValue.dismiss()
//                
//            }){
//                Image(systemName: "checkmark")
//                    .resizable()
//                    .foregroundColor(.header)
//                    .frame(width: 26, height: 20)
//            }//Button
//        }//HeaderHStackEnding
//        .padding(.horizontal, 22)
//        .padding(.top, 15)
//    }
//    
//    var addSessionButton: some View{
//    Button(action: {
//        addSessionVM.save()
//        presentationMode.wrappedValue.dismiss()
//        }) {
//        HStack{
//            Image(systemName: "plus")
//                .font(.system(size: 20))
//            Text("Add Session")
//                .font(.headline)
//        }
//        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
//        .background(Color.accentBigButton)
//        .foregroundColor(Color.white)
//        .cornerRadius(10)
//        .padding()
//    }
//    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
//    }
//}
//
//
//struct TimePicker: View {
//    @Binding var selectedTime: Date
//    @Environment(\.colorScheme) var colorScheme
//    
//    
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 15)
//                .foregroundColor(colorScheme == .light ? .appBackground : .accentMidGround)
//                .frame(maxWidth: 250)
//                .frame(height: 220, alignment: .center)
//                .padding(.horizontal)
//            
//            VStack(alignment: .leading ,spacing: 10) {
//                
//                
//                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
//                    .datePickerStyle(.wheel)
//                    .colorScheme(colorScheme == .light ? .light : .dark)
//                    .accentColor(.accentSmallButton)
//                    .labelsHidden()
//                    .padding(.horizontal, 30)
//                    .padding(.top, 20)
//                    .frame(height: 300)
//                    
//                
//            }
//        }
//    }
//}
//
//struct MyTimePicker: UIViewRepresentable {
//
//    @Binding var selection: Date
//    let minuteInterval: Int
//    let displayedComponents: DatePickerComponents
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<MyTimePicker>) -> UIDatePicker {
//        let picker = UIDatePicker()
//        
//        // listen to changes coming from the date picker, and use them to update the state variable
//        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged), for: .valueChanged)
//        picker.preferredDatePickerStyle = .wheels
//        return picker
//    }
//
//    func updateUIView(_ picker: UIDatePicker, context: UIViewRepresentableContext<MyTimePicker>) {
//        picker.minuteInterval = minuteInterval
//        picker.date = selection
//
//        switch displayedComponents {
//        case .hourAndMinute:
//            picker.datePickerMode = .time
//        case .date:
//            picker.datePickerMode = .date
//        case [.hourAndMinute, .date]:
//            picker.datePickerMode = .dateAndTime
//        default:
//            break
//        }
//    }
//
//    class Coordinator {
//        let datePicker: MyTimePicker
//        init(_ datePicker: MyTimePicker) {
//            self.datePicker = datePicker
//        }
//
//        @objc func dateChanged(_ sender: UIDatePicker) {
//            datePicker.selection = sender.date
//        }
//    }
//}
//
//
//struct DateSeläctör: View {
//    @Binding var selectedDate: Date
//    @Environment(\.colorScheme) var colorScheme
//    
//    
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 15)
//                .foregroundColor(colorScheme == .light ? .appBackground : .accentMidGround)
//                .frame(maxWidth: .infinity)
//                .frame(height: 315, alignment: .center)
//                .padding(.horizontal)
//            
//            VStack(alignment: .leading ,spacing: 10) {
//                
//                
//                DatePicker("", selection: $selectedDate, displayedComponents: .date)
//                    .datePickerStyle(.graphical)
//                    .colorScheme(colorScheme == .light ? .light : .dark)
//                    .accentColor(.accentSmallButton)
//                    .labelsHidden()
//                    .padding(.horizontal, 30)
//                    .padding(.top, 20)
//                    .frame(height: 300)
//                
//            }
//        }
//    }
//}
//
//
//
////struct AddSessionView_Previews: PreviewProvider {
////    static var previews: some View {
////        AddSessionView(vm: AthletesListViewModel(context: NSManagedObjectContext))
////    }
////}
