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
  let onSelectedMuscle: (MuscleType) -> Void

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
          ForEach(MuscleType.allCases, id: \.rawValue) { muscleType in
            Button(action: {
              onSelectedMuscle(muscleType)
            }, label: {
              TitleCard(title: muscleType.rawValue, titleColor: .white, cardColor: getRandomColor())
            })
            .buttonStyle(.plain)
          }
          .padding(.vertical, 5)
          .padding(.horizontal, 5)
        }
      })
  }
}
