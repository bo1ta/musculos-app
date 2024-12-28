//
//  URL+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.11.2023.
//

import Foundation

extension URL {
  func isReachable() async -> Bool {
    var request = URLRequest(url: self)
    request.httpMethod = "HEAD"

    guard let (_, response) = try? await URLSession.shared.data(for: request) else {
      return false
    }
    return (response as? HTTPURLResponse)?.statusCode == 200
  }
}
