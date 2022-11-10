//
//  ActionSheet.swift
//  Whosthere
//
//  Created by Moose on 20.10.22.
//
import SwiftUI

struct ActionSheetDuplicateDeleteSesssion: View {
    
    @Environment(\.colorScheme) var colorScheme
    let session: Session
    @Binding var showActionSheet: Bool
    @State var showSheet: Bool = false
    
    @State var showAlert: Bool = false
    @ObservedObject var sessionHomeVM: SessionHomeVM
    @ObservedObject var datesVM: DatesVM
    @Binding var duplicationLabelOpacityActionSheet: Double
    
    var body: some View {
        
        VStack{
            
            Button {
                //duplicate
                showSheet.toggle()
            } label: {
                HStack{
                    Spacer()
                    Image(systemName: "doc.on.doc.fill")
                        .font(.system(size: 20))
                        .padding(.horizontal, 5)
                    Text("Duplicate")
                        .fontWeight(.semibold)
                    Spacer()
                }
                .foregroundColor(.midTitle)
                .padding(.vertical, 12)
                .fullScreenCover(isPresented: $showSheet, content: {
                    DuplicateSessionView(session: session, selectedDay: $datesVM.selectedDay, duplicationLabelOpacity: $duplicationLabelOpacityActionSheet)
                })
            }
            
            
            
            Rectangle()
                .frame(height: 1.5, alignment: .center)
                .foregroundColor(colorScheme == .light ? .cardGrey1.opacity(0.35) : .header.opacity(0.15))
                .padding(.horizontal, 16)
            
            
            
            Button {
                //delete session
                showAlert.toggle()
            } label: {
                HStack{
                    Spacer()
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                        .padding(.horizontal, 5)
                    Text("Delete")
                        .fontWeight(.semibold)
                    Spacer()
                }
                .foregroundColor(.deleteButton)
                .padding(.vertical, 12)
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Are you sure you want to delete the following session?\n\(session.date, style: .date)\n\(session.date, style: .time)"),
                          message: Text("This action cannot be undone!"),
                          primaryButton: .destructive(Text("Delete"),
                                                      action: {
                        sessionHomeVM.deleteSession(session: session)
                        withAnimation {
                            showActionSheet.toggle()
                        }
                    }),
                          secondaryButton: .cancel())
                })
            }
            
            
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(Color.appBackground.clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 20)))
        .edgesIgnoringSafeArea(.bottom)
    }
    
}
