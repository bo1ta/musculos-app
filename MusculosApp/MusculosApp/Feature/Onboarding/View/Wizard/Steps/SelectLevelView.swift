//
//  SelectLevelView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.06.2024.
//

import Foundation
import SwiftUI

struct SelectLevelView: View {
  @Binding var selectedLevel: OnboardingData.Level?
  
  var body: some View {
    VStack(spacing: 15) {
      ForEach(OnboardingData.Level.allCases, id: \.self) { level in
        OnboardingOptionCardView(
          onboardingOption: level,
          isSelected: selectedLevel == level,
          didTap: { selectedLevel = level }
        )
      }
    }
    .padding(20)
  }
}

#Preview {
  SelectLevelView(selectedLevel: .constant(nil))
}
