//
//  RecommendationSection+SectionItemImage.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.09.2024.
//

import SwiftUI
import Shimmer
import NetworkClient

extension RecommendationSection {
  struct SectionItemImage: View {
    let imageURL: URL?

    private let imageWidth: CGFloat = 100
    private let imageHeight: CGFloat = 140

    var body: some View {
      AsyncCachedImage(url: imageURL, scale: 0.5) { imagePhase in
        switch imagePhase {
        case .empty:
          Rectangle()
            .foregroundStyle(.white)
            .frame(width: imageWidth, height: imageHeight)
            .shimmering(gradient: Gradient(colors: [.white, .white.opacity(0.8)]))
        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaledToFit()
            .frame(width: imageWidth, height: imageHeight)
        case .failure(let error):
          EmptyView()
        @unknown default:
          EmptyView()
        }
      }
    }
  }
}

