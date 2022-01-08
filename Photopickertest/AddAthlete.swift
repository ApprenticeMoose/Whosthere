//
//  ContentView.swift
//  Photopickertest
//
//  Created by Moose on 20.11.21.
//

import SwiftUI

struct AddAthleteView: View {
    @State private var showPhotoLibrary = false
    @State var image: Image?
    @State var firstName = ""
    @State var lastName = ""
    @State var birthday = ""
    @State var male = false
    @State var female = false
    @State var nonbinary = false
    
    var body: some View {
        
        VStack{
            //Header HStack
            HStack(alignment: .top){
                
                Button(action: {
                    //backbutton
                }){
                    Image(systemName: "chevron.backward.square.fill")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                
                Spacer(minLength: 0)
                
                
                Text("Add Athlete")
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                
                Spacer(minLength: 0)
                
                Button(action: {
                    //addbutton
                }){
                    Image(systemName: "checkmark.square.fill")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }//Button
            }//HeaderHStackEnding
            .padding()
            
            
            
            
            VStack{
                Spacer(minLength: 30)
                Spacer()
                
                image?
                    .resizable()
                    .frame(width: 96, height: 96, alignment: .center)
                    .clipShape(Circle())
                    .padding()
                
                
                Spacer()
                
                Button(action: {
                    showPhotoLibrary = true
                })      {
                    ZStack {
                        Rectangle()
                            .frame(minWidth: 0, maxWidth: 100, minHeight: 0, maxHeight: 100)
                            .background(Color.white)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .padding()
                        
                        Rectangle()
                            .frame(minWidth: 0, maxWidth: 96, minHeight: 0, maxHeight: 96)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                            .foregroundColor(Color.greyFourColor)
                            .padding()
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 42, height: 42, alignment: .center)
                            .foregroundColor(Color.greyTwoColor)
                    }
                }//ButtonProfilePcitureDescription end
                
                VStack{
                    //Firstname
                    Text("First Name")
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                    
                    TextField("", text: $firstName)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Color.white)
                        .frame(height:44)
                        .cornerRadius(10)
                }
                .padding()
                
                VStack{
                    //Lastname
                    Text("Last Name")
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                    
                    TextField("", text: $lastName)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Color.white)
                        .frame(height:44)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                HStack {
                    VStack{
                        //DateofBirth
                        Text("Birthday")
                            .font(.body)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                        
                        TextField("", text: $birthday)
                            
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .frame(height: 44)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    
                    
                    VStack{
                        //Gender
                        Text("Gender")
                            .font(.body)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 5)
                        
                        
                        
                        HStack {
                            //Buttons for gender
                            Button(action: {
                                male.toggle()
                                female = false
                                nonbinary = false
                            }) {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(10)
                                        .foregroundColor(male ? Color.accentColor: Color.white)
                                    Image("MaleIcon")
                                        .foregroundColor(male ? Color.white: Color.accentColor)
                                }
                            }
                            
                            Button(action: {
                                female.toggle()
                                male = false
                                nonbinary = false
                            }) {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(10)
                                        .foregroundColor(female ? Color.accentColor: Color.white)
                                    Image("FemaleIcon")
                                        .foregroundColor(female ? Color.white: Color.accentColor)
                                }
                            }
                            
                            Button(action: {
                                nonbinary.toggle()
                                male = false
                                female = false
                            }) {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(10)
                                        .foregroundColor(nonbinary ? Color.accentColor: Color.white)
                                    Image("NonBinaryIcon")
                                        .foregroundColor(nonbinary ? Color.white: Color.accentColor)
                                }
                            }
                            
                           
                            
                            
                                
                        }
                        
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical)
                
                Button(action: {
                    
                })      {
                    HStack{
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                        Text("Add Athlete")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 55)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }//VStackBackgroundColorAreaEnd
            .background(Color.backgroundColor
                            .clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 20))
                            .ignoresSafeArea(.all, edges: .bottom))
            .textFieldStyle(PlainTextFieldStyle())
            
        } //VStackEntierScreenEnd
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.accentColor.ignoresSafeArea())
        .sheet(isPresented: $showPhotoLibrary){
            PhotoPicker(isPresented: $showPhotoLibrary, selectedImage: $image)
        }//sheet end
        
        
    }//body end
}//Contentview end



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddAthleteView()
        }
    }
}


