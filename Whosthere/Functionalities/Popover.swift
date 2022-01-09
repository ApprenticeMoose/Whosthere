//
//  Popover.swift
//  DatePickerExperiment
//
//  Created by Moose on 07.01.22.
//

import SwiftUI

extension View{
    func fieldPopover<Content: View>(show: Binding<Bool>,@ViewBuilder content: @escaping()->Content)->some View{
        
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
            
                ZStack{
                    
                    if show.wrappedValue{
        
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.middlegroundColor)
                                .frame(width: 300, height: 270, alignment: .bottom)
                            
                                
                            
                            content()
                                .padding()
                                .offset(y: 20)
                                
                            
                        
                        
                    }
                }
                .offset(y: -10)
                ,alignment: .bottomLeading
                    
            )
    }
}

struct Popover_Previews: PreviewProvider {
    static var previews: some View {
        AddAthleteView()
            
    }
}
