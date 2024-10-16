//
//  MusculosTestBase.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import Foundation
import XCTest
import Models
import Storage
import Utility

@testable import MusculosApp

protocol MusculosTestBase: AnyObject {
  /// Populate the storage with mock exercise
  ///
  func populateStorageWithExercise(exercise: Exercise) async throws
  
  /// Parses a file into Data
  ///`name` - The name of the file
  ///`withExtension` - The file extension. Default json
  ///
  func parseDataFromFile(name: String, withExtension: String) throws -> Data
  
  /// Creates a mock session configuration which that works with the `MusculosClient`
  /// `expectation` - Fulfilled when the request ended
  /// `srcFileName` - The JSON file name used for the mock response
  /// `shouldFail` - If true, the request will throw a badRequest exception. Default: false
  ///
  func createMockSession(jsonFileName: String?, expectation: XCTestExpectation?, shouldFail: Bool) -> URLSessionConfiguration
}

/// MARK: - Default implementation
///
extension MusculosTestBase {
  func parseDataFromFile(name: String, withExtension: String = "json") throws -> Data {
    let bundle = Bundle(for: (type(of: self)))
    let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
    let data = try Data(contentsOf: fileUrl!)
    return data
  }
  
  func populateStorageWithExercise(exercise: Exercise = ExerciseFactory.createExercise()) async throws {
    let exerciseDataStore = ExerciseDataStore()
//    _ = try await exerciseDataStore.importFrom([exercise])
  }
  
  func createMockSession(jsonFileName: String? = nil, expectation: XCTestExpectation? = nil, shouldFail: Bool = false) -> URLSessionConfiguration {
    MockURLProtocol.expectation = expectation
    MockURLProtocol.requestHandler = { request in
      guard !shouldFail, let url = request.url else { throw MusculosError.badRequest }
      
      let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
      var data = Data()
      
      if let jsonFileName {
        data = try XCTUnwrap(self.parseDataFromFile(name: jsonFileName))
      }
  
      return (response, data)
    }
    
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocol.self]
    return configuration
  }
}
