//
//  WorkoutCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//

import SwiftUI

struct CurrentWorkoutCardView: View {
  private let title: String
  private let description: String?
  private let options: [String]
  private let imageURL: URL?
  
  private let cardHeight: CGFloat
  private var cardWidth: CGFloat
  
  init(title: String,
       description: String? = nil,
       imageURL: URL? = nil,
       options: [String] = [],
       cardWidth: CGFloat = 300,
       cardHeight: CGFloat = 200
  ) {
    self.title = title
    self.description = description
    self.imageURL = imageURL
    self.options = options
    self.cardHeight = cardHeight
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
    if let imageURL {
      AsyncCachedImage(url: imageURL, content: { imagePhase in
        switch imagePhase {
        case .success(let image):
          image
            .frame(width: cardWidth, height: cardHeight)
        case .empty:
          defaultBackgroundView
            .shimmering()
        case .failure(_):
          defaultBackgroundView
        @unknown default:
          fatalError("Fatal error loading AsyncCachedImage")
        }
      })
    } else {
      defaultBackgroundView
    }
  }
  
  private var defaultBackgroundView: some View {
    Color.black
      .frame(width: cardWidth, height: cardHeight)
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
            Text(title)
              .font(.custom(AppFont.bold, size: 18))
              .foregroundStyle(.black)
            if let description {
              Text(description)
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
    CurrentWorkoutCardView(title: "Chest workout", description: "Some description")
      .previewLayout(.sizeThatFits)
  }
}
