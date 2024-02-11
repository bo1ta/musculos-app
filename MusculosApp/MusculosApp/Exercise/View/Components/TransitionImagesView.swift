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
        LoadingOverlayView()
      case .success(let image):
        image.resizable()
          .ignoresSafeArea()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: .infinity)
          .frame(minHeight: 300)
          .onAppear {
            startAnimating()
          }
      case .failure(_):
        LoadingOverlayView()
      @unknown default:
        fatalError("")
      }
      }
    .onDisappear {
      stopAnimating()
    }
  }
  
  @ViewBuilder
  private var rectangleView: some View {
    return Rectangle()
      .foregroundStyle(.red)
  }
  
  private func startAnimating() {
    guard timer == nil, currentIndex == 0 else { return }

    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
      withAnimation {
        currentIndex = (currentIndex + 1) % imageURLs.count
      }
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
