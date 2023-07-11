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
            VStack(spacing: 5) {
                SearchBar(placeholderText: "Search workouts")
                ButtonHorizontalStack(selectedOption: $selectedFilter, options: self.options)
                CurrentWorkoutCard(title: "Day 4", subtitle: "Start your 4th day workout", content: "AB Crunches", imageName: "deadlift-background-2", options: [IconPillOption(title: "15 min"), IconPillOption(title: "234 kcal")])
                    .padding([.leading, .trailing], 10)
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
