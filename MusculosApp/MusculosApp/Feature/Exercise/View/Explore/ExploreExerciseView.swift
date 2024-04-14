//
//  ExploreExerciseView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import SwiftUI

struct ExploreExerciseView: View {
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
          
          ExerciseSectionsContentView(onSelected: { exercise in
            selectedExercise = exercise
          })
          
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
      .onDisappear(perform: exerciseStore.cleanUp)
    }
  }
}

#Preview {
  ExploreExerciseView()
    .environmentObject(ExerciseStore())
    .environmentObject(TabBarSettings(isTabBarHidden: false))
}
