//
//  RecommendationSection+SectionItemImage.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.09.2024.
//

import SwiftUI
import Utility
import NetworkClient

extension RecommendationSection {
  struct SectionItemImage: View {
    let imageURL: URL?

    private let imageWidth: CGFloat = 100
    private let imageHeight: CGFloat = 100

    var body: some View {
      AsyncCachedImage(url: imageURL, scale: 0.5) { imagePhase in
        switch imagePhase {
        case .empty:
          RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.gray)
            .frame(width: imageWidth, height: imageHeight)
            .redacted(reason: .placeholder)
            .defaultShimmering()
        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imageWidth, height: imageHeight)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        case .failure(let error):
          EmptyView()
        @unknown default:
          EmptyView()
        }
      }
    }
  }
}

