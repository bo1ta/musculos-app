//
//  UserProfile.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.10.2023.
//

import Foundation
import Utility

public struct UserProfile: Codable, Sendable {
  public var userId: UUID
  public let avatar: String?
  public let fullName: String?
  public let username: String?
  public let email: String
  public let gender: String?
  public let weight: Double?
  public let height: Double?
  public let level: String?
  public let availableEquipment: [String]?
  public let primaryGoalId: Int?
  public var isOnboarded: Bool?

  public init(
    userId: UUID,
    email: String,
    fullName: String? = nil,
    username: String? = nil,
    avatar: String? = nil,
    gender: String? = nil,
    weight: Double? = nil,
    height: Double? = nil,
    level: String? = nil,
    availableEquipment: [String]? = nil,
    primaryGoalId: Int? = nil,
    isOnboarded: Bool? = false
  ) {
    self.userId = userId
    self.email = email
    self.fullName = fullName
    self.username = username
    self.avatar = avatar
    self.gender = gender
    self.weight = weight
    self.height = height
    self.level = level
    self.availableEquipment = availableEquipment
    self.primaryGoalId = primaryGoalId
    self.isOnboarded = isOnboarded
  }

  enum CodingKeys: String, CodingKey {
    case userId = "id"
    case avatar
    case fullName
    case username
    case email
    case gender
    case weight
    case height
    case level
    case availableEquipment = "equipment"
    case primaryGoalId
  }

  public var avatarUrl: URL? {
    guard let avatar else { return nil }
    return URL(string: avatar)
  }
}
