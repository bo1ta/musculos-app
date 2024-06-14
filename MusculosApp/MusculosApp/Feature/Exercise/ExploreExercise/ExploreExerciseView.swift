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
          ProgressCard(
            title: "You've completed \(viewModel.exercisesCompletedToday.count) exercises",
            description: "75% of your weekly muscle building goal",
            progress: 0.75
          )
          .padding([.leading, .trailing], 10)
          .padding(.top, 20)
          
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
          
          WhiteBackgroundCard()
        }
        .scrollIndicators(.hidden)
      }
      .popover(isPresented: $viewModel.showFilterView) {
        ExerciseFilterView(onFiltered: { filteredExercises in
          viewModel.updateContentState(with: filteredExercises)
        })
      }
      .background(
        Image("white-patterns-background")
          .resizable(resizingMode: .tile)
          .opacity(0.1)
      )
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

typealias ExploreExerciseResult = [ExploreExerciseContentType: [Exercise]]

enum ExploreExerciseContentType {
  case random
  case recommendedByGoals
  case recommendedByPastWorkouts
}
