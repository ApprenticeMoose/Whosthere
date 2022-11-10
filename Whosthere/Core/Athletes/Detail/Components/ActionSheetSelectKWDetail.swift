//
//  ActionSheetSelectKWDetail.swift
//  Whosthere
//
//  Created by Moose on 05.11.22.
//

import SwiftUI
import OrderedCollections

extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric , height: 150)
    }
}

struct ActionSheetSelectKWDetail: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var showActionSheet: Bool
    @Binding var refresh: Bool
    @ObservedObject var datesVM: DatesVM    
    @State var kw1: Date
    @State var kw2: Date
    
    
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
                
                Text("Sort")
                .fontWeight(.semibold)
                .font(.title3)
                .foregroundColor(.midTitle)
                
                Spacer()
                
                //Apply button
                    Button {
                        refresh.toggle()
                        withAnimation {
                            showActionSheet.toggle()
                        }
                        UserDefaults.standard.dateFilterAttendance = PickerDates(date1: kw1, date2: kw2)
                        
                        
                        
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
        .edgesIgnoringSafeArea(.bottom)
       // }
    }
    
}

struct ActionSheetKWSelectDetail_Previews: PreviewProvider {
    @State static var isShowing = false
    @State static var refresh = false
    static var previews: some View {
        ActionSheetSelectKWDetail(showActionSheet: $isShowing, refresh: $refresh, datesVM: DatesVM(), kw1: Date().startOfWeek(), kw2: Date().endOfWeek())
    }
}
