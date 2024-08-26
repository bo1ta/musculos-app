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
      Heading("Select the goal you want to focus on")
        .padding(.vertical, 20)
        .padding(.top, 20)

      Spacer()

      ForEach(OnboardingData.Goal.allCases, id: \.self) { goal in
        makeDetailCardButton(for: goal)
      }
      .padding(.top, 8)
      Spacer()
    }
    .safeAreaInset(edge: .bottom, content: {
      PrimaryButton(title: "Continue", action: onContinue)
      .padding(.horizontal, 30)
      .padding(.top, 30)
    })
    .animation(.easeInOut(duration: 0.2), value: selectedGoal)
    .padding(20)
  }

  private func makeDetailCardButton(for goal: OnboardingData.Goal) -> some View {
    Button(action: {
      HapticFeedbackProvider.haptic(.lightImpact)
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
    Group {
      if isGoalSelected(goal) {
        Image("orange-checkmark-icon")
          .resizable()
          .transition(
            .asymmetric(
              insertion: .scale(scale: 0.5).combined(with: .opacity),
              removal: .opacity
            )
          )
          .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isGoalSelected(goal))
      } else {
        if let image = goal.image {
          image
            .resizable()
            .transition(.opacity)
        }
      }
    }
    .aspectRatio(contentMode: .fit)
    .frame(width: 60, height: 60)
    .shadow(radius: 1.0)
    .foregroundStyle(AppColor.navyBlue)
  }

  private func isGoalSelected(_ goal: OnboardingData.Goal) -> Bool {
    return selectedGoal == goal
  }
}

#Preview {
  SelectGoalView(selectedGoal: .constant(nil), onContinue: {})
}
