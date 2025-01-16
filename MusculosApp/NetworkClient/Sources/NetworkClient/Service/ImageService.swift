//
//  ImageService.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 28.12.2024.
//

import Factory
import SwiftUI
import Utility

// MARK: - ImageServiceProtocol

public protocol ImageServiceProtocol: Sendable {
  func uploadImage(_ image: UIImage) async throws -> URL
  func uploadImages(_ images: [UIImage]) async -> AsyncStream<Result<URL, Error>>
  func downloadImage(url: URL) async throws -> Image
}

// MARK: - ImageService

public struct ImageService: APIService, ImageServiceProtocol, @unchecked Sendable {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  public func uploadImage(_ image: UIImage) async throws -> URL {
    guard let imageData = image.jpegData(compressionQuality: 0.5) else {
      throw MusculosError.unexpectedNil
    }

    var request = APIRequest(method: .post, endpoint: .images(.upload))
    request.body = ["picture": imageData.base64EncodedString() as Any]

    let response = try await client.dispatch(request)
    let imageSource = try ImageSource.createFrom(response)

    guard let imageURL = APIEndpoint.baseWithPath(imageSource.filePath) else {
      throw MusculosError.unexpectedNil
    }

    return imageURL
  }

  public func uploadImages(_ images: [UIImage]) async -> AsyncStream<Result<URL, Error>> {
    AsyncStream { continuation in
      let task = Task {
        defer { continuation.finish() }

        await withTaskGroup(of: Result<URL, Error>.self) { group in
          for image in images {
            group.addTask {
              do {
                let imageURL = try await uploadImage(image)
                return .success(imageURL)
              } catch {
                Logger.error(error, message: "Error uploading image")
                return .failure(error)
              }
            }
          }

          for await result in group {
            continuation.yield(result)
          }
        }
      }

      continuation.onTermination = { _ in
        task.cancel()
      }
    }
  }

  public func downloadImage(url: URL) async throws -> Image {
    let data = try await client.dataFromURL(url)

    guard let uiImage = UIImage(data: data) else {
      throw MusculosError.unexpectedNil
    }
    return Image(uiImage: uiImage)
  }
}

// MARK: ImageService.ImageSource

extension ImageService {
  struct ImageSource: DecodableModel {
    let filePath: String
    let fileName: String
  }
}
