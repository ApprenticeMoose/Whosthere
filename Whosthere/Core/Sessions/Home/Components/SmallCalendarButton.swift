//
//  SmallCalendarButton.swift
//  Whosthere
//
//  Created by Moose on 20.10.22.
//
import SwiftUI

struct SmallCalendarButton: View {
    
    var body: some View {
        VStack{
            ZStack{
                
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.accentMidGround)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.clear, lineWidth: 1.0)
                        .frame(width: 40, height: 40)
                }
                
                ZStack{
                VStack {
                    Text("o")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.clear)
                    
                    HStack(spacing: 0){
                        Text("o")
                            .font(.caption2)
                            .fontWeight(.regular)
                        Text("o")
                            .font(.caption2)
                            .fontWeight(.regular)
                        
                    }
                    .foregroundColor(.clear)
                }
                    Image(systemName: "calendar")
                        .foregroundColor(Color.header)
            }
                
                
            
            
        }
                Capsule()
                    .frame(width: 4, height: 4)
                    .foregroundColor(.clear)
                    .offset(y: -3)
        }
        .padding(.bottom, 0)
        
       /* VStack{
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.accentMidGround)
            Image(systemName: "calendar")
                .foregroundColor(Color.header)
        }
        Capsule()
            .frame(width: 4, height: 11)
            .foregroundColor(.clear)
            .offset(y: -3)
        }*/
    }
}
