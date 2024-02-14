//
//  TransitionImagesView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.02.2024.
//

import Foundation
import SwiftUI

struct AnimatedURLImageView: View {
  let imageURLs: [URL]
  let interval: TimeInterval = .init(floatLiteral: 0.8)
  
  @State private var currentIndex = 0
  @State private var timer: Timer?
      
  var body: some View {    
    AsyncImage(url: imageURLs[currentIndex]) { phase in
      switch phase {
      case .empty:
        handleFailure()
      case .success(let image):
        image.resizable()
          .ignoresSafeArea()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: .infinity)
          .frame(minHeight: 300)
      case .failure(let error):
        handleFailure(error)
      @unknown default:
        fatalError("")
      }
      }
    .onAppear {
      startAnimating()
    }
    .onDisappear {
      stopAnimating()
    }
  }
  
  @ViewBuilder
  private func handleFailure(_ error: Error? = nil) -> some View {
    print(error ?? MusculosError.badRequest)
    print(currentIndex)
    print(imageURLs[currentIndex])
    return LoadingOverlayView()
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
}

#Preview {
  AnimatedURLImageView(imageURLs: [
    URL(string: "https://wqgqgfospzhwoqeqdzbo.supabase.co/storage/v1/object/public/workout_image/Lateral_Raise_-_With_Bands/images/0.jpg")!,
    URL(string: "https://wqgqgfospzhwoqeqdzbo.supabase.co/storage/v1/object/public/workout_image/Lateral_Raise_-_With_Bands/images/1.jpg")!
  ])
}
