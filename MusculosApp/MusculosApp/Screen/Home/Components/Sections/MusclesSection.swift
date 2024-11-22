//
//  MusclesSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.11.2024.
//

import SwiftUI
import Models
import Components

struct MusclesSection: View {
  let onSelectedMuscle: (MuscleGroup) -> Void

  private let cardColors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink, .teal, .indigo, .cyan]

  private func getRandomColor() -> Color {
    return cardColors.randomElement()!.opacity(0.7)
  }

  var body: some View {
    ContentSectionWithHeader(
      headerTitle: "Browse by muscle group",
      scrollDirection: .horizontal,
      content: {
        LazyHStack {
          ForEach(MuscleConstant.muscleGroups, id: \.name) { muscleGroup in
            Button(action: {
              onSelectedMuscle(muscleGroup)
            }, label: {
              TitleCard(title: muscleGroup.name, titleColor: .white, cardColor: getRandomColor())
            })
            .buttonStyle(.plain)
            .padding([.vertical, .horizontal], 5)
          }
        }
      })
  }
}
