//
//  WorkoutIntroView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.05.2024.
//

import SwiftUI

struct WorkoutIntroView: View {
  let workout: Workout
  
  var body: some View {
    VStack {
      Spacer()
      Button(action: {}, label: {
        Text("\(workout.workoutExercises.count) TOTAL")
          .font(AppFont.body(.bold, size: 11.0))
          .foregroundStyle(.white)
          .shadow(radius: 1.2)
      })
      .disabled(true)
      
      Text(workout.name)
        .font(AppFont.header(.medium, size: 16.0))
        .foregroundStyle(.white)
        .shadow(radius: 1.2)
      
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
        Button(action: showDetails) {
          Text("Details")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(SecondaryButtonStyle())
        
        Button(action: startWorkout) {
          Text("Start")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryButtonStyle())
      })
      .padding()
    }
    .background {
      // TODO: Set custom image
      Color.black
    }
    .ignoresSafeArea()
  }
  
  private func showDetails() {
    
  }
  
  private func startWorkout() {
    
  }
}

#Preview {
  WorkoutIntroView(workout: WorkoutFactory.create())
}
