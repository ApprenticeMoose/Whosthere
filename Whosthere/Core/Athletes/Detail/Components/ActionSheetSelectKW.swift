//
//  ActionSheetSelectKWDetail.swift
//  Whosthere
//
//  Created by Moose on 05.11.22.
//

import SwiftUI
import OrderedCollections

enum ActionSheetCall: String {
    case detail, statistics
}

extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric , height: 150)
    }
}

struct ActionSheetSelectKW: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var showActionSheet: Bool
    @Binding var refresh: Bool
    @Binding var animate: Bool
    @ObservedObject var datesVM: DatesVM
 //   @ObservedObject var dataDetailVM: DetailDataVM
    @State var kw1: Date
    @State var kw2: Date
    var type: ActionSheetCall
    
    var body: some View {
        //GeometryReader { geometry in
        VStack(spacing: 0){
            HStack{
                        HStack{
                            Image(systemName: "checkmark")
                                .resizable()
                                .foregroundColor(.clear)
                                .frame(width: 20, height: 15.3)
                        }
                        .padding(.vertical, 10)
                        .padding(.leading, 10)
                        .padding(.trailing, 5)
                        .offset(y: -1)
                    
                Spacer()
                
                Text("Select")
                .fontWeight(.semibold)
                .font(.title3)
                .foregroundColor(.midTitle)
                
                Spacer()
                
                //Apply button
                    Button {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(301), execute: {
                            if type == ActionSheetCall.detail {
                                UserDefaults.standard.dateFilterAttendance = PickerDates(date1: kw1, date2: kw2)
                            } else if type == ActionSheetCall.statistics {
                                UserDefaults.standard.dateFilterStatistics = PickerDates(date1: kw1, date2: kw2)
                            }
                                animate.toggle()
                        })
                        
                        withAnimation {
                            showActionSheet.toggle()
                        }
                        
                        
                        
                         //do all the UserDefaults stuff
                        
                        
                        
                    } label: {
                        HStack{
                            Image(systemName: "checkmark")
                                .resizable()
                                .foregroundColor(.midTitle)
                                .frame(width: 20, height: 15.3)
                        }
                        .padding(.vertical, 10)
                        .padding(.leading, 10)
                        .padding(.trailing, 5)
                        .offset(y: -3)
                    }
            }
            .padding(.vertical, 1)
            
            
            HStack{
                Picker("", selection: $kw1) {
                    ForEach(datesVM.arrayOfDatesToPick1, id: \.self) { date in
                        Text("KW " + "\(date.extractWeek())")
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal, 10)
                        .frame(maxWidth: UIScreen.main.bounds.width / 2.25)
                        .frame(height: 160)
                        .clipped()
                        .onChange(of: kw1) { v in
                            if kw1 >= kw2 {
                                kw2 = kw1.endOfWeek()
                            }
                        }
                
                Picker("", selection: $kw2) {
                    ForEach(datesVM.arrayOfDatesToPick2, id: \.self) { date in
                        Text("KW " + "\(date.extractWeek())")
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal, 10)
                        .frame(maxWidth: UIScreen.main.bounds.width / 2.25)
                        .frame(height: 160)
                        .clipped()
                        .onChange(of: kw2) { v in
                            if kw2 <= kw1 {
                                kw1 = kw2.startOfWeek()
                            }
                        }
            }
            .padding(.bottom, 6)
                HStack{
                    ZStack{
                        Capsule()
                            .frame(width: 8, height: 1.75)
                        HStack{
                            Spacer()
                            Text("\(kw1.formatted(.dateTime.day().month(.abbreviated).year(.twoDigits)))")
                                .fontWeight(.semibold)
                                .offset(x: 8)
                            Spacer()
                            Spacer()
                            Spacer()
                                
                            Text("\(kw2.formatted(.dateTime.day().month(.abbreviated).year(.twoDigits)))")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, 12)
                
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(Color.appBackground.clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 20)))
        .frame(width: UIScreen.main.bounds.width)
        .edgesIgnoringSafeArea(.bottom)
       // }
    }
    
}

struct ActionSheetKWSelectDetail_Previews: PreviewProvider {
    @State static var isShowing = false
    @State static var refresh = false
    @State static var animate = false
    
    static var previews: some View {
        ActionSheetSelectKW(showActionSheet: $isShowing, refresh: $refresh, animate: $animate, datesVM: DatesVM(), kw1: Date().startOfWeek(), kw2: Date().endOfWeek(), type: ActionSheetCall.detail)
    }
 }
