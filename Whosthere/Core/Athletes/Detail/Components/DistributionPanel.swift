//
//  DistributionPanel.swift
//  Whosthere
//
//  Created by Moose on 16.11.22.
//

import SwiftUI

struct DistributionPanel: View {
    @ObservedObject var dataDetailVM: DetailDataVM
    @Binding var showXAttendedPicker: Bool
    @Binding var showPickerSelectKW: Bool
    @Binding var refresh: Bool
    //@ObservedObject var station: Station = Station() //necessary so KWSelectionUpdates
    @EnvironmentObject var station: Station
    
    
    var weekDays = [("Mo", 1),("Tu", 2), ("We", 3), ("Th", 4), ("Fr", 5), ("Sa", 6), ("Su", 0)]
    
    var distributionCount: [Int] {
        var sessionsCount: [Int] = []
        (dataDetailVM.distributionSessions).forEach { sessions in
            let count = sessions.count
            sessionsCount.append(count)
        }
        return sessionsCount
    }
    
    var barHeights: [Float] {
        return dataDetailVM.sessionBarHeights
    }
    
    var body: some View {
        VStack(spacing: 2){
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 2){
                    Text("Distribution")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.header)
                    HStack(spacing: 4){
                        if station.xAttendedDistribution == .attendedNumber { Text("# attended") }
                        else if station.xAttendedDistribution == .attendedPercent { Text("% attended") }
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9))
                    }
                    .font(.caption2)
                    .foregroundColor(.cardGrey2)
                    .onTapGesture {
                        withAnimation {
                            showXAttendedPicker.toggle()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 4)
                .background(Color.clear.disabled(refresh))
                
                
                Spacer()
                HStack{
                    if station.xAttendedDistribution == .attendedNumber {
                        Text("\(dataDetailVM.modifiedArrayOfSessions.count)" + " / " + "\(dataDetailVM.modifiedAllSessions.count)")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.header)
                            .padding()
                    }  else if station.xAttendedDistribution == .attendedPercent {
                        if dataDetailVM.modifiedAllSessions.count > 0 {
                            Text(calculateAttendedPercantage(
                                attended: dataDetailVM.modifiedArrayOfSessions.count,
                                all: dataDetailVM.modifiedAllSessions.count) + "%")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.header)
                            .padding()
                        } else {
                            Text("-%")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(.header)
                                .padding()
                        }
                    }
                }
                .animation(.easeInOut, value: dataDetailVM.animate)

               /* ZStack{
                    RoundedRectangle(cornerRadius: 5).foregroundColor(Color.appBackground).frame(width: 94, height: 30)
                    
                    HStack(alignment: .lastTextBaseline){
                        Text("KW " + "50" + " - " + "50")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.clear)
                        
                        //Arrow down
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(.header)
                    }
                    
                    HStack(alignment: .lastTextBaseline){
                        if station.dateFilterAttendance.date1.extractWeek() == station.dateFilterAttendance.date2.extractWeek() {
                            Text("    KW " + "\(station.dateFilterAttendance.date1.extractWeek())    ")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.header)
                            
                        } else {
                            Text("KW " + "\(station.dateFilterAttendance.date1.extractWeek())" + " - " + "\(station.dateFilterAttendance.date2.extractWeek())")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.header)
                        }
                        //Arrow down
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(.clear)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        showPickerSelectKW.toggle()
                    }
                }
                .padding(.horizontal, 6)
                .padding(.bottom, 10)*/
            }
            
            HStack(alignment: .bottom){
                
                ForEach(weekDays, id: \.1) { day, index in
                    HStack{
                        Spacer()
                        ZStack(alignment: .bottom){
                            VStack(spacing: 2){
                                
                                if dataDetailVM.modifiedAllSessions.isEmpty {
                                    
                                    ZStack(alignment: .bottom){
                                        VStack(spacing: 2){
                                        Text("0")
                                            .font(.caption2)
                                            .foregroundColor(.clear)
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: 34, height: 100)
                                            .foregroundColor(.clear)
                                            .padding(.bottom, 6)
                                    }
                                        
                                        
                                        VStack(spacing: 2){
                                            if station.xAttendedDistribution == .attendedNumber {
                                                Text("0")
                                                    .font(.caption2)
                                                .foregroundColor(.cardBarText) } else {
                                                    Text("0")
                                                        .font(.caption2)
                                                    .foregroundColor(.clear)
                                                }
                                            
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 34, height: 1)
                                                .foregroundColor(.cardBar)
                                                .padding(.bottom, 6)
                                        }
                                    }
                                    
                                } else {
                                    VStack(spacing: 2){
                                        if station.xAttendedDistribution == .attendedNumber {
                                            Text("\(dataDetailVM.distributionAllSessions[index].count)")
                                                .font(.caption2)
                                                .foregroundColor(dataDetailVM.distributionAllSessions[index].count == 0 ? .cardBarText.opacity(0.2) : .cardBarText)
                                        } else {
                                            Text("0")
                                                .font(.caption2)
                                            .foregroundColor(.clear)
                                        }
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: 34, height: CGFloat(dataDetailVM.sessionAllBarHeights[index]))
                                            .foregroundColor(.cardBar)
                                            .padding(.bottom, 6)
                                    }
                                    
                                    }
                                    Text(day)
                                        .font(.footnote)
                                        .foregroundColor(.cardGrey2)
                                        .padding(.bottom)
                                }
                            .animation(.easeInOut, value: dataDetailVM.animate)
                              
                            VStack(spacing: 2){
                                
                                if dataDetailVM.modifiedArrayOfSessions.isEmpty {
                                    
                                    ZStack(alignment: .bottom){
                                        VStack(spacing: 2){
                                            Text("0")
                                                .font(.caption2)
                                                .foregroundColor(.clear)
                                            
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 34, height: 100)
                                                .foregroundColor(.clear)
                                                .padding(.bottom, 6)
                                        }
                                        VStack(spacing: 2){
                                            if station.xAttendedDistribution == .attendedNumber {
                                                Text("0")
                                                    .font(.caption2)
                                                    .foregroundColor(.header)
                                            }
                                            else if station.xAttendedDistribution == .attendedPercent {
                                                Text("-%")
                                                    .font(.caption2)
                                                    .foregroundColor(.header)
                                            }


                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 34, height: 1)
                                                .foregroundColor(.appBackground)
                                                .padding(.bottom, 6)
                                        }
                                    }
                                    
                                } else {
                                    VStack(spacing: 2){
                                        if station.xAttendedDistribution == .attendedNumber {
                                            Text("\(dataDetailVM.distributionSessions[index].count)")
                                                .font(.caption2)
                                                .foregroundColor(dataDetailVM.distributionSessions[index].count == 0 ? .header.opacity(0.2) : .header)
                                        }
                                        else if station.xAttendedDistribution == .attendedPercent {
                                            if dataDetailVM.distributionAllSessions[index].count > 0 {
                                                Text(calculateAttendedPercantage(
                                                    attended: dataDetailVM.distributionSessions[index].count,
                                                    all: dataDetailVM.distributionAllSessions[index].count) + "%")
                                                    .font(.caption2)
                                                    .foregroundColor(dataDetailVM.distributionSessions[index].count == 0 ? .header.opacity(0.2) : .header)
                                                   
                                            } else {
                                                Text("-%")
                                                    .font(.caption2)
                                                    .foregroundColor(dataDetailVM.distributionSessions[index].count == 0 ? .header.opacity(0.2) : .header)
                                            }
                                        }
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: 34, height: CGFloat(dataDetailVM.sessionBarHeights[index]))
                                            .foregroundColor(.appBackground)
                                            .padding(.bottom, 6)
                                    }
                                    
                                }
                                Text(day)
                                    .font(.footnote)
                                    .foregroundColor(.cardGrey2)
                                    .padding(.bottom)
                            }
                            .animation(.easeInOut, value: dataDetailVM.animate)
                        }
                            Spacer()
                        }
                        
                    }
                }
            .padding(.horizontal, 2)
                
                
            }
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
            .padding()
        }
    
    func calculateAttendedPercantage(attended: Int, all: Int) -> String {
        
        return String(round(Float(attended) / Float(all) * 100).clean)
    }
}




