//
//  ExploreExerciseView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import SwiftUI

struct ExploreExerciseView: View {
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
        ScrollView {
          ProgressCard(
            title: "You've completed 3 exercises",
            description: "75% of your weekly muscle building goal",
            progress: 0.75
          )
          .padding([.leading, .trailing], 10)
          .padding(.top, 20)
          
          SearchFilterField(
            showFilterView: $showFilterView,
            hasObservedQuery: { query in
              exerciseStore.searchByMuscleQuery(query)
            })
          
          switch exerciseStore.state {
          case .loading:
            WorkoutLoadingView()
          case .loaded(let exercises):
            CategorySectionView(content: { categorySection in
              makeCategoryItems(
                categorySection,
                exercises: exercises
              )
            }, hasChangedSection: { handleChangeCategorySection($0) })
          case .empty:
            HintIconView(systemImage: "exclamationmark.warninglight", textHint: "No data found")
              .padding(.top, 20)
          case .error(_):
            HintIconView(systemImage: "exclamationmark.warninglight", textHint: "Error fetching data")
              .padding(.top, 20)
          }
          
          WhiteBackgroundCard()
        }
        .scrollIndicators(.hidden)
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
        if tabBarSettings.isTabBarHidden {
          DispatchQueue.main.async {
            tabBarSettings.isTabBarHidden = false
          }
        }
      }
      .onDisappear {
        exerciseStore.cleanUp()
      }
    }
  }
}

// MARK: - Helper merhods

extension ExploreExerciseView {
  @ViewBuilder
  private func makeCategoryItems(_ categorySection: CategorySection, exercises: [Exercise]) -> some View {
    VStack {
      switch categorySection {
      case .discover:
        ExerciseSectionView(title: "Most popular", exercises: exerciseStore.discoverExercises.first ?? [], onExerciseTap: {
            exercise in
            selectedExercise = exercise
          })
          ExerciseSectionView(title: "Quick muscle-building workouts", exercises: exerciseStore.discoverExercises[safe: 1] ?? [], isSmallCard: true, onExerciseTap: {
            exercise in
            selectedExercise = exercise
          })
      case .myFavorites:
        createExerciseVStack(exercises)
      case .workout:
        createExerciseVStack(exercises)
      }
    }
  }
  
  private func handleChangeCategorySection(_ categorySection: CategorySection) {
    switch categorySection {
    case .workout:
      exerciseStore.loadLocalExercises()
    case .discover:
      exerciseStore.loadRemoteExercises()
    case .myFavorites:
      exerciseStore.loadFavoriteExercises()
    }
  }
  
  private func createExerciseVStack(_ exercises: [Exercise]) -> some View {
    LazyVStack {
      ForEach(exercises, id: \.hashValue) { exercise in
        Button(action: {
          selectedExercise = exercise
        }, label: {
          ExerciseCard(exercise: exercise, cardWidth: 350)
        })
      }
    }
  }
}

#Preview {
  ExploreExerciseView()
    .environmentObject(UserStore())
    .environmentObject(ExerciseStore())
    .environmentObject(TabBarSettings(isTabBarHidden: false))
}
