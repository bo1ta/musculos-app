//
//  PhotoWriter.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.05.2024.
//

import Foundation
import SwiftUI

struct PhotoWriter {
  private static var documentsUrl: URL? {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths.first
  }
  
  static func saveImage(_ image: UIImage, with name: String) -> URL? {
    guard let documentsUrl, let data = image.pngData() else { return nil }
    
    let destionationUrl = documentsUrl.appendingPathComponent(name)
    do {
      try data.write(to: destionationUrl)
      return destionationUrl
    } catch {
      MusculosLogger.logError(error, message: "Could not write image to disk", category: .ui)
      return nil
    }
  }
}
