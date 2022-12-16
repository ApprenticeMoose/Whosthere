//
//  CourseOfAttendancePanel.swift
//  Whosthere
//
//  Created by Moose on 24.11.22.
//
/*
import SwiftUI
import Charts

struct CourseOfAttendancePanel: View {
    
    @ObservedObject var dataDetailVM: DetailDataVM
    
    var largestSessionCount: Int {
        var arrayOfCounts = [Int]()
        (dataDetailVM.courseOfAttendanceSimplified).forEach { date, sessionCount in
            arrayOfCounts.append(sessionCount)
        }
        return arrayOfCounts.max() ?? 1
    }
    
  
    
                   
    var body: some View {
        Chart {
            ForEach(dataDetailVM.courseOfAttendance, id: ) { data in
                LineMark(
                    x: .value("KW", data),
                    y: .value("# attended", bar1.sessionCount))
            }
        }
        
      //  .chartYScale(domain: 0 ... largestSessionCount + 1)
        
        .chartYAxis {
            AxisMarks(preset: .extended, position: .leading)
        }
        
   //     .chartXAxis(.visible)
        .padding()
        .frame(width: 300)
    }
}

struct CourseOfAttendancePanel_Previews: PreviewProvider {
    static var previews: some View {
        CourseOfAttendancePanel(dataDetailVM: DetailDataVM())
    }
}

struct CourseChartBar: Identifiable {
    var id = UUID().uuidString
    var week: Int
    var sessions: [Session]
}
*/
