//
//  WorkoutIntroView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.05.2024.
//

import SwiftUI
import Models
import Utility

struct WorkoutIntroView: View {
  @Environment(\.appManager) private var appManager

  let workout: Workout
  let onStartTapped: () -> Void
  
  var body: some View {
    VStack(spacing: 10) {
      Spacer()
      
      exerciseList
      
      Spacer()
      
      Button(action: {}, label: {
        Text("\(workout.workoutExercises.count) TOTAL")
          .font(AppFont.body(.bold, size: 11.0))
          .foregroundStyle(.white)
          .shadow(radius: 1.2)
      })
      .disabled(true)
      .padding(.top)
      
      Text(workout.name)
        .font(AppFont.header(.medium, size: 16.0))
        .foregroundStyle(.white)
        .shadow(radius: 1.2)

      Button(action: onStartTapped) {
        Text("Start")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(PrimaryButtonStyle())
      .padding(20)
    }
    .background {
      Image("workout-intro-dumbbell")
        .resizable()
        .scaledToFill()
      Color.black
        .opacity(0.8)
    }
    .ignoresSafeArea()
    .onAppear(perform: appManager.hideTabBar)
  }
  
  @ViewBuilder
  private var exerciseList: some View {
    VStack(spacing: 10) {
      ForEach(
        workout.workoutExercises, id: \.hashValue) { workoutExercise in
          VStack {
            HStack {
              WorkoutIcon(category: workoutExercise.exercise.category)
                .shadow(radius: 1)
              Text(workoutExercise.exercise.name)
                .foregroundStyle(.white)
                .font(AppFont.body(.regular, size: 14.0))
                .shadow(radius: 1)
              Text("x \(workoutExercise.numberOfReps)")
                .foregroundStyle(.white)
                .opacity(0.6)
                .shadow(radius: 1)
                .font(AppFont.body(.light, size: 12.0))
            }
            
            Divider()
              .frame(width: 100)
              .overlay(.white)
          }
        }
    }
  }
}

#Preview {
  WorkoutIntroView(workout: WorkoutFactory.create(), onStartTapped: {})
}
