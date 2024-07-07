//
//  ExploreExerciseView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import SwiftUI

struct ExploreExerciseView: View {
  @Environment(\.appManager) private var appManager

  @State private var viewModel = ExploreExerciseViewModel()
  
  var body: some View {
    NavigationStack {
      VStack {
        ScrollView {
          
          if let goal = viewModel.displayGoal {
            ProgressCard(
              title: "You've completed \(goal.currentValue) exercises",
              description: "\(goal.formattedProgressPercentage) of your \(goal.frequency.description) \(goal.name) goal",
              progress: Float(goal.progressPercentage / 100)
            )
            .padding(.horizontal, 10)
            .padding(.top, 20)
          } else {
            InformationCard(
              title: "No goals selected",
              description: "Add some goals to track your fitness progress",
              style: .general
            )
          }
          
          SearchFilterField(
            showFilterView: $viewModel.showFilterView,
            hasObservedQuery: { viewModel.searchByMuscleQuery($0) }
          )
          
          ExerciseSectionsContentView(
            categorySection: $viewModel.currentSection,
            contentState: $viewModel.contentState,
            recommendedExercisesByGoals: $viewModel.recommendedByGoals,
            recommendedExercisesByPastSessions: $viewModel.recommendedByPastSessions,
            onExerciseTap: { viewModel.selectedExercise = $0 }
          )
          .transition(.slide)
          
          WhiteBackgroundCard()
        }
        .animation(.snappy(), value: viewModel.currentSection)
        .scrollIndicators(.hidden)
      }
      .popover(isPresented: $viewModel.showFilterView) {
        ExerciseFilterView(onFiltered: { filteredExercises in
          viewModel.contentState = .loaded(filteredExercises)
        })
      }
      .navigationDestination(isPresented: $viewModel.showExerciseDetails) {
        if let exercise = viewModel.selectedExercise {
          ExerciseDetailsView(exercise: exercise)
        }
      }
      .onAppear {
        appManager.showTabBar()
      }
      .task {
        await viewModel.initialLoad()
      }
      .onDisappear(perform: viewModel.cleanUp)
    }
  }
}

#Preview {
  ExploreExerciseView()
}

