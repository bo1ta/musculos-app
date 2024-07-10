//
//  Person.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.10.2023.
//

import Foundation

public struct User: Codable {
  public var uuid = UUID()
  public let avatar: String?
  public let fullName: String?
  public let username: String
  public let email: String
  public let isOnboarded: Bool
  public let gender: String?
  public let weight: Double?
  public let height: Double?
  public let level: String?
  public let availableEquipment: [String]?
  public let primaryGoalId: Int?
  
  public init(
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

  public var avatarUrl: URL? {
    guard let avatar else { return nil }
    return URL(string: avatar)
  }
}

extension User: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(avatar)
    hasher.combine(fullName)
    hasher.combine(username)
    hasher.combine(email)
  }
}
