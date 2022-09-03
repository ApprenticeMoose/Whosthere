//
//  AddSessionView.swift
//  Whosthere
//
//  Created by Moose on 30.08.22.
//

import SwiftUI

struct AddSessionView: View {
    
    var type: DatePickerComponents? = .date
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var todayIsSelected = true
    @State var tomorrowIsSelected = false
    
    @State var selectedTime = Date()
    @State var selectedDate = Date()
    
    //var selectedTimeDate for saving
    
    @State var showTimePicker: Bool = false
    @State var showDatePicker: Bool = false
    
    @ObservedObject var sessionsVM: SessionsViewModel
    
    init(){
        self.sessionsVM = SessionsViewModel()
    }
    
    func roundMinutesDown(date: Date) -> Date {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        return calendar.date(byAdding: .minute, value: (5 - minute % 5) - 5, to: date) ?? Date()
        
    }
    
    func mergeTimeAndDate(time: Date, date: Date) -> Date {
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        let dateComponents = calendar.dateComponents([.calendar, .year, .month, .day, .timeZone, .weekday, .weekOfYear], from: date)
        let mergedDate = DateComponents(calendar: dateComponents.calendar, timeZone: dateComponents.timeZone, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute, weekday: dateComponents.weekday, weekOfYear: dateComponents.weekOfYear)
        return roundMinutesDown(date: calendar.date(from: mergedDate) ?? Date())
    }
    
    func setDateToTomorrow() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    }
    
    var body: some View {
        ZStack{
            VStack{
                addSessionHeader
                
                
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
                            
                            
                            Text("\(sessionsVM.extractDate(date: roundMinutesDown(date: selectedTime), format: "HH:mm"))")
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
                            selectedDate = Date()
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
                            selectedDate = setDateToTomorrow()
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
                            
                            Text("\(sessionsVM.extractDate(date: selectedDate, format: "dd. MMM"))")
                                .fontWeight(.semibold)
                        }
                        //.padding()
                        .onTapGesture {
                            //show time selection
                            showDatePicker.toggle()
                        }
                        
                    }
                    .padding()
                    
                    Text("Sessions Date+Time: \(mergeTimeAndDate(time: selectedTime, date: selectedDate))")
                        .padding()
                    Text("Today: \(String(todayIsSelected))")
                        .padding()
                    Text("Tomorrow: \(String(tomorrowIsSelected))")
                        .padding()
                    Text("Date: \(selectedDate)")
                        
    
                    Text("Today: \(Date())")
                      
                    Text("Tomorrow: \(setDateToTomorrow())")
                        
                    Spacer()
                }
                
                
                
            }
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
                    MyDatePicker(selection: $selectedTime, minuteInterval: 5, displayedComponents: .hourAndMinute)
                            .frame(maxWidth: 250)
                            .frame(height: 220, alignment: .center)
                    }
                        //.datePickerStyle(.wheel)
                    //TimePicker(selectedTime: $selectedTime)
                    
                }
            }
            .opacity(self.showTimePicker ? 1 : 0).animation(.easeIn, value: showTimePicker)
            
            ZStack{
                if self.showDatePicker {
                    
                    Color.black
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture { showDatePicker.toggle() }
                    
                       DateSeläctör(selectedDate: $selectedDate)
                        .onChange(of: selectedDate) { date in
                            if date == roundMinutesDown(date: Date()) {
                                todayIsSelected = true
                                tomorrowIsSelected = false
                            } else {
                                todayIsSelected = false
                                tomorrowIsSelected = false
                            }
                            
                            
                            if date == roundMinutesDown(date: setDateToTomorrow()) {
                                todayIsSelected = false
                                tomorrowIsSelected = true
                            } else {
                                todayIsSelected = false
                                tomorrowIsSelected = false
                            }
                            print(selectedDate)
                            print(Date())
                            print(setDateToTomorrow())
                        }
                            
                        
//                                else {
//                                todayIsSelected = false
//                            }
//                            if  date == setDateToTomorrow() {
//                                tomorrowIsSelected = true
//                            } else {
//                                tomorrowIsSelected = false
//                            }
                        }
                }
            .opacity(self.showDatePicker ? 1 : 0).animation(.easeIn, value: showDatePicker)
            
        }
//        .onAppear {
//            UIDatePicker.appearance().minuteInterval = 5
//        }
                
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

struct MyDatePicker: UIViewRepresentable {

    @Binding var selection: Date
    let minuteInterval: Int
    let displayedComponents: DatePickerComponents

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<MyDatePicker>) -> UIDatePicker {
        let picker = UIDatePicker()
        
        // listen to changes coming from the date picker, and use them to update the state variable
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged), for: .valueChanged)
        picker.preferredDatePickerStyle = .wheels
        return picker
    }

    func updateUIView(_ picker: UIDatePicker, context: UIViewRepresentableContext<MyDatePicker>) {
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
        let datePicker: MyDatePicker
        init(_ datePicker: MyDatePicker) {
            self.datePicker = datePicker
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            datePicker.selection = sender.date
        }
    }
}

//struct DatePickerDemo: View {
//    @State var wakeUp: Date = Date()
//    @State var minterval: Int = 1
//
//    var body: some View {
//        VStack {
//            Stepper(value: $minterval) {
//                Text("Minute interval: \(minterval)")
//            }
//            MyDatePicker(selection: $wakeUp, minuteInterval: minterval, displayedComponents: .hourAndMinute)
//            Text("\(wakeUp)")
//        }
//    }
//}

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

struct AddSessionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSessionView()
    }
}
