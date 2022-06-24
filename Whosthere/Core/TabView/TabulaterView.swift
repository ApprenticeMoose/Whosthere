//
//  Tabview.swift
//  Whosthere
//
//  Created by Moose on 24.06.22.
//

/*import SwiftUI

struct TabulaterView: View {
    
    @State var selectedTab = "person.3"
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            
            AthletesListView()
            
            HStack(spacing: 0){
                
                //ForEach(tabs, id: \.self) {image in
                    
                    TabButton(image: "doc.text", tabName: "Sessions", selectedTab: $selectedTab)
                    TabButton(image: T##String, tabName: T##String, selectedTab: T##Binding<String>)
                    
                    //equal spacing
                   // if image != tabs.last {
                     //   Spacer(minLength: 0)
                    //}
                //}
            }
            .padding(.horizontal, 25)
            .padding(.vertical,5)
            .background(Color.white)
            .clipShape(Capsule())
            .padding(.horizontal)
        }
    }
}



struct Tabs : Identifiable {
    var id = UUID().uuidString
    var tabName: String
    var tabImage: String
}

var tabs = [
    Tabs(tabName: "Sessions", tabImage: "doc.text"),
    Tabs(tabName: "Statistics", tabImage: "chart.xyaxis.line"),
    Tabs(tabName: "Athletes", tabImage: "person.3"),
    Tabs(tabName: "Settings", tabImage: "gearshape")
                 ]
     
                 
struct TabButton: View {
    
    var image: String
    var tabName: String
    @Binding var selectedTab: String
    
    var body: some View {
        
        Button(action:{selectedTab = image}) {
            VStack{
            Image(systemName: image)
                //.renderingMode(.template)
                .font(.title2)
                
                Text(tabName)
                    .font(.caption.bold())
            }
            .foregroundColor(selectedTab == image ? Color.orangeAccentColor : Color.black.opacity(0.4))
            .padding()
        }
    }
}

struct Tabview_Previews: PreviewProvider {
    static var previews: some View {
        TabulaterView()
    }
}
*/
