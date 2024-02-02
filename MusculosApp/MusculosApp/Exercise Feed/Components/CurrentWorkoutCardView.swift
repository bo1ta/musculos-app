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
  let isGif: Bool
  
  private let cardWidth: CGFloat = 300
  private let cardHeight: CGFloat = 200

  init(exercise: Exercise, showDetails: Bool = true, isGif: Bool = false) {
    self.exercise = exercise
    self.showDetails = showDetails
    self.isGif = isGif
  }

  var body: some View {
    ZStack {
      backgroundView
      if showDetails {
        Spacer()
        detailsRectangle
          .frame(alignment: .bottom)
          .padding(.top, 120)
      }
    }
    .cornerRadius(40)
    .padding()
    .frame(width: cardWidth, height: cardHeight)
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var backgroundView: some View {
    if let gifUrl = URL(string: exercise.gifUrl) {
      if isGif {
        GIFImageViewRepresentable(urlType: .url(gifUrl))
          .frame(width: cardWidth, height: cardHeight)
      } else {
        AsyncImage(url: gifUrl)
          .frame(width: cardWidth, height: cardHeight)
      }
    } else {
      Color.black
        .frame(width: 700, height: 700)
    }
  }
  
  @ViewBuilder
  private var detailsRectangle: some View {
    RoundedRectangle(cornerRadius: 30)
      .foregroundStyle(.white)
      .shadow(radius: 40, y: 30)
      .frame(width: cardWidth, height: cardHeight - 100)
      .overlay {
        HStack {
          VStack(alignment: .leading) {
            Text(exercise.name)
              .font(.custom(AppFont.bold, size: 18))
              .foregroundStyle(.black)
            Text(exercise.equipment)
              .font(.custom(AppFont.regular, size: 15))
              .foregroundStyle(.black)
          }
          Spacer()
        }
        .padding()
      }
  }
  
  @ViewBuilder
  private var detailsPills: some View {
    HStack {
      let options = self.exercise.secondaryMuscles
      if !options.isEmpty {
        HStack {
          Spacer()
          ForEach(options, id: \.self) {
            IconPill(option: IconPillOption(title: $0))
          }
        }
      }
    }
    .padding([.bottom, .trailing], 5)
  }
}

struct WorkoutCardView_Preview: PreviewProvider {
  static var previews: some View {
    CurrentWorkoutCardView(exercise: Exercise(bodyPart: "back", equipment: "dumbbell", gifUrl: "https://v2.exercisedb.io/image/qr3qX7hFMVj2ZT", id: "1", name: "Back workout", target: "back", secondaryMuscles: ["back", "chest"], instructions: ["Get up", "Get down"]))
      .previewLayout(.sizeThatFits)
  }
}
