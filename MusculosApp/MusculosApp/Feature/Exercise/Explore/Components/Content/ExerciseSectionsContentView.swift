//
//  ExerciseSectionsContentView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.03.2024.
//

import SwiftUI

struct ExerciseSectionsContentView: View {
  @EnvironmentObject var exerciseStore: ExerciseStore
  var onSelected: (Exercise) -> Void
  
  var body: some View {
    VStack {
      switch exerciseStore.state {
      case .loading:
        ExerciseContentLoadingView()
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
          .onAppear {
            exerciseStore.loadRemoteExercises()
          }
      case .error(_):
        HintIconView(systemImage: "exclamationmark.warninglight", textHint: "Error fetching data")
          .padding(.top, 20)
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
  
  private func makeCategoryItems(_ categorySection: CategorySection, exercises: [Exercise]) -> some View {
    VStack {
      switch categorySection {
      case .discover:
        ExerciseSectionView(
          title: "Most popular",
          exercises: exerciseStore.discoverExercises.first ?? [],
          onExerciseTap: onSelected
        )
        ExerciseSectionView(
          title: "Quick muscle-building workouts",
          exercises: exerciseStore.discoverExercises[safe: 1] ?? [],
          isSmallCard: true,
          onExerciseTap: onSelected
        )
      case .myFavorites, .workout:
        LazyVStack {
          ForEach(exercises, id: \.hashValue) { exercise in
            Button(action: {
              onSelected(exercise)
            }, label: {
              ExerciseCard(exercise: exercise, cardWidth: 350)
            })
          }
        }
      }
    }
  }
}

#Preview {
  ExerciseSectionsContentView { exercise in
    print(exercise)
  }
  .environmentObject(ExerciseStore())
}
