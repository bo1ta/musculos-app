//
//  TransitionImagesView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.02.2024.
//

import Foundation
import SwiftUI
import Combine

struct AnimatedURLImageView: View {
  let imageURLs: [URL]
  let interval: TimeInterval
  
  init(imageURLs: [URL], interval: TimeInterval = .init(floatLiteral: 1)) {
    self.imageURLs = imageURLs
    self.interval = interval
  }
  
  @State private var currentIndex = 0
  @State private var cachedImages: [URL: UIImage] = [:]
  @State private var timer: Timer?
    
  var body: some View {
    VStack {
      if let image = cachedImages[imageURLs[currentIndex]] {
        Image(uiImage: image)
          .resizable()
          .ignoresSafeArea()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: .infinity)
          .frame(minHeight: 300)
      } else {
        Color.white
          .frame(maxWidth: .infinity)
          .frame(minHeight: 300)
          .ignoresSafeArea()
          .task {
            await downloadImages()
          }
          .shimmering()
      }
    }
    .onDisappear {
      stopAnimating()
    }
  }
  
  private func startAnimating() {
    guard timer == nil, currentIndex == 0, imageURLs.count > 1 else { return }
    
    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
      currentIndex = (currentIndex + 1) % imageURLs.count
    }
  }
  
  private func stopAnimating() {
    timer?.invalidate()
    timer = nil
  }
  
  @MainActor
  private func downloadImages() async {
    await imageURLs.asyncForEach { url in
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let image = UIImage(data: data) {
          cachedImages[url] = image
        }
      } catch {
        MusculosLogger.logError(error: error, message: "Error downloading images", category: .networking)
      }
    }
    startAnimating()
  }
}

#Preview {
  AnimatedURLImageView(imageURLs: [
    //    URL(string: "https://wqgqgfospzhwoqeqdzbo.supabase.co/storage/v1/object/public/workout_image/Lateral_Raise_-_With_Bands/images/0.jpg")!,
    //    URL(string: "https://wqgqgfospzhwoqeqdzbo.supabase.co/storage/v1/object/public/workout_image/Lateral_Raise_-_With_Bands/images/1.jpg")!
  ])
}
