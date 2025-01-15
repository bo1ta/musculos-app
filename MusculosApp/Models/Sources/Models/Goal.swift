//
//  Goal.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import Foundation
import SwiftUI
import Utility

// MARK: - Goal

public struct Goal: Sendable, Codable {
  public let id: UUID
  public let name: String
  public let category: String?
  public let frequency: Frequency
  public var progressEntries: [ProgressEntry]?
  public let targetValue: Int
  public let endDate: Date?
  public let isCompleted: Bool
  public let dateAdded: Date
  public let user: UserProfile?
  public var userID: UUID?
  public let updatedAt: Date?

  public init(
    id: UUID = UUID(),
    name: String,
    category: String?,
    frequency: Frequency,
    progressEntries: [ProgressEntry]? = nil,
    targetValue: Int,
    endDate: Date?,
    isCompleted: Bool = false,
    dateAdded: Date,
    user: UserProfile? = nil,
    userID: UUID? = nil,
    updatedAt: Date? = Date())
  {
    self.id = id
    self.userID = userID
    self.name = name
    self.category = category
    self.frequency = frequency
    self.progressEntries = progressEntries
    self.targetValue = targetValue
    self.endDate = endDate
    self.isCompleted = isCompleted
    self.dateAdded = dateAdded
    self.user = user
    self.updatedAt = updatedAt
  }

  public init(onboardingGoal: OnboardingConstants.Goal, user: UserProfile) {
    id = UUID()
    name = onboardingGoal.title
    category = onboardingGoal.title
    frequency = .weekly
    progressEntries = []
    targetValue = 5
    endDate = DateHelper.getDateFromNextWeek()
    isCompleted = false
    dateAdded = Date()
    self.user = user
    updatedAt = Date()
  }

  public mutating func updateProgress(newValue: Double) {
    let entry = ProgressEntry(dateAdded: Date(), value: newValue, goal: self)
    progressEntries?.append(entry)
  }

  public var isExpired: Bool {
    if let endDate {
      return Date() > endDate
    }
    return false
  }

  public var daysUntilExpires: Int? {
    guard let endDate else {
      return nil
    }

    let calendar = Calendar.current
    let currentDate = Date()
    let components = calendar.dateComponents([.day], from: currentDate, to: endDate)
    return components.day
  }

  public var categoryType: Category? {
    guard let category, let categoryType = Category(rawValue: category) else {
      return nil
    }
    return categoryType
  }

  public var progressPercentage: Double {
    guard targetValue != 0 else {
      return 0
    }

    let progress = Double(currentValue) / Double(targetValue) * 100
    return min(max(progress, 0), 100)
  }

  public var formattedProgressPercentage: String {
    String(format: "%.0f%%", progressPercentage)
  }

  public var currentValue: Double {
    latestProgress?.value ?? 0
  }

  public var latestProgress: ProgressEntry? {
    progressEntries?.min(by: { $0.dateAdded < $1.dateAdded })
  }

  public var currentStreak: Int {
    guard let progressEntries else {
      return 0
    }

    var streak = 0

    let sortedHistory = progressEntries.sorted(by: { $0.dateAdded < $1.dateAdded })
    for (index, entry) in sortedHistory.enumerated() {
      guard index > 0 else {
        continue
      }
      if Calendar.current.isDate(entry.dateAdded, equalTo: sortedHistory[index - 1].dateAdded, toGranularity: .day) {
        streak += 1
      }
    }

    return streak
  }
}

// MARK: - Helper types

extension Goal {
  public enum Category: String, CaseIterable, Sendable, Codable {
    case loseWeight, gainWeight, growMuscle, drinkWater, general, buildMass = "Build mass & strength"

    public var label: String {
      switch self {
      case .loseWeight: "Lose weight"
      case .gainWeight: "Gain mass"
      case .growMuscle: "Grow muscles"
      case .drinkWater: "Drink water"
      case .general: "General"
      case .buildMass: "Build mass & strength"
      }
    }

    public var imageName: String {
      switch self {
      case .loseWeight: "treadmill-character"
      case .gainWeight: ""
      case .growMuscle, .buildMass: "strongman-icon"
      case .drinkWater: ""
      case .general: "dumbbell-icon"
      }
    }

    public var mappedExerciseCategories: [ExerciseConstants.CategoryType] {
      switch self {
      case .loseWeight, .general:
        [.cardio, .stretching, .plyometrics]

      case .gainWeight, .growMuscle, .buildMass:
        [
          .olympicWeightlifting,
          .strength,
          .strongman,
          .powerlifting,
        ]

      case .drinkWater:
        [.cardio, .stretching]
      }
    }

    public static func initFromLabel(_ label: String) -> Self {
      if let first = allCases.first { $0.label == label } {
        return first
      }
      return .general
    }
  }

  public enum Frequency: String, CaseIterable, Sendable, Codable {
    case daily
    case weekly
    case fixedDate

    public var description: String {
      switch self {
      case .daily: "daily"
      case .weekly: "weekly"
      case .fixedDate: "fixed date"
      }
    }
  }
}

// MARK: Hashable

extension Goal: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(dateAdded)
  }
}

// MARK: DecodableModel

extension Goal: DecodableModel { }
