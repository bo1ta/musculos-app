//
//  WorkoutFeedView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.07.2023.
//

import SwiftUI

struct WorkoutFeedView: View {
    @State private var selectedFilter: String = ""
    @State private var isFiltersPresented = false

    private let options = ["Mix workout", "Home workout", "Gym workout"]
    
    var body: some View {
        backgroundView {
            VStack(spacing: 5) {
                SearchBarView(placeholderText: "Search workouts", onFiltersTapped: {
                    isFiltersPresented.toggle()
                })

                ButtonHorizontalStackView(selectedOption: $selectedFilter, options: self.options, buttonsHaveEqualWidth: false)

                ScrollView(.vertical, showsIndicators: false, content: {
                    CurrentWorkoutCardView(title: "Day 4", subtitle: "Start your 4th day workout", content: "AB Crunches", imageName: "deadlift-background-2", options: [IconPillOption(title: "15 min"), IconPillOption(title: "234 kcal")])
                    
                    MiniCardWheelView(items: [
                        MiniCardItem(title: "Featured workout", subtitle: "Gym workout", description: "Body contouring", color: Color.black, iconPillOption: IconPillOption(title: "In progress")),
                        MiniCardItem(title: "Workout crunches", subtitle: "Home workout", description: "6-pack exercise", imageName: "workout-crunches")
                    ])
                })
                .padding(0)
                
            }
        }
        .sheet(isPresented: $isFiltersPresented) {
            WorkoutFiltersView { filters in
                MusculosLogger.log(.info, message: "Showing filters: \(filters)", category: .ui)
            }
        }
    }
    
    @ViewBuilder
    private func backgroundView(@ViewBuilder content: () -> some View) -> some View {
        ZStack {
            Image("weightlifting-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .overlay {
                    Color.black
                        .opacity(0.8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                }
            
            content()
                .padding(4)
        }
    }
}

struct WorkoutFeedView_Preview: PreviewProvider {
    static var previews: some View {
        WorkoutFeedView()
    }
}
