//
//  AthleteDetailView.swift
//  Whosthere
//
//  Created by Moose on 31.01.22.
//

import SwiftUI


struct AthleteDetailLoadingView: View {
    
    @Binding var athlete: AthletesModel?
    
    var body: some View {
        ZStack{
            if let athlete = athlete {
                AthleteDetailView(athlete: athlete)
            }
        }
    }
}


struct AthleteDetailView: View {
    
    let athlete: AthletesModel
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    init(athlete: AthletesModel) {
        self.athlete = athlete
        print("Initializing Detail View for: \(String(describing: athlete.firstName))")
    }
    
    var body: some View {
        
                VStack(spacing: 20){
                    HStack {
                        Text(athlete.firstName)
                        Text(athlete.lastName)
                    }
                    Text(dateFormatter.string(from: athlete.birthday))
                    }
            }
        
}

struct AthleteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AthleteDetailView(athlete: dev.athlete)
    }
}
