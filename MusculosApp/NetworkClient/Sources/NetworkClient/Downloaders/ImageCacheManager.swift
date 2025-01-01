//
//  ImageCacheManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2024.
//

import Factory
import Foundation
import SwiftUI

// MARK: - ImageCacheManager

/// Shared instance of cached images
///
public actor ImageCacheManager {
  public static let shared = ImageCacheManager()

  private var cache: [URL: Image] = [:]
  private let imageDownloader = ImageDownloader()

  public subscript(url: URL?) -> Image? {
    get {
      guard let url else {
        return nil
      }
      return cache[url]
    }
    set {
      guard let url else {
        return
      }
      cache[url] = newValue
    }
  }

  public func add(_ image: Image, for url: URL) {
    cache[url] = image
  }

  public func imageForURL(_ url: URL) async -> Image? {
    if let image = cache[url] {
      image
    } else {
      await downloadAndCacheImage(url)
    }
  }

  @discardableResult
  private func downloadAndCacheImage(_ url: URL) async -> Image? {
    if let image = await imageDownloader.downloadImage(from: url) {
      add(image, for: url)
      return image
    }

    return nil
  }
}

// MARK: - ImageDownloader

struct ImageDownloader {
  var client: MusculosClient

  init(client: MusculosClient = MusculosClient()) {
    self.client = client
  }

  func downloadImage(from url: URL) async -> Image? {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      if let uiImage = UIImage(data: data) {
        return Image(uiImage: uiImage)
      } else {
        return nil
      }
    } catch {
      return nil
    }
  }
}
