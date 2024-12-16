//
//  WorkoutIcon.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.05.2024.
//

import SwiftUI
import Models

struct WorkoutIcon: View {
  let category: String

  var body: some View {
    if let categoryType = ExerciseConstants.CategoryType(rawValue: category) {
      Image(categoryType.imageName)
        .resizable()
        .renderingMode(.template)
        .frame(width: 24, height: 24)
        .foregroundStyle(.black)
        .shadow(radius: 0.8)
    } else {
      Image(ExerciseConstants.CategoryType.plyometrics.imageName)
        .resizable()
        .renderingMode(.template)
        .frame(width: 15, height: 15)
        .foregroundStyle(.black)
        .shadow(radius: 0.8)

    }
  }
}

#Preview {
  WorkoutIcon(category: "dumbbell")
}
