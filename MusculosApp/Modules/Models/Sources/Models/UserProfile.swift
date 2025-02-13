//
//  UserProfile.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.10.2023.
//

import Foundation
import Utility

// MARK: - UserProfile

public struct UserProfile: Codable, Sendable, Identifiable {
  public var id: UUID
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
  public var isOnboarded: Bool
  public var totalExperience: Int?
  public var goals: [Goal]?
  public var ratings: [ExerciseRating]?
  public var userExperience: UserExperience?

  public init(
    id: UUID,
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
    isOnboarded: Bool = false,
    totalExperience: Int? = 0,
    goals: [Goal]? = nil,
    ratings: [ExerciseRating]? = nil,
    userExperience: UserExperience? = nil)
  {
    self.id = id
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
    self.totalExperience = totalExperience
    self.goals = goals
    self.ratings = ratings
    self.userExperience = userExperience
  }

  enum CodingKeys: String, CodingKey {
    case id
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
    case totalExperience
    case goals
  }

  public var avatarUrl: URL? {
    guard let avatar else {
      return nil
    }
    return URL(string: avatar)
  }

  public var currentLevel: Int {
    LevelCalculator.calculateLevel(totalExperience ?? 0)
  }

  public var currentLevelXPRange: (min: Int, max: Int) {
    LevelCalculator.xpRangeForLevel(currentLevel)
  }

  public var remainingXPToNextLevel: Int {
    LevelCalculator.remainingXPToNextLevel(totalXP: totalExperience ?? 0)
  }

  public var currentLevelProgress: Double {
    LevelCalculator.progressTowardsNextLevel(totalXP: totalExperience ?? 0)
  }
}

// MARK: Equatable

extension UserProfile: Equatable {
  public static func ==(_ lhs: UserProfile, rhs: UserProfile) -> Bool {
    lhs.id == rhs.id
  }
}

// MARK: DecodableModel

extension UserProfile: DecodableModel { }

// MARK: IdentifiableEntity

extension UserProfile: IdentifiableEntity { }
