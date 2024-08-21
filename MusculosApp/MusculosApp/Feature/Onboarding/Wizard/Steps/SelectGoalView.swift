//
//  SelectGoalView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import SwiftUI
import Models
import Utility
import Components

struct SelectGoalView: View {
  @Binding var selectedGoal: OnboardingData.Goal?

  let onContinue: () -> Void

  var body: some View {
    VStack(spacing: 15) {
      Header(text: "Select your goal")
        .padding(.vertical, 20)
        .padding(.top, 20)

      ForEach(OnboardingData.Goal.allCases, id: \.self) { goal in
        makeDetailCardButton(for: goal)
      }
    }
    .safeAreaInset(edge: .bottom, content: {
      PrimaryButton(title: "Continue", action: onContinue)
      .padding(.horizontal, 20)
      .padding(.top, 30)
    })
    .padding(20)
  }

  private func makeDetailCardButton(for goal: OnboardingData.Goal) -> some View {
    Button(action: {
      selectedGoal = goal
    }, label: {
      DetailCard(
        text: goal.title,
        font: AppFont.poppins(.regular, size: 16),
        isSelected: isGoalSelected(goal),
        content: {
          makeImageForGoal(goal)
        }
      )
    })
  }

  @ViewBuilder
  private func makeImageForGoal(_ goal: OnboardingData.Goal) -> some View {
    if isGoalSelected(goal) {
      Circle()
        .frame(width: 35, height: 35)
        .foregroundStyle(Color.orange)
        .overlay {
          Image(systemName: "checkmark")
            .foregroundStyle(.white)
        }
    } else {
      if let image = goal.image {
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 30, height: 30)
          .foregroundStyle(AppColor.navyBlue)
      }
    }
  }

  private func isGoalSelected(_ goal: OnboardingData.Goal) -> Bool {
    return selectedGoal == goal
  }
}

#Preview {
  SelectGoalView(selectedGoal: .constant(nil), onContinue: {})
}
