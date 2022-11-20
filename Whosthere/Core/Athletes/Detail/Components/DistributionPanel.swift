//
//  DistributionPanel.swift
//  Whosthere
//
//  Created by Moose on 16.11.22.
//

import SwiftUI

struct DistributionPanel: View {
    @ObservedObject var dataDetailVM: DetailDataVM
    @Binding var showPickerPerX: Bool
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
            HStack{
                VStack(alignment: .leading, spacing: 2){
                    Text("Distribution")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.header)
                    HStack(spacing: 4){
                        if station.perXAttendance == .total { Text("total") }
                        else if station.perXAttendance == .perMonth { Text("per Month") }
                        else if station.perXAttendance == .perWeek { Text("per Week") }
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9))
                    }
                    .font(.caption2)
                    .foregroundColor(.cardGrey2)
                    .onTapGesture {
                        withAnimation {
                            showPickerPerX.toggle()
                        }
                    }
                }
                .padding()
                .background(Color.clear.disabled(refresh))
                
                
                Spacer()
                
                ZStack{
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
                .padding(.bottom, 10)
            }
            
            HStack(alignment: .bottom){
                
                ForEach(weekDays, id: \.1) { day, index in
                    HStack{
                        Spacer()
                        
                        VStack(spacing: 2){
                            
                            
                            if dataDetailVM.modifiedArrayOfSessions.isEmpty {
                                
                                
                                ZStack(alignment: .bottom){
                                    VStack{
                                    Text("0")
                                        .font(.caption2)
                                        .foregroundColor(.clear)
                                    
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 34, height: 100)
                                        .foregroundColor(.clear)
                                        .padding(.bottom, 6)
                                }
                                    VStack{
                                        Text("0")
                                            .font(.caption2)
                                            .foregroundColor(.header)
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: 34, height: 1)
                                            .foregroundColor(.appBackground)
                                            .padding(.bottom, 6)
                                    }
                                }
                                
                            } else {
                                VStack{
                                    Text("\(dataDetailVM.distributionSessions[index].count)")
                                        .font(.caption2)
                                        .foregroundColor(.header)
                                    //.animation(.easeInOut, value: dataDetailVM.sessionBarHeights)
                                    
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
                            
                            Spacer()
                        }
                        
                    }
                }
                
                
            }
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.accentMidGround))
            .padding()
        }
    }

    
    /*
struct DistributionPanel_Previews: PreviewProvider {
    static var previews: some View {
        DistributionPanel(detailVM: AthleteDetailVM(athlete: Athlete()) ?? AthleteDetailVM(athlete2: Athlete()))
    }
}*/

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

