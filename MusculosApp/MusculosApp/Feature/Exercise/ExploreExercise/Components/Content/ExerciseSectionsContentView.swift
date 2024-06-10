//
//  ExerciseSectionsContentView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.03.2024.
//

import SwiftUI

struct ExerciseSectionsContentView: View {
  @Binding var categorySection: ExploreCategorySection
  @Binding var contentState: LoadingViewState<[Exercise]>
  
  let onExerciseTap: (Exercise) -> Void
  
  var body: some View {
    switch contentState {
    case .loading:
      ExerciseContentLoadingView()
    case .loaded(let exercises):
      VStack {
        ExploreCategorySectionView(currentSection: $categorySection)
        makeCategoryItems(
          categorySection,
          exercises: exercises
        )
      }
    case .empty:
      EmptyView()
    case .error(_):
      HintIconView(systemImage: "exclamationmark.warninglight", textHint: "Error fetching data")
        .padding(.top, 20)
    }
  }
  
  private func makeCategoryItems(_ categorySection: ExploreCategorySection, exercises: [Exercise]) -> some View {
    VStack {
      switch categorySection {
      case .discover:
        ExerciseSectionView(
          title: "Most popular",
          exercises: exercises,
          onExerciseTap: onExerciseTap
        )
//        ExerciseSectionView(
//          title: "Quick muscle-building workouts",
//          exercises: exercises,
//          isSmallCard: true,
//          onExerciseTap: onExerciseTap
//        )
      case .myFavorites, .workout:
        LazyVStack {
          ForEach(exercises, id: \.hashValue) { exercise in
            Button(action: {
              onExerciseTap(exercise)
            }, label: {
              ExerciseCard(exercise: exercise, cardWidth: 350)
            })
            .id(exercise)
          }
        }
      }
    }
  }
}
