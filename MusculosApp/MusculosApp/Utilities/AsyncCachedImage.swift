//
//  AsyncCachedImage.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//

import Foundation
import SwiftUI

/// Pulls Image from the cache if exists
/// or uses AsyncImage to download it
///
struct AsyncCachedImage<Content>: View where Content: View {
  private let url: URL?
  private let scale: CGFloat
  private let transaction: Transaction
  private let contentPhase: ((AsyncImagePhase) -> Content)
  
  init(url: URL?,
       scale: CGFloat = 1.0,
       transaction: Transaction = Transaction(),
       @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
  ) where Content: View {
    self.url = url
    self.scale = scale
    self.transaction = transaction
    self.contentPhase = content
  }
  
  var body: some View {
    VStack {
      if let cached = ImageCacheManager.shared[url] {
        contentPhase(.success(cached))
      } else {
        AsyncImage(
          url: url,
          scale: scale,
          transaction: transaction,
          content: { cacheAndRender(phase: $0) }
        )
      }
    }
  }
  
  private func cacheAndRender(phase: AsyncImagePhase) -> some View {
    if case .success(let image) = phase {
      ImageCacheManager.shared[url] = image
    }
    return contentPhase(phase)
  }
}
