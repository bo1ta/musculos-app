//
//  GoalCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.11.2024.
//

import SwiftUI
import Components
import Utility
import Models

struct GoalCard: View {
  let goal: Goal

  private var gradientColor: LinearGradient {
    LinearGradient(colors: [Color(hex: "8B5CF6"), Color(hex: "3B82F6")], startPoint: .leading, endPoint: .trailing)
  }

  var body: some View {
    RoundedRectangle(cornerRadius: 12.0)
      .frame(maxWidth: .infinity)
      .frame(height: UIConstant.Size.small.cardHeight)
      .foregroundStyle(gradientColor)
      .shadow(radius: 1.2)
      .overlay {
        HStack(alignment: .center) {
          VStack(alignment: .leading, spacing: 0) {
            Text(goal.name)
              .font(AppFont.poppins(.bold, size: 16))
              .foregroundStyle(.white)
            Text(goal.frequency.description)
              .font(AppFont.poppins(.light, size: 14))
              .foregroundStyle(.white.opacity(0.9))
              .fixedSize(horizontal: false, vertical: true)
          }
          .padding(.vertical)
          Spacer()
          ProgressCircle(progress: goal.progressPercentage / 100, circleSize: 50)
        }
        .padding([.vertical, .horizontal], 10)
      }
  }
}

#Preview {
  GoalCard(goal: GoalFactory.createGoal())
}

struct AddGoalCard: View {
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
