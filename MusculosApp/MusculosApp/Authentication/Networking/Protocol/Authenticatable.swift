//
//  Authenticatable.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Foundation

protocol Authenticatable {
  func register(email: String, password: String, username: String, fullName: String) async throws -> String
  func login(email: String, password: String) async throws -> String
}
