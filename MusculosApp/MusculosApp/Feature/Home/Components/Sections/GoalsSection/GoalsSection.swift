//
//  GoalsSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.11.2024.
//

import SwiftUI
import Components
import Models

struct GoalsSection: View {
  var goals: [Goal]
  var onAddGoal: () -> Void

  var body: some View {
    ContentSectionWithHeader(
      headerTitle: "My Goals",
      scrollDirection: .vertical,
      content: {
        VStack {
          ForEach(goals, id: \.id) { goal in
            GoalCard(goal: goal)
          }

          AddGoalCard(onTap: {

          })
        }
      })
  }
}

#Preview {
  GoalsSection(goals: [GoalFactory.createGoal(), GoalFactory.createGoal(name: "Goal 2")], onAddGoal: {})
}
