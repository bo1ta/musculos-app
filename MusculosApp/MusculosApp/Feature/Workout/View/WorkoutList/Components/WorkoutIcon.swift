//
//  WorkoutIcon.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.05.2024.
//

import SwiftUI

struct WorkoutIcon: View {
  let category: String
  
    var body: some View {
      if let categoryType = ExerciseConstants.CategoryType(rawValue: category) {
        Image(categoryType.imageName)
          .resizable()
          .renderingMode(.template)
          .frame(width: 15, height: 15)
          .foregroundStyle(.white)
      } else {
        Image(ExerciseConstants.CategoryType.plyometrics.imageName)
          .resizable()
          .renderingMode(.template)
          .frame(width: 15, height: 15)
          .foregroundStyle(.white)
      }
    }
}

#Preview {
  WorkoutIcon(category: "dumbbell")
}
