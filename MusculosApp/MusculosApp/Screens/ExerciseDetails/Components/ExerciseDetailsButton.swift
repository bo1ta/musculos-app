//
//  ExerciseDetailsButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.12.2024.
//

import SwiftUI
import Components
import Utility

struct ExerciseDetailsButton: View {
  @Namespace private var animationNamespace
  private let timerActionAnimationID = "timerActionAnimationID"

  var elapsedTime: Int
  var isTimerActive: Bool
  var onClick: () -> Void

  var body: some View {
    Group {
      if isTimerActive {
        ProgressButton(elapsedTime: elapsedTime, onClick: onClick)
          .transition(.asymmetric(insertion: .push(from: .bottom), removal: .opacity))
          .matchedGeometryEffect(id: timerActionAnimationID, in: animationNamespace)
      } else {
        ActionButton(title: "Start workout", systemImageName: "arrow.up.right", onClick: onClick)
          .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .top)))
          .matchedGeometryEffect(id: timerActionAnimationID, in: animationNamespace)
      }
    }
    .animation(.easeInOut(duration: UIConstant.shortAnimationDuration), value: isTimerActive)
    .padding(.horizontal)
  }
}
