//
//  AsyncCachedImage.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//

import Foundation
import SwiftUI

/// Pulls Image from cache if exists
/// or uses AsyncImage to download it and cache it
///
struct AsyncCachedImage<Content>: View where Content: View {
  private let url: URL?
  private let scale: CGFloat
  private let contentPhase: ((AsyncImagePhase) -> Content)
  
  @State private var isLoading = true
  @State private var loadedImage: Image? = nil
  
  init(url: URL?,
       scale: CGFloat = 1.0,
       @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
  ) where Content: View {
    self.url = url
    self.scale = scale
    self.contentPhase = content
  }
  
  var body: some View {
    VStack {
      if isLoading {
        contentPhase(.empty)
      } else if let loadedImage {
        contentPhase(.success(loadedImage))
      }
    }
    .task(id: self.url) {
      await loadImage()
    }
  }
  
  private func loadImage() async {
    if let url {
      defer { isLoading = false }
      
      let image = await ImageCacheManager.shared.imageForURL(url)
      loadedImage = image
    }
  }
}
