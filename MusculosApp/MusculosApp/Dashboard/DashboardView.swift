//
//  DashboardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import SwiftUI

struct DashboardView: View {
  @EnvironmentObject private var userStore: UserStore
  @EnvironmentObject private var exerciseStore: ExerciseStore
  @EnvironmentObject private var tabBarSettings: TabBarSettings

  @State private var searchQuery: String = ""
  @State private var showFilterView: Bool = false
  @State private var showExerciseDetails: Bool = false
    
  @State private var selectedExercise: Exercise? = nil {
    didSet {
      if selectedExercise != nil {
        showExerciseDetails = true
      }
    }
  }

  var body: some View {
    NavigationStack {
      VStack {
        DashboardHeaderView()
        ScrollView() {
          ProgressCardView(
            title: "You've completed 3 exercises",
            description: "75% of your weekly muscle building goal",
            progress: 0.75
          )
          .padding([.leading, .trailing], 10)
          .padding(.top, 20)
          
          switch exerciseStore.state {
          case .loading:
           DashboardLoadingView()
              .task {
                await userStore.fetchUserProfile()
                await exerciseStore.loadExercises()
              }
          case .loaded(let exercises):
            DashboardCategorySection(content: { categorySection in
              makeCategoryItems(
                categorySection,
                exercises: exercises
              )
            }, hasChangedSection: { handleChangeCategorySection($0) })
          case .empty(_):
            HintIconView(systemImage: "alert", textHint: "No data found!")
          case .error(_):
            HintIconView(systemImage: "alert", textHint: "Could not fetch exercises!")
          }
        }
        .scrollIndicators(.hidden)
        .padding(.bottom, 100)
      }
      .popover(isPresented: $showFilterView) {
        SearchFilterView()
      }
      .background(
        Image("white-patterns-background")
        .resizable(resizingMode: .tile)
        .opacity(0.1)
      )
      .navigationDestination(isPresented: $showExerciseDetails) {
        if let exercise = selectedExercise {
          ExerciseDetailsView(exercise: exercise)
        }
      }
      .onAppear {
        DispatchQueue.main.async {
          tabBarSettings.isTabBarHidden = false
        }
      }
      .onDisappear {
        exerciseStore.cleanUp()
      }
      .ignoresSafeArea()
    }
  }
  
  private func handleChangeCategorySection(_ categorySection: CategorySection) {
    if categorySection == .myFavorites || categorySection == .workout {
      exerciseStore.loadLocalExercises()
    } else {
      Task { await exerciseStore.loadExercises() }
    }
  }
  
  @ViewBuilder
  private func makeCategoryItems(
    _ categorySection: CategorySection,
    exercises: [Exercise]
  ) -> some View {
    VStack {
      switch categorySection {
      case .discover:
          SearchFilterFieldView(
            showFilterView: $showFilterView,
            hasObservedQuery: { query in
              exerciseStore.searchByMuscleQuery(query)
            })
          
        ExerciseCardSection(title: "Most popular", exercises: exerciseStore.discoverExercises.first ?? [], onExerciseTap: {
            exercise in
            selectedExercise = exercise
          })
          ExerciseCardSection(title: "Quick muscle-building workouts", exercises: exerciseStore.discoverExercises[safe: 1] ?? [], isSmallCard: true, onExerciseTap: {
            exercise in
            selectedExercise = exercise
          })
      case .myFavorites:
        HintIconView(systemImage: "dumbbell", textHint: "Favorite exercises!")
      case .workout:
          ForEach(exercises, id: \.hashValue) { exercise in
            Button(action: {
              selectedExercise = exercise
            }, label: {
              CurrentWorkoutCardView(title: exercise.name, description: exercise.equipment, imageURL: exercise.getImagesURLs().first, cardWidth: 350)
            })
        }
      }
    }
  }
}

#Preview {
  DashboardView()
    .environmentObject(UserStore())
    .environmentObject(ExerciseStore())
    .environmentObject(TabBarSettings(isTabBarHidden: false))
}
