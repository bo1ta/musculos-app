//
//  SelectLevelView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.06.2024.
//

import Foundation
import SwiftUI
import Models
import Components
import Utility

struct SelectLevelView: View {
  @Binding var selectedLevel: OnboardingConstants.Level?
  let onContinue: () -> Void

  var body: some View {
    VStack(spacing: 15) {
      Heading("Select your level")
        .padding(.top, 20)

      Spacer()

      ForEach(OnboardingConstants.Level.allCases, id: \.self) { level in
        makeButtonCard(for: level)
      }
      .padding(.top, 7)

      Spacer()
    }
    .safeAreaInset(edge: .bottom) {
      PrimaryButton(title: "Continue", action: onContinue)
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
    .animation(.easeInOut(duration: 0.2), value: selectedLevel)
    .padding(20)
  }

  private func makeButtonCard(for level: OnboardingConstants.Level) -> some View {
    Button(action: {
      HapticFeedbackProvider.haptic(.lightImpact)
      selectedLevel = level
    }, label: {
      DetailCard(
        text: level.title,
        font: AppFont.poppins(.medium, size: 18),
        isSelected: isLevelSelected(level),
        content: {
          makeStarsImage(for: level)
        })
      .animation(.smooth, value: selectedLevel)
    })
  }

  private func makeStarsImage(for level: OnboardingConstants.Level) -> some View {
    HStack(spacing: 5) {
      ForEach(0..<level.numberOfStars, id: \.self) { _ in
        Image(isLevelSelected(level) ? "star-icon" : "star-icon-empty")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 25, height: 25)
          .transition(
            .asymmetric(
              insertion: .scale(scale: 0.5).combined(with: .opacity),
              removal: .opacity
            )
          )
          .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLevelSelected(level))
      }
    }
  }

  private func isLevelSelected(_ level: OnboardingConstants.Level) -> Bool {
    return selectedLevel == level
  }
}

#Preview {
  SelectLevelView(selectedLevel: .constant(.beginner), onContinue: {})
}
