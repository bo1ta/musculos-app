//
//  AsyncCachedImage.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//

import Foundation
import Factory
import SwiftUI
import Utility

/// Pulls Image from cache if exists
/// or uses AsyncImage to download it and cache it
///
public struct AsyncCachedImage<Content>: View where Content: View {
  @Injected(\NetworkContainer.imageDownloader) private var downloader: ImageDownloader

  private let url: URL?
  private let scale: CGFloat
  private let contentPhase: (AsyncImagePhase) -> Content

  @State private var isLoading = true
  @State private var loadedImage: Image?

  public init(
    url: URL?,
    scale: CGFloat = 1.0,
    @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) where Content: View
  {
    self.url = url
    self.scale = scale
    contentPhase = content
  }

  public var body: some View {
    VStack {
      if isLoading {
        contentPhase(.empty)
      } else if let loadedImage {
        contentPhase(.success(loadedImage))
      }
    }
    .task(id: url) {
      await loadImage()
    }
  }

  private func loadImage() async {
    guard let url else {
      return
    }

    isLoading = true
    defer { isLoading = false }

    do {
      loadedImage = try await downloader.imageFromURL(url)
    } catch {
//      Logger.error(MusculosError.unexpectedNil, message: "Unexpected nil for image")
    }
  }
}
