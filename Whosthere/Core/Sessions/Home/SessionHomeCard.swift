//
//  SessionHomeCard.swift
//  Whosthere
//
//  Created by Moose on 24.09.22.
//

import SwiftUI

struct SessionHomeCard: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 6){
            HStack{
                Text("Monday, 19th July")
                    .foregroundColor(.subTitle)
                    .padding(.horizontal, 22)
                Spacer()
            }
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.accentMidGround)
                    .frame(maxWidth: .infinity)
                    .frame(height: 94)
                    .padding(.horizontal)
                VStack(spacing: 6){
                    HStack{
                        //clock time and 3point button
                        HStack{
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text("17:00")
                            .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 18)
                        Spacer()
                        Button {
                            //open little menu to dublicate delete etc
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
                            .offset(y: -2.5)
                        }

                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)
                    .padding(.bottom, 4)
                    
                    //Line
                    HStack{
                    Rectangle()
                            .frame(width: 245, height: 1.5, alignment: .center)
                        .foregroundColor(colorScheme == .light ? .cardGrey1.opacity(0.35) : .header.opacity(0.15))
                        .padding(.horizontal, 26)
                    Spacer()
                    }
                    HStack{
                        //Athletes
                        HStack(spacing: 12){
                        VStack(spacing: 2){
                            Circle()
                                .frame(width: 26, height: 26)
                                .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey3)
                            Text("Asbat")
                                .font(.caption2)
                                .foregroundColor(.cardText)
                        }
                        VStack(spacing: 2){
                            Circle()
                                .frame(width: 26, height: 26)
                                .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey3)
                            Text("Mustafa")
                                .font(.caption2)
                                .foregroundColor(.cardText)
                        }
                        VStack(spacing: 2){
                            Circle()
                                .frame(width: 26, height: 26)
                                .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey3)
                            Text("Asbat")
                                .font(.caption2)
                                .foregroundColor(.cardText)
                        }
                        VStack(spacing: 2){
                            Circle()
                                .frame(width: 26, height: 26)
                                .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey3)
                            Text("Asbat")
                                .font(.caption2)
                                .foregroundColor(.cardText)
                        }
                            VStack(spacing: 2){
                                Circle()
                                    .frame(width: 26, height: 26)
                                    .foregroundColor(colorScheme == .light ? .cardGrey3 : .cardGrey3)
                                Text("Asbat")
                                    .font(.caption2)
                                    .foregroundColor(.cardText)
                            }

                    }
                        .padding(.horizontal, 34)
                        Spacer()
                    }
                    
                }
            }
            
        }
        
    }
}

struct SessionHomeCard_Previews: PreviewProvider {
    static var previews: some View {
        SessionHomeCard()
    }
}
