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
  @Binding var selectedLevel: OnboardingData.Level?

  let onContinue: () -> Void

  var body: some View {
    VStack(spacing: 15) {
      Header(text: "Select your level")
        .padding(.top, 20)

      ForEach(OnboardingData.Level.allCases, id: \.self) { level in
        Button(action: {
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
    }
    .safeAreaInset(edge: .bottom) {
      Button(action: onContinue, label: {
        Text("Continue")
          .font(AppFont.poppins(.bold, size: 14))
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButtonStyle())
      .padding(.horizontal, 40)
      .padding(.top, 30)
    }
  }

  @ViewBuilder
  private func makeStarsImage(for level: OnboardingData.Level) -> some View {
    let isSelected = level == selectedLevel
    let imageName = isLevelSelected(level) ? "star-icon" : "star-icon-empty"

    let numberofStars = switch level {
    case .beginner: 1
    case .intermmediate: 2
    case .advanced: 3
    }

    HStack(spacing: 5) {
      ForEach(0..<numberofStars, id: \.self) { _ in
        Image(imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 25, height: 25)
      }
    }
  }

  private func isLevelSelected(_ level: OnboardingData.Level) -> Bool {
    return selectedLevel == level
  }
}

#Preview {
  SelectLevelView(selectedLevel: .constant(.beginner), onContinue: {})
}
