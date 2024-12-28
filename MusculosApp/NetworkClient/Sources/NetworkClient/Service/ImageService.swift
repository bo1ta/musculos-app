//
//  ImageService.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 28.12.2024.
//

import SwiftUI
import Factory
import Utility

public protocol ImageServiceProtocol: Sendable {
  func uploadImage(image: UIImage) async throws -> URL
}

public struct ImageService: APIService, ImageServiceProtocol, @unchecked Sendable {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  public func uploadImage(image: UIImage) async throws -> URL {
    guard let encodedImage = encodedImage(image) else {
      throw MusculosError.badRequest
    }

    var request = APIRequest(method: .post, endpoint: .images(.upload))
    request.body = [
      "picture": encodedImage as Any
    ]

    let responseData = try await client.dispatch(request)
    let response = try ImageUploadResponse.createFrom(responseData)

    guard let imageURL = APIEndpoint.baseWithPath(response.filePath) else {
      throw MusculosError.notFound
    }
    return imageURL
  }

  private func encodedImage(_ image: UIImage) -> String? {
    guard let imageData = image.jpegData(compressionQuality: 0.5) else {
      return nil
    }
    return imageData.base64EncodedString()
  }
}

extension ImageService {
  struct ImageUploadResponse: DecodableModel {
    let filePath: String
    let fileName: String
  }
}
