//
//  UserProfile.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.10.2023.
//

import Foundation
import Utility

// MARK: - UserProfile

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
  public let primaryGoalID: UUID?
  public var isOnboarded: Bool?
  public var xp: Int? = 0 // swiftlint:disable:this identifier_name
  public var goals: [Goal]?
  public var ratings: [ExerciseRating]?

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
    primaryGoalID: UUID? = nil,
    isOnboarded: Bool? = false,
    xp: Int? = 0, // swiftlint:disable:this identifier_name
    goals: [Goal]? = nil,
    ratings: [ExerciseRating]? = nil)
  {
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
    self.primaryGoalID = primaryGoalID
    self.isOnboarded = isOnboarded
    self.xp = xp
    self.goals = goals
    self.ratings = ratings
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
    case xp // swiftlint:disable:this identifier_name
    case goals
  }

  public var avatarUrl: URL? {
    guard let avatar else {
      return nil
    }
    return URL(string: avatar)
  }
}

// MARK: Equatable

extension UserProfile: Equatable {
  public static func ==(_ lhs: UserProfile, rhs: UserProfile) -> Bool {
    lhs.userId == rhs.userId
  }
}

// MARK: DecodableModel

extension UserProfile: DecodableModel { }
