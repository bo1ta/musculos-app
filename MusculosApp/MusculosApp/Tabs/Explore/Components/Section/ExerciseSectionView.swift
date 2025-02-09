//
//  ExerciseSectionView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//

import Components
import Foundation
import Models
import SwiftUI
import Utility

struct ExerciseSectionView: View {
  let title: String
  let state: LoadingViewState<[Exercise]>
  let onExerciseTap: (Exercise) -> Void
  let onSeeMore: () -> Void

  init(
    title: String,
    state: LoadingViewState<[Exercise]>,
    onExerciseTap: @escaping (Exercise) -> Void,
    onSeeMore: @escaping () -> Void)
  {
    self.title = title
    self.state = state
    self.onExerciseTap = onExerciseTap
    self.onSeeMore = onSeeMore
  }

  var body: some View {
    Group {
      switch state {
      case .loading:
        ContentSectionWithHeaderAndButton.Skeleton {
          ExerciseCardsStack.Skeleton()
        }
        .defaultShimmering()

      case .loaded(let exercises):
        ContentSectionWithHeaderAndButton(
          headerTitle: title,
          buttonTitle: "See more",
          onAction: onSeeMore,
          content: {
            ExerciseCardsStack(exercises: exercises, onTapExercise: onExerciseTap)
              .shadow(radius: 1.0)
          })

      default:
        EmptyView()
      }
    }
  }
}
