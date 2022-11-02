//
//  SessionHomeCardHeadline.swift
//  Whosthere
//
//  Created by Moose on 20.10.22.
//
import SwiftUI

struct SessionHomeCardHeadline: View {
    let date: Date
    let todayComp = Calendar.current.dateComponents([.calendar, .year, .month, .day, .timeZone, .weekday, .weekOfYear], from: Date())
    
    var body: some View {
        HStack{
            Text(date.formatDateWeekday() + ", " + date.formatted(
                .dateTime
                    .month(.wide)
                    .day()
            ))
            .fontWeight(Calendar.current.dateComponents([.calendar, .year, .month, .day, .timeZone, .weekday, .weekOfYear], from: date) == todayComp ? .semibold : .medium)
            .foregroundColor(Calendar.current.dateComponents([.calendar, .year, .month, .day, .timeZone, .weekday, .weekOfYear], from: date) == todayComp ? .header : .cardGrey1)
            .padding(.horizontal, 22)
            Spacer()
        }
    }
}
