//
//  GoalsSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.11.2024.
//

import SwiftUI
import Components
import Models
import Utility

struct GoalsSection: View {
  var goals: [Goal]
  var onAddGoal: () -> Void

  private var cardGradient: LinearGradient {
    LinearGradient(colors: [Color(hex: "8B5CF6"), Color(hex: "3B82F6")], startPoint: .leading, endPoint: .trailing)
  }

  var body: some View {
    ContentSectionWithHeader(
      headerTitle: "My Goals",
      scrollDirection: .vertical,
      content: {
        VStack {
          ForEach(goals, id: \.id) { goal in
            SmallCardWithContent(
              title: goal.name,
              description: goal.frequency.description,
              gradient: cardGradient,
              rightContent: {
                ProgressCircle(progress: goal.progressPercentage / 100, circleSize: 50)
            })
          }

          AddGoalCard(onTap: onAddGoal)
        }
      })
  }
}

#Preview {
  GoalsSection(goals: [GoalFactory.createGoal(), GoalFactory.createGoal(name: "Goal 2")], onAddGoal: {})
}

private struct AddGoalCard: View {
  let onTap: () -> Void

  private var gradientColor: LinearGradient {
    LinearGradient(colors: [Color(hex: "8B5CF6"), Color(hex: "3B82F6")], startPoint: .leading, endPoint: .trailing)
  }

  var body: some View {
    Button(action: onTap) {
      RoundedRectangle(cornerRadius: 12.0)
        .frame(maxWidth: .infinity)
        .frame(height: UIConstant.Size.extraSmall.cardHeight)
        .foregroundStyle(gradientColor)
        .shadow(radius: 1.2)
        .overlay {
          VStack(alignment: .center) {
            HStack {
              Image(systemName: "plus")
                .foregroundStyle(.white)
              Text("Add New Goal")
                .font(AppFont.poppins(.semibold, size: 13))
                .foregroundStyle(.white)
            }
          }
        }
    }
    .buttonStyle(.plain)
  }
}

