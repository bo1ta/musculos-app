//
//  WorkoutFeedView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.07.2023.
//

import SwiftUI

struct WorkoutFeedView: View {
    @State private var selectedFilter: String = ""
    private let options = ["Mix workout", "Home workout", "Gym workout"]
    
    
    var body: some View {
        backgroundView {
            VStack(spacing: 1) {
                SearchBar(placeholderText: "Search workouts")
                ButtonHorizontalStack(selectedOption: $selectedFilter, options: self.options)
                WorkoutCard(title: "Day 4", subtitle: "Start your 4th day workout", content: "AB Crunches", imageName: "workout-crunches", options: [IconPillOption(title: "15 min"), IconPillOption(title: "234 kcal")])
                Spacer()
            }
            .padding(1)
        }
    }
    
    @ViewBuilder private func backgroundView(@ViewBuilder content: () -> some View) -> some View {
        ZStack {
            Image("weightlifting-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .overlay {
                    Color.black
                        .opacity(0.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                }
            
            content()
        }
    }
}

struct WorkoutFeedView_Preview: PreviewProvider {
    static var previews: some View {
        WorkoutFeedView()
    }
}
