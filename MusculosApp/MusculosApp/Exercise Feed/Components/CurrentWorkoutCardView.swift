//
//  WorkoutCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct CurrentWorkoutCardView: View {
  let exercise: Exercise
  let showDetails: Bool // there are some cases where we don't want to show the details like on ExerciseView

  init(exercise: Exercise, showDetails: Bool = true) {
    self.exercise = exercise
    self.showDetails = showDetails
  }

  var body: some View {
    VStack {
      if showDetails {
        topSection
        Spacer()
        bottomSection
      } else {
        EmptyView()
      }
    }
    .frame(maxWidth: .infinity, minHeight: 250)
    .background(backgroundView)
    .cornerRadius(15)
    .padding()
    .shadow(color: Color.black.opacity(0.6), radius: 4, x: 0, y: 2)
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var backgroundView: some View {
    if let gifUrl = URL(string: exercise.gifUrl) {
        GIFView(url: Binding(get: { gifUrl }, set: { _ in }))
        .fixedSize()
    } else {
      Color.black
    }
  }
  
  @ViewBuilder
  private var topSection: some View {
    HStack {
      VStack {
        Text(exercise.name)
          .font(.title)
          .fontWeight(.heavy)
          .foregroundStyle(.black)
        Text(exercise.equipment)
          .font(.title2)
          .fontWeight(.regular)
          .foregroundStyle(.black)
        
        Spacer()
      }
      Spacer()
    }
    .padding([.top, .leading], 5)
  }
  
  @ViewBuilder
  private var bottomSection: some View {
    HStack {
      let options = self.exercise.secondaryMuscles
      if !options.isEmpty {
        HStack {
          IconPill(option: IconPillOption(title: self.exercise.target))
          ForEach(options, id: \.self) {
            IconPill(option: IconPillOption(title: $0))
          }
          Spacer()
        }
      }
    }
    .padding([.bottom, .leading], 5)
    Spacer()
  }
}

struct WorkoutCardView_Preview: PreviewProvider {
  static var previews: some View {
    CurrentWorkoutCardView(exercise: Exercise(bodyPart: "back", equipment: "dumbbell", gifUrl: "", id: "1", name: "Back workout", target: "back", secondaryMuscles: [""], instructions: ["Get up", "Get down"]))
      .previewLayout(.sizeThatFits)
  }
}