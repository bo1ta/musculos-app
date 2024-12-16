//
//  PhotoWriter.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.05.2024.
//

import Foundation
import SwiftUI

public struct PhotoWriter {
  private static var documentsUrl: URL? {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths.first
  }
  
  public static func saveImage(_ image: UIImage, with name: String) -> URL? {
    guard let documentsUrl, let data = image.pngData() else { return nil }
    
    let destionationUrl = documentsUrl.appendingPathComponent(name)
    do {
      try data.write(to: destionationUrl)
      return destionationUrl
    } catch {
      Logger.error(error, message: "Could not write image to disk")
      return nil
    }
  }
}
