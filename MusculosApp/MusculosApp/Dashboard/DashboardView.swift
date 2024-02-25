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
          .task {
            await userStore.fetchUserProfile()
            exerciseStore.loadLocalExercises()
          }
          
          switch exerciseStore.state {
          case .loading:
           DashboardLoadingView()
          case .loaded(let exercises):
            DashboardCategorySection(content: { categorySection in
              makeCategoryItems(categorySection, exercises: exercises)
            }, hasChangedSection: { section in
              exerciseStore.loadLocalExercises()
            })
          case .empty(_):
            HintIconView(systemImage: "alert", textHint: "No data found!")
          case .error(_):
            EmptyView()
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
  
  @ViewBuilder
  private func makeCategoryItems(_ categorySection: CategorySection, exercises: [Exercise]) -> some View {
    VStack {
      switch categorySection {
      case .discover:
          SearchFilterFieldView(
            showFilterView: $showFilterView,
            hasObservedQuery: { query in
              exerciseStore.searchByMuscleQuery(query)
            })
          
          ExerciseCardSection(title: "Most popular", exercises: exercises, onExerciseTap: {
            exercise in
            selectedExercise = exercise
          })
          ExerciseCardSection(title: "Quick muscle-building workouts", exercises: exercises, isSmallCard: true, onExerciseTap: {
            exercise in
            selectedExercise = exercise
          })
      case .myFavorites:
        HintIconView(systemImage: "dumbbell", textHint: "Favorite exercises!")
      case .workout:
        Text("hinting")
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
