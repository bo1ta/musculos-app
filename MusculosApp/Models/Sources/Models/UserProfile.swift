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
  public let username: String
  public let email: String
  public let gender: String?
  public let weight: Double?
  public let height: Double?
  public let level: String?
  public let availableEquipment: [String]?
  public let primaryGoalID: Int?
  public var isOnboarded: Bool?
  public var xp: Int? = 0

  public init(
    userId: UUID,
    email: String,
    fullName: String? = nil,
    username: String,
    avatar: String? = nil,
    gender: String? = nil,
    weight: Double? = nil,
    height: Double? = nil,
    level: String? = nil,
    availableEquipment: [String]? = nil,
    primaryGoalId: Int? = nil,
    isOnboarded: Bool? = false,
    xp: Int? = 0
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
    self.primaryGoalID = primaryGoalId
    self.isOnboarded = isOnboarded
    self.xp = xp
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
    case primaryGoalID
    case isOnboarded
    case xp
  }

  public var avatarUrl: URL? {
    guard let avatar else { return nil }
    return URL(string: avatar)
  }
}

extension UserProfile: Equatable {
  public static func ==(_ lhs: UserProfile, rhs: UserProfile) -> Bool {
    return lhs.userId == rhs.userId
  }
}

extension UserProfile: DecodableModel {}
