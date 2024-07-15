//
//  UserSession.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.07.2024.
//

import Foundation
import Utility

struct UserSession: Codable, DecodableModel {
  var authToken: String
  var userId: UUID
  var email: String
  var username: String?
  var isOnboarded: Bool
}
