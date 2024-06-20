//
//  Person.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.10.2023.
//

import Foundation

struct User: Codable {
  var uuid = UUID()
  let avatar: String?
  let fullName: String?
  let username: String
  let email: String
  let isOnboarded: Bool
  let gender: String?
  let weight: Double?
  let height: Double?
  let level: String?
  let availableEquipment: [String]?
  let primaryGoalId: Int?
  
  init(
    email: String,
    fullName: String? = nil,
    username: String,
    avatar: String? = nil,
    isOnboarded: Bool = false,
    gender: String? = nil,
    weight: Double? = nil,
    height: Double? = nil,
    level: String? = nil,
    availableEquipment: [String]? = nil,
    primaryGoalId: Int? = nil
  ) {
    self.email = email
    self.fullName = fullName
    self.username = username
    self.avatar = avatar
    self.isOnboarded = isOnboarded
    self.gender = gender
    self.weight = weight
    self.height = height
    self.level = level
    self.availableEquipment = availableEquipment
    self.primaryGoalId = primaryGoalId
  }

  var avatarUrl: URL? {
    guard let avatar else { return nil }
    return URL(string: avatar)
  }
}

extension User: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(avatar)
    hasher.combine(fullName)
    hasher.combine(username)
    hasher.combine(email)
  }
}
