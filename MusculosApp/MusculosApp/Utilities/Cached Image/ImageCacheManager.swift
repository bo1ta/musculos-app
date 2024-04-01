//
//  ImageCacheManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.04.2024.
//

import Foundation
import SwiftUI

/// Shared instance of cached images
///
final class ImageCacheManager: @unchecked Sendable {
  static let shared = ImageCacheManager()
  
  private var cache: [URL: Image] = [:]

  subscript(url: URL?) -> Image? {
    get {
      guard let url else { return nil }
      return cache[url]
    }
    set {
      guard let url else { return }
      cache[url] = newValue
    }
  }
}
