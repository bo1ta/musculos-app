//
//  ExerciseCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI
import Shimmer

struct ExerciseCard: View {
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
    .shadow(color: .gray.opacity(0.4), radius: 2, x: 1, y: 1)
    .frame(width: cardWidth, height: cardHeight)
  }
  
  // MARK: - Views
  @ViewBuilder
  private var backgroundView: some View {
    if let imageUrl = exercise.getImagesURLs().first {
      AsyncCachedImage(url: imageUrl, content: { imagePhase in
        switch imagePhase {
        case .success(let image):
          image
            .resizable()
            .frame(width: cardWidth, height: cardHeight)
        default:
          Color.gray
            .frame(width: cardWidth, height: cardWidth)
            .redacted(reason: .placeholder)
            .shimmering(bandSize: 0.4)
        }
      })
    }
  }
  
  @ViewBuilder
  private var detailsRectangle: some View {
    RoundedRectangle(cornerRadius: 30)
      .foregroundStyle(.white)
      .shadow(color: .gray.opacity(0.4), radius: 2, x: 1, y: 1)
      .frame(width: cardWidth, height: 80)
      .overlay {
        HStack {
          VStack(alignment: .leading) {
            Text(exercise.name)
              .font(.header(.bold, size: 15))
              .foregroundStyle(.black)
            if let equipment = exercise.equipment {
              Text(equipment)
                .font(.body(.regular, size: 15))
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
    ExerciseCard(exercise: ExerciseFactory.createExercise())
      .previewLayout(.sizeThatFits)
  }
}
