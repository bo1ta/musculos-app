//
//  Authenticatable.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Foundation

protocol Authenticatable {
  func registerUser(email: String, password: String, username: String, fullName: String) async throws -> String
  func loginUser(email: String, password: String) async throws -> String
}
