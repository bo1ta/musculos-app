//
//  WorkoutCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct WorkoutCard: View {
    var title: String
    var subtitle: String
    var content: String
    var imageName: String
    
    var body: some View {
        VStack {
            self.topSection
            
            Spacer()
            
            self.bottomSection
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
        .frame(height: 240)
    }
    
    @ViewBuilder private var topSection: some View {
        HStack {
            VStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding([.top, .leading], 5)
            Spacer()
        }
    }
    
    @ViewBuilder private var bottomSection: some View {
        HStack {
            Text(content)
                .font(.body)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct WorkoutCard_Preview: PreviewProvider {
    static var previews: some View {
        WorkoutCard(title: "Back workout", subtitle: "Start your first week", content: "Body contouring", imageName: "deadlift-background")
    }
}
