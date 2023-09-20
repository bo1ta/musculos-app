//
//  WorkoutFeedView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.07.2023.
//

import SwiftUI

struct WorkoutFeedView: View {
    @StateObject var viewModel = WorkoutFeedViewModel()

    private let options = ["Mix workout", "Home workout", "Gym workout"]
    
    var body: some View {
        backgroundView {
            VStack(spacing: 5) {
                SearchBarView(placeholderText: "Search workouts", searchQuery: $viewModel.searchQuery, onFiltersTapped: {
                    self.viewModel.isFiltersPresented.toggle()
                })

                ButtonHorizontalStackView(selectedOption: $viewModel.selectedFilter, options: self.options, buttonsHaveEqualWidth: false)

                ScrollView(.vertical, showsIndicators: false, content: {
                    CurrentWorkoutCardView(title: "Day 4", subtitle: "Start your 4th day workout", content: "AB Crunches", imageName: "deadlift-background-2", options: [IconPillOption(title: "15 min"), IconPillOption(title: "234 kcal")])
                    
                    if let searchResults = viewModel.searchResults {
                        ForEach(searchResults) { result in
                            MiniCardView(item: MiniCardItem(title: result.name, subtitle: result.category, description: "", color: .black))
                        }
                    }
                    
                    MiniCardWheelView(items: self.miniCardItems)
                })
                .padding(0)
            }
        }
        .onAppear(perform: {
            Task {
                await self.viewModel.loadExercises()
            }
        })
        .sheet(isPresented: $viewModel.isFiltersPresented) {
            WorkoutFiltersView { filters in
                MusculosLogger.log(.info, message: "Showing filters: \(filters)", category: .ui)
            }
        }
    }
    
    private var miniCardItems: [MiniCardItem] {
        let exercises = self.viewModel.currentExercises
        if exercises.count > 0 {
            return exercises.map({
                MiniCardItem(title: $0.name, subtitle: $0.created, description: $0.description ?? "", imageName: "workout-crunches")
            })
        } else {
            return []
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
