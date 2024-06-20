//
//  WorkoutCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.05.2024.
//

import SwiftUI
import Utilities

struct WorkoutCard: View {
  private let itemSpacing: CGFloat = 2.3
  private let cardHeight: CGFloat = 200
  
  let workout: Workout
  
  var body: some View {
    ZStack {
      WorkoutCarousel(workoutExercises: workout.workoutExercises)
        .ignoresSafeArea()
      
      HStack {
        VStack(alignment: .leading, spacing: 15) {
          Text(workout.name)
            .font(.header(.bold, size: 17.5))
            .foregroundStyle(.white)
            .shadow(radius: 2)
          
          HStack(spacing: itemSpacing) {
            WorkoutIcon(category: workout.workoutType)
            Text("\(workout.workoutExercises.count) exercises")
              .font(.body(.light, size: 13.0))
              .foregroundStyle(.white)
              .shadow(radius: 1.2)
            
            Image(systemName: "clock")
              .resizable()
              .renderingMode(.template)
              .frame(width: 15, height: 15)
              .foregroundStyle(.white)
              .padding(.leading, 5)
            Text("40 mins")
              .font(.body(.light, size: 13.0))
              .foregroundStyle(.white)
          }
          
          HStack(spacing: 5) {
            IconPill(option: IconPillOption(title: workout.targetMuscles.first ?? ""), backgroundColor: AppColor.blue500)
            IconPill(option: IconPillOption(title: workout.workoutType), backgroundColor: AppColor.green700)
          }
        }
        .padding()
        Spacer()
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: 30))
    .shadow(radius: 2.0)
    .frame(height: cardHeight)
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  WorkoutCard(workout: WorkoutFactory.create())
}
