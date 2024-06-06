//
//  ExploreExerciseView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import SwiftUI

struct ExploreExerciseView: View {
  @EnvironmentObject private var exerciseStore: ExerciseStore
  @EnvironmentObject private var exerciseSessionStore: ExerciseSessionStore
  
  @EnvironmentObject private var appManager: AppManager

  @StateObject private var viewModel = ExploreExerciseViewModel()
  
  var body: some View {
    NavigationStack {
      VStack {
        ScrollView {
          ProgressCard(
            title: "You've completed \(viewModel.completedToday.count) exercises",
            description: "75% of your weekly muscle building goal",
            progress: 0.75
          )
          .padding([.leading, .trailing], 10)
          .padding(.top, 20)
          
          SearchFilterField(
            showFilterView: $viewModel.showFilterView,
            hasObservedQuery: { query in
              exerciseStore.searchByMuscleQuery(query)
            })
          
          ExerciseSectionsContentView(onSelected: { exercise in
            viewModel.selectedExercise = exercise
          })
          
          WhiteBackgroundCard()
        }
        .scrollIndicators(.hidden)
      }
      .popover(isPresented: $viewModel.showFilterView) {
        ExerciseFilterView()
      }
      .onReceive(appManager.didUpdateSubject, perform: { updatedSubject in
        switch updatedSubject {
        case .exerciseSession:
          Task { await viewModel.loadExercisesCompletedToday() }
        case .goal:
          Task { await viewModel.loadGoals() }
        }
      })
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
      .task { await viewModel.initialLoad() }
      
      .onDisappear(perform: exerciseStore.cleanUp)
    }
  }
}

#Preview {
  ExploreExerciseView()
    .environmentObject(ExerciseStore())
    .environmentObject(ExerciseSessionStore())
    .environmentObject(AppManager())
}
