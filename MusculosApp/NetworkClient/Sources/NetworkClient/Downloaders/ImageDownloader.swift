//
//  ImageCacheManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2024.
//

import Factory
import Foundation
import SwiftUI
import Utility

public actor ImageDownloader {
  @Injected(\NetworkContainer.imageService) private var service: ImageServiceProtocol

  private enum CacheEntry {
    case inProgress(Task<Image, Error>)
    case ready(Image)
  }

  private var cache: [URL: CacheEntry] = [:]

  public func imageFromURL(_ url: URL) async throws -> Image? {
    if let cached = cache[url] {
      switch cached {
      case .ready(let image):
        return image
      case .inProgress(let task):
        return try await task.value
      }
    }

    let task = Task {
      try await service.downloadImage(url: url)
    }

    cache[url] = .inProgress(task)

    do {
      let image = try await task.value
      cache[url] = .ready(image)
      return image
    } catch {
      cache[url] = nil
      throw error
    }
  }

  public func flushCache() {
    cache.removeAll()
  }
}
