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
        DashboardHeaderCard()
        ScrollView {
          ProgressCard(
            title: "You've completed 3 exercises",
            description: "75% of your weekly muscle building goal",
            progress: 0.75
          )
          .padding([.leading, .trailing], 10)
          .padding(.top, 20)
          
          switch exerciseStore.state {
          case .loading:
           DashboardLoadingView()
              .onAppear {
                exerciseStore.loadExercises()
              }
          case .loaded(let exercises):
            CategorySectionView(content: { categorySection in
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
    switch categorySection {
    case .myFavorites:
      exerciseStore.loadFavoriteExercises()
    case .workout:
      exerciseStore.loadLocalExercises()
    case .discover:
      exerciseStore.loadExercises()
    }
  }
  
  @ViewBuilder
  private func makeCategoryItems(_ categorySection: CategorySection, exercises: [Exercise]) -> some View {
    VStack {
      switch categorySection {
      case .discover:
          SearchFilterField(
            showFilterView: $showFilterView,
            hasObservedQuery: { query in
              exerciseStore.searchByMuscleQuery(query)
            })
          
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
  DashboardView()
    .environmentObject(UserStore())
    .environmentObject(ExerciseStore())
    .environmentObject(TabBarSettings(isTabBarHidden: false))
}
