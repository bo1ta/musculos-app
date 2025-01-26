//
//  ImageServiceTests.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 28.12.2024.
//

import Factory
import Foundation
import Testing
import UIKit

@testable import Models
@testable import NetworkClient
@testable import Utility

@Suite(.serialized)
final class ImageServiceTests: MusculosTestBase {
  @Test
  func uploadImage() async throws {
    var stubClient = MockMusculosClient()
    stubClient.expectedMethod = .post
    stubClient.expectedEndpoint = .images(.upload)
    stubClient.expectedResponseData = try parseDataFromFile(name: "imageUpload")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = ImageService()
    let mockImage = try #require(createMockImage())
    let imageURL = try await service.uploadImage(image: mockImage)
    let expectedURL = APIEndpoint.baseWithPath("/directory/fileName.jpg")
    #expect(imageURL == expectedURL)
  }

  private func createMockImage() -> UIImage? {
    let size = CGSize(width: 100, height: 100)

    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    defer { UIGraphicsEndImageContext() }

    let context = UIGraphicsGetCurrentContext()
    context?.clear(CGRect(origin: .zero, size: size))

    return UIGraphicsGetImageFromCurrentImageContext()
  }
}
