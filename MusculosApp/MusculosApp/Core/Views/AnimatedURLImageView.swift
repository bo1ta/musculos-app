//
//  AnimatedURLImageView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.02.2024.
//

import Combine
import Foundation
import NetworkClient
import Shimmer
import SwiftUI
import Utility

/// Loops through a list of image URLs indefinitely to make them appear as "GIFs"
///
struct AnimatedURLImageView: View {
  let imageURLs: [URL]
  let interval: TimeInterval

  @State private var currentIndex = 0
  @State private var timer: Timer?

  init(imageURLs: [URL], interval: TimeInterval = .init(floatLiteral: 1)) {
    self.imageURLs = imageURLs
    self.interval = interval
  }

  var body: some View {
    VStack {
      if let imageUrl = imageURLs[safe: currentIndex] {
        AsyncCachedImage(url: imageUrl) { imagePhase in
          switch imagePhase {
          case .success(let image):
            image
              .resizable()
              .ignoresSafeArea()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: .infinity)
              .frame(minHeight: 300)

          case .empty:
            Color.white
              .frame(maxWidth: .infinity)
              .frame(minHeight: 300)
              .ignoresSafeArea()
              .shimmering()

          case .failure(let error):
            Color.red
              .frame(maxWidth: .infinity)
              .frame(minHeight: 300)
              .overlay(Text("Error: \(error.localizedDescription)"))

          @unknown default:
            fatalError("AsyncCachedImage fatal error")
          }
        }
      }
    }
    .onAppear(perform: startAnimating)
    .onDisappear(perform: stopAnimating)
  }

  private func startAnimating() {
    guard timer == nil, currentIndex == 0, imageURLs.count > 1 else {
      return
    }

    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
      updateCurrentIndex()
    }
    if let timer {
      RunLoop.current.add(timer, forMode: .common)
    }
  }

  private nonisolated func updateCurrentIndex() {
    Task { @MainActor in
      currentIndex = (currentIndex + 1) % imageURLs.count
    }
  }

  private func stopAnimating() {
    timer?.invalidate()
    timer = nil
  }
}

#Preview {
  AnimatedURLImageView(imageURLs: [])
}
