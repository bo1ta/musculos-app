//
//  WorkoutCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct CurrentWorkoutCardView: View {
  let exercise: Exercise
  
  private let cardHeight: CGFloat = 200
  private var cardWidth: CGFloat

  init(exercise: Exercise, cardWidth: CGFloat = 300) {
    self.exercise = exercise
    self.cardWidth = cardWidth
  }

  var body: some View {
    ZStack {
      backgroundView
        Spacer()
        detailsRectangle
          .frame(alignment: .bottom)
          .padding(.top, 120)
    }
    .cornerRadius(40)
    .padding()
    .shadow(radius: 2)
    .frame(width: cardWidth, height: cardHeight)
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var backgroundView: some View {
    let images = exercise.getImagesURLs()
    if let imageUrl = images.first {
      AsyncImage(url: imageUrl)
        .frame(width: cardWidth, height: cardHeight)
    } else {
      Color.gray
        .frame(width: cardWidth, height: cardWidth)
        .shimmering()
    }
  }
  
  @ViewBuilder
  private var detailsRectangle: some View {
    RoundedRectangle(cornerRadius: 30)
      .foregroundStyle(.white)
      .shadow(radius: 40, y: 30)
      .frame(width: cardWidth, height: 80)
      .overlay {
        HStack {
          VStack(alignment: .leading) {
            Text(exercise.name)
              .font(.custom(AppFont.bold, size: 18))
              .foregroundStyle(.black)
            if let equipment = exercise.equipment {
              Text(equipment)
                .font(.custom(AppFont.regular, size: 15))
                .foregroundStyle(.black)
            }
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
    CurrentWorkoutCardView(exercise: MockConstants.createMockExercise())
      .previewLayout(.sizeThatFits)
  }
}
