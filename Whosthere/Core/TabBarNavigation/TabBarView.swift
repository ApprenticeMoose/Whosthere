//
//  TabBarView.swift
//  Whosthere
//
//  Created by Moose on 04.08.22.
//

import SwiftUI

struct TabBar: View {
    
    @AppStorage("selectedTab") var selectedTab: Tab = .sessions
    @Environment(\.colorScheme) var colorScheme                     //DarkMode
    @State var color: Color = .blue
    @State var tabItemWidth: CGFloat = 0
    
//    var tabIconColorUnselected: Color {
//        colorScheme == .light ? Color.black : Color.detailGray2
//    }
    
    //MARK: Body
    
    var body: some View {
//        GeometryReader { proxy in
//            let hasHomeIndicator = proxy.safeAreaInsets.bottom - 44 > 20
            //detects if phone is se or Xand up and based on that the appearance changes...wont need that for my app tab bar but really interesting
            HStack {
                buttons
            }
            .padding(.horizontal, 8)
            .padding(.top, 4)
            .padding(.bottom, 24)
            .background(Color.appBackground)
//            .shadow(color: .black.opacity(0.09), radius: 5, x: 5, y: 5)
//            .shadow(color: .black.opacity(0.09), radius: 5, x: -5, y: 0)

            .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
//        }
        
    }
    
    //MARK: Buttons
    
    var buttons: some View {
        
        ForEach(tabItems) { item in
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = item.tab
                }
            } label: {
                VStack(spacing: 0) {
                    Image(systemName: item.icon)
                        .font(.title2)
                    // setting same height for all images...
                    // to avoid the animation glitch..
                        .frame(height: 29)
                        .padding(2)

                    Text(item.text)
                        .font(.caption.bold())
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundColor(selectedTab == item.tab ? Color.header : Color.subTitle.opacity(0.30))
        }
    }
}



struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
