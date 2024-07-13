//
//  MuscleClientProtocol.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation
import Combine
import Utility

protocol MusculosClientProtocol: Sendable {
  func dispatch(_ request: APIRequest) async throws -> Data
}
