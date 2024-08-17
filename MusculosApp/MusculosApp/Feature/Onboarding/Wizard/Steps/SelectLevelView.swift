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
  
  var body: some View {
    VStack(spacing: 15) {
      ForEach(OnboardingData.Level.allCases, id: \.self) { level in
        Button(action: {
          selectedLevel = level
        }, label: {
          DetailCard(
            text: level.title,
            font: AppFont.poppins(.medium, size: 18),
            content: {
              makeStarsImage(for: level)
            })
          .id(selectedLevel)
          .animation(.smooth, value: selectedLevel)
        })
      }
      .padding(20)
    }
  }

  @ViewBuilder
  private func makeStarsImage(for level: OnboardingData.Level) -> some View {
    let isSelected = level == selectedLevel
    let imageName = isSelected ? "star-icon" : "star-icon-empty"
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
}

#Preview {
  SelectLevelView(selectedLevel: .constant(.beginner))
}
