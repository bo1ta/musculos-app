//
//  QuickWorkoutSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.11.2024.
//

import SwiftUI
import Components
import Utility
import Models

struct QuickWorkoutSection: View {
  @Environment(\.navigationRouter) private var navigationRouter
  let exercises: [Exercise]

  private var cardGradient: LinearGradient {
    LinearGradient(colors: [Color(hex: "0EA5E9"), Color(hex: "3B82F6")], startPoint: .leading, endPoint: .trailing)
  }

  init(exercises: [Exercise]) {
    self.exercises = exercises
  }

  var body: some View {
    ContentSectionWithHeader(
      headerTitle: "Quick workout",
      scrollDirection: .vertical,
      content: {
        VStack {
          ForEach(exercises, id: \.id) { exercise in
            SmallCardWithContent(
              title: exercise.name,
              description: exercise.category,
              gradient: cardGradient,
              rightContent: {
                IconButton(systemImageName: "chevron.right", action: {
                  navigationRouter.push(.exerciseDetails(exercise))
                })
              })
          }
        }
      }
    )
  }
}
