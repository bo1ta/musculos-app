//
//  ExerciseSectionsContentView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.03.2024.
//

import SwiftUI
import Models
import Utility
import Components
import Storage

struct ExerciseSectionsContentView: View {
  @Binding var categorySection: ExploreCategorySection
  @Binding var contentState: LoadingViewState<[Exercise]>
  @Binding var recommendedExercisesByGoals: [Exercise]?
  @Binding var recommendedExercisesByPastSessions: [Exercise]?
  
  let onExerciseTap: (Exercise) -> Void
  
  var body: some View {
    ZStack {
      switch contentState {
      case .loading:
        ExerciseContentLoadingView()
      case .loaded(let exercises):
        VStack {
          ExploreCategorySectionView(currentSection: categorySection, onChangeSection: { section in
            switch section {
            case .myFavorites:
              categorySection = .myFavorites
            case .workout:
              categorySection = .workout
            case .discover:
              categorySection = .discover
            }
          })
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
        
        if let recommendedExercisesByGoals {
          ExerciseSectionView(
            title: "Recommended exercises based on your goals",
            exercises: recommendedExercisesByGoals,
            isSmallCard: true,
            onExerciseTap: onExerciseTap
          )
        }
        
        if let recommendedExercisesByPastSessions {
          ExerciseSectionView(
            title: "Recommended exercises based on your past sessions",
            exercises: recommendedExercisesByPastSessions,
            isSmallCard: true,
            onExerciseTap: onExerciseTap
          )
        }
        
      case .myFavorites, .workout:
        LazyVStack {
          if case let .loaded(exercises) = contentState {
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
}
