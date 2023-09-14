//
//  MockMusculosClient.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import Foundation
import XCTest

//struct MockMusculosClient: MusculosClientProtocol {
//    var expectedData: Data?
//    var expectedError: Error?
//    var dispatchExpectation: XCTestExpectation?
//    
//    func dispatch(_ request: APIRequest) async throws -> Data {
//        self.dispatchExpectation?.fulfill()
//
//        if let error = self.expectedError {
//            throw error
//        }
//    
//        if let data = self.expectedData {
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            
//            let decodedData = try decoder.decode(
//            return data
//        }
//        return Data()
//    }
//}
