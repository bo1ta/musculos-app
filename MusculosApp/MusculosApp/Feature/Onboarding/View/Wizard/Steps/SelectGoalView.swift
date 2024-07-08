//
//  SelectGoalView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import SwiftUI
import Models

struct SelectGoalView: View {
  @Binding var selectedGoal: OnboardingData.Goal?
  
  var body: some View {
    VStack(spacing: 15) {
      ForEach(OnboardingData.Goal.allCases, id: \.self) { goal in
        OnboardingOptionCardView(
          onboardingOption: goal,
          isSelected: selectedGoal == goal,
          didTap: { selectedGoal = goal }
        )
      }
    }
    .padding(20)
  }
}

#Preview {
  SelectGoalView(selectedGoal: .constant(nil))
}
