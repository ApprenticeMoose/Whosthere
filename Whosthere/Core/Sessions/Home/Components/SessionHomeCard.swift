//
//  SessionHomeCard.swift
//  Whosthere
//
//  Created by Moose on 20.10.22.
//
import SwiftUI
import NavigationBackport

struct SessionHomeCard: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var tabDetail: TabDetailVM
    
    let session: Session
    @ObservedObject var sessionVM: SessionHomeVM
    @Binding var showActionSheet: Bool
    
    var body: some View {
        
        ZStack{
            
            VStack(spacing: 6){
                
                HStack{
                    //clock time and 3point button
                    NBNavigationLink(value: Route.editSession(session), label: {
                        HStack{
                            HStack(spacing: 6){
                                Image(systemName: "clock")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text(session.date, style: .time)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.midTitle)
                            .padding(.horizontal, 18)
                            Spacer()
                        }
                        .padding(.top, 14)
                        .padding(.bottom, 2)
                    })
                    
                    
                    //Menu
                    Button{
                        //open little menu to dublicate delete etc
                        withAnimation {
                            showActionSheet.toggle()
                            tabDetail.sessionForSheet = session
                        }
                    } label: {
                        HStack(spacing: 3){
                            Circle()
                                .frame(width: 5, height: 5)
                                .foregroundColor(.cardGrey1)
                            Circle()
                                .frame(width: 5, height: 5)
                                .foregroundColor(.cardGrey1)
                            Circle()
                                .frame(width: 5, height: 5)
                                .foregroundColor(.cardGrey1)
                        }
                        .padding(.horizontal)
                        .padding(.top, 14)
                        .padding(.bottom, 2)
                        .offset(y: -4)
                    }
                    
                    
                }//Time and 3 point Button
                .padding(.horizontal)
                
                NBNavigationLink(value: Route.editSession(session), label: {
                    VStack{
                        HStack{
                            Rectangle()
                                .frame(width: 245, height: 1.5, alignment: .center)
                                .foregroundColor(colorScheme == .light ? .cardGrey1.opacity(0.35) : .header.opacity(0.15))
                                .padding(.horizontal, 26)
                            Spacer()
                        }//Line
                        
                        HStack{
                            
                            HStack(spacing: 15){
                                if session.athleteIDs.isEmpty {
                                    VStack(spacing: 2){
                                        ZStack{
                                            Circle()
                                                .frame(width: 26, height: 26)
                                                .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                            Image(systemName: "plus")
                                            //.resizable()
                                            //.frame(width: 12, height: 12)
                                                .font(.system(size: 12))
                                            //.font(.caption2)
                                                .foregroundColor(.cardProfileLetter)
                                            //.offset(x: 1)
                                        }
                                        
                                        Text("Add")
                                            .font(.caption2)
                                            .foregroundColor(.cardText)
                                    }
                                } else {
                                    if session.athleteIDs.count < 6 {
                                        ForEach(session.athleteIDs, id: \.self) {athleteID in
                                            if let athlete = sessionVM.getAthletes(with: athleteID){
                                                VStack(spacing: 2){
                                                    ZStack{
                                                        Circle()
                                                            .frame(width: 26, height: 26)
                                                            .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                                        Text(getInitials(firstName: athlete.firstName, lastName: athlete.lastName))
                                                            .font(.caption2)
                                                            .fontWeight(.semibold)
                                                            .foregroundColor(.cardProfileLetter)
                                                    }
                                                    Text(athlete.firstName)
                                                        .font(.caption2)
                                                        .foregroundColor(.cardText)
                                                }
                                            }
                                        }} else if session.athleteIDs.count == 6 {
                                            // display the 1-4 normally
                                            ForEach(session.athleteIDs[0...3], id: \.self) {athleteID in
                                                if let athlete = sessionVM.getAthletes(with: athleteID){
                                                    VStack(spacing: 2){
                                                        ZStack{
                                                            Circle()
                                                                .frame(width: 26, height: 26)
                                                                .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                                            Text(getInitials(firstName: athlete.firstName, lastName: athlete.lastName))
                                                                .font(.caption2)
                                                                .fontWeight(.semibold)
                                                                .foregroundColor(.cardProfileLetter)
                                                        }
                                                        Text(athlete.firstName)
                                                            .font(.caption2)
                                                            .foregroundColor(.cardText)
                                                    }
                                                }
                                            }
                                            // display the 5th + 6th
                                            
                                            if let athlete1 = sessionVM.getAthletes(with: session.athleteIDs[4]){
                                                HStack{
                                                    VStack(spacing: 2){
                                                        ZStack{
                                                            if let athlete2 = sessionVM.getAthletes(with: session.athleteIDs[5]){
                                                                
                                                                ZStack{
                                                                    Circle()
                                                                        .frame(width: 22, height: 22)
                                                                        .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                                                    Text(getInitials(firstName: athlete2.firstName, lastName: athlete2.lastName))
                                                                        .font(.system(size: 9, weight: .light, design: .default))
                                                                        .fontWeight(.semibold)
                                                                        .foregroundColor(.cardProfileLetter)
                                                                        .offset(x: 2)
                                                                }
                                                                .offset(x: 16, y: -2)
                                                            }
                                                            ZStack{
                                                                Circle()
                                                                    .frame(width: 26, height: 26)
                                                                    .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                                                Text(getInitials(firstName: athlete1.firstName, lastName: athlete1.lastName))
                                                                    .font(.caption2)
                                                                    .fontWeight(.semibold)
                                                                    .foregroundColor(.cardProfileLetter)
                                                            }
                                                        }
                                                        
                                                        Text(athlete1.firstName)
                                                            .font(.caption2)
                                                            .foregroundColor(.cardText)
                                                    }
                                                    VStack(spacing: 2){
                                                        
                                                        Rectangle()
                                                            .frame(width: 1, height: 26)
                                                            .foregroundColor(.clear)
                                                        
                                                        Text(" +1")
                                                            .font(.caption2)
                                                            .foregroundColor(.cardText)
                                                            .offset(x: -10)
                                                    }
                                                }
                                            }
                                        } else {
                                            // do the circles and have it as if clause
                                            ForEach(session.athleteIDs[0...3], id: \.self) {athleteID in
                                                if let athlete = sessionVM.getAthletes(with: athleteID){
                                                    VStack(spacing: 2){
                                                        ZStack{
                                                            Circle()
                                                                .frame(width: 26, height: 26)
                                                                .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                                            Text(getInitials(firstName: athlete.firstName, lastName: athlete.lastName))
                                                                .font(.caption2)
                                                                .fontWeight(.semibold)
                                                                .foregroundColor(.cardProfileLetter)
                                                        }
                                                        Text(athlete.firstName)
                                                            .font(.caption2)
                                                            .foregroundColor(.cardText)
                                                    }
                                                }
                                            }
                                            // display the 5th + 6th + 7th
                                            
                                            if let athlete1 = sessionVM.getAthletes(with: session.athleteIDs[4]){
                                                HStack{
                                                    VStack(spacing: 2){
                                                        ZStack{
                                                            if let athlete3 = sessionVM.getAthletes(with: session.athleteIDs[6]){
                                                                ZStack{
                                                                    Circle()
                                                                        .frame(width: 18, height: 18)
                                                                        .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                                                    Text(getInitials(firstName: athlete3.firstName, lastName: athlete3.lastName))
                                                                        .font(.system(size: 7, weight: .light, design: .default))
                                                                        .fontWeight(.semibold)
                                                                        .foregroundColor(.cardProfileLetter)
                                                                        .offset(x: 2)
                                                                }.offset(x: 28, y: -4)
                                                            }
                                                            
                                                            if let athlete2 = sessionVM.getAthletes(with: session.athleteIDs[5]){
                                                                ZStack{
                                                                    Circle()
                                                                        .frame(width: 22, height: 22)
                                                                        .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                                                    Text(getInitials(firstName: athlete2.firstName, lastName: athlete2.lastName))
                                                                        .font(.system(size: 9, weight: .light, design: .default))
                                                                        .fontWeight(.semibold)
                                                                        .foregroundColor(.cardProfileLetter)
                                                                        .offset(x: 2)
                                                                }.offset(x: 16, y: -2)
                                                            }
                                                            
                                                            ZStack{
                                                                Circle()
                                                                    .frame(width: 26, height: 26)
                                                                    .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey1)
                                                                Text(getInitials(firstName: athlete1.firstName, lastName: athlete1.lastName))
                                                                    .font(.caption2)
                                                                    .fontWeight(.semibold)
                                                                    .foregroundColor(.cardProfileLetter)
                                                            }
                                                        }
                                                        
                                                        
                                                        Text(athlete1.firstName)
                                                            .font(.caption2)
                                                            .foregroundColor(.cardText)
                                                        
                                                    }
                                                    VStack(spacing: 2){
                                                        
                                                        Rectangle()
                                                            .frame(width: 1, height: 26)
                                                            .foregroundColor(.clear)
                                                        
                                                        Text(" +\(session.athleteIDs.count - 5)")
                                                            .font(.caption2)
                                                            .foregroundColor(.cardText)
                                                            .offset(x: -10)
                                                    }
                                                }
                                            }
                                            
                                        }
                                }
                            }
                            .padding(.horizontal, 34)
                            Spacer()
                        }
                        .padding(.bottom, 6)
                        //Athletes
                    }
                    //
                })
            }
        }
        .background(RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.accentMidGround)
            .frame(maxWidth: .infinity)
                    //.frame(height: 100)
            .padding(.horizontal))
    }
    
    func getInitials(firstName: String, lastName: String) -> String {
        let firstLetter = firstName.first?.uppercased() ?? ""
        let lastLetter = lastName.first?.uppercased() ?? ""
        return firstLetter + lastLetter
    }
    
}
