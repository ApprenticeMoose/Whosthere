//
//  SessionsHomeView.swift
//  Whosthere
//
//  Created by Moose on 05.08.22.
//

import SwiftUI

struct SessionsHomeView: View {
    
    @ObservedObject var sessionsVM: SessionsViewModel
    
    
    var calendar = Calendar.current
    //var selectedWeek: Int
    @State var isSelectedWeekButton: Bool = false
    
    init(){
        self.sessionsVM = SessionsViewModel()
        //self.selectedWeek = calendar.component(.weekOfYear, from: Date())
    }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }

    var body: some View {
        
        VStack(spacing: 18){
            
            HStack{
                ScreenHeaderTextOnly(screenTitle: "Sessions")
                athleteListButtonRow
//                    .fullScreenCover(isPresented: $showAddSheet,
//                                     content: {AddAthleteView(vm: AddAthleteViewModel(context: viewContext))})
                
            }
            //HStack
            //Horizontal scroll view with
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                
                HStack(spacing: 10){
                    //CalendarButton
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.accentMidGround)
                        Image(systemName: "calendar")
                            .foregroundColor(Color.header)
                    }
                    .onTapGesture {
                        //pop up calendar view
                    }
                    ForEach(0..<sessionsVM.shownWeeksFirstDay.count, id: \.self) { i in
                        ZStack {
                            if sessionsVM.checkCurrentWeek(date: sessionsVM.shownWeeksFirstDay[i]) {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.header, lineWidth: 1.0)
                                    .frame(minWidth: 100, maxWidth: 110, minHeight: 40, idealHeight: 40, maxHeight: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.accentMidGround)
                                    )
                                    
                            } else {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(minWidth: 100, maxWidth: 110, minHeight: 40, idealHeight: 40, maxHeight: 40)
                                    .foregroundColor(Color.accentMidGround)
                            }
                        VStack {
                            Text("KW " + "\(sessionsVM.extractWeek(date: sessionsVM.shownWeeksFirstDay[i]))")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                //.foregroundColor(isSelectedWeekButton ? Color.header :Color.header.opacity(0.3))
                            HStack(spacing: 0){
                            Text(sessionsVM.extractDate(date: sessionsVM.shownWeeksFirstDay[i], format: "dd") + ". -")
                                .font(.caption2)
                                .fontWeight(.regular)
                                .id(i)
                                //.foregroundColor(isSelectedWeekButton ? Color.header :Color.header.opacity(0.3))
                            Text(sessionsVM.extractDate(date: sessionsVM.shownWeeksLastDay[i], format: "dd. MMM"))
                                .font(.caption2)
                                .fontWeight(.regular)
                                //.foregroundColor(isSelectedWeekButton ? Color.header :Color.header.opacity(0.3))
                        }
                           
                    }
                        .foregroundColor(sessionsVM.checkCurrentWeek(date: sessionsVM.shownWeeksFirstDay[i]) ? Color.header : Color.header.opacity(0.3))
                }
                        .onTapGesture {
                            isSelectedWeekButton = true
                            //withAnimation{
                                sessionsVM.currentWeek = sessionsVM.shownWeeksFirstDay[i]
                                sessionsVM.scrollToIndex = i
                            
                            //}
                        }
//                        .onAppear {
//
//                        }
                    }
                    .onAppear(perform: {
                        proxy.scrollTo(sessionsVM.scrollToIndex, anchor: .center)
                    })
                    .onChange(of: sessionsVM.scrollToIndex) { value in
                        withAnimation(.spring()) {
                        proxy.scrollTo(value, anchor: .center)
                        }
                    }
                    //CalendarButton
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.accentMidGround)
                        Image(systemName: "calendar")
                            .foregroundColor(Color.header)
                    }
                    .onTapGesture {
                        //pop up calendar view
                    }
            }
        }
                .padding(.horizontal)
                
    }//scrollview
            
            Spacer()
            
            Text("\(sessionsVM.extractWeek(date: sessionsVM.currentWeek))")
            Text("\(sessionsVM.extractDate(date: sessionsVM.currentWeek, format: "dd MMM"))")
            Text("\(sessionsVM.scrollToIndex)")
            
            

                 
            
            Spacer()
        } //VStack
        Spacer()
    }
    
    
    
    
    private var athleteListButtonRow: some View {
    
    HStack{
 

        
        Button(action: {
            //Make Sort Sheet Appear
        }){
            Image(systemName: "calendar")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.header)
                .padding(.horizontal, 14)
        }
        
        // Add Athlete Button
        Button(action: {
            //showAddSheet.toggle()
        }){
            Image(systemName: "plus")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.header)
        }
        
        
        
    }//HStackButtonsEnd
    .padding(.horizontal, 22)
    .padding(.top, 20)
}
    
//    var isSelectedWeekButton: Bool = true
//
//    private var weekSelectionButton: some View{
//        VStack{
//            Text("KW \(weekService.getWeek(date:Date()))")
//            .font(.footnote)
//            .fontWeight(.semibold)
//        Text("19.-26. Jul")
//            .font(.caption2)
//            .fontWeight(.regular)
//        }
//        .padding()
//        .frame(minWidth: 100, maxWidth: 110, minHeight: 40, idealHeight: 40, maxHeight: 40)
//        .background(Color.accentMidGround.cornerRadius(5))
//        .foregroundColor(Color.header)
//    }

    }//StructEnd

//struct WeekSelectionButton: View {
//
//    var isSelectedWeekButton: Bool
//    @ObservedObject var weekService: SessionsViewModel
//
//    var body: some View{
//        ZStack {
//            if isSelectedWeekButton {
//                RoundedRectangle(cornerRadius: 5)
//                    .stroke(Color.header, lineWidth: 1.0)
//                    .frame(minWidth: 100, maxWidth: 110, minHeight: 40, idealHeight: 40, maxHeight: 40)
//                    .background(
//                        RoundedRectangle(cornerRadius: 5)
//                            .fill(Color.accentMidGround)
//                    )
//
//            } else {
//                RoundedRectangle(cornerRadius: 10)
//                    .frame(width: 44, height: 44)
//                    .foregroundColor(Color.accentMidGround)
//            }
//
//            VStack{
//                Text("KW \(weekService.extractWeek(date:Date()))")
//                    .font(.footnote)
//                    .fontWeight(.semibold)
//                    .foregroundColor(Color.header)
//                Text("19.-26. Jul")
//                    .font(.caption2)
//                    .fontWeight(.regular)
//                    .foregroundColor(Color.header)
//            }
//        }
//        .padding()
//    }
//}


struct SessionsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsHomeView()
    }
}
