//
//  Goal.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import Foundation
import SwiftUI
import Utility

public struct Goal: Sendable, Codable {
  public let id: UUID
  public let name: String
  public let category: Category
  public let frequency: Frequency
  public var progressHistory: [ProgressEntry]
  public let targetValue: Int
  public let endDate: Date?
  public let isCompleted: Bool
  public let dateAdded: Date
  public let user: UserProfile

  public init(
    id: UUID = UUID(),
    name: String,
    category: Category,
    frequency: Frequency,
    progressHistory: [ProgressEntry] = [],
    targetValue: Int,
    endDate: Date?,
    isCompleted: Bool = false,
    dateAdded: Date,
    user: UserProfile
  ) {
    self.id = id
    self.name = name
    self.category = category
    self.frequency = frequency
    self.progressHistory = progressHistory
    self.targetValue = targetValue
    self.endDate = endDate
    self.isCompleted = isCompleted
    self.dateAdded = dateAdded
    self.user = user
  }

  public init(onboardingGoal: OnboardingData.Goal, user: UserProfile) {
    self.id = UUID()
    self.name = onboardingGoal.title
    self.category = Category.initFromLabel(onboardingGoal.title) ?? .general
    self.frequency = .weekly
    self.progressHistory = []
    self.targetValue = 5
    self.endDate = DateHelper.getDateFromNextWeek()
    self.isCompleted = false
    self.dateAdded = Date()
    self.user = user
  }

  public mutating func updateProgress(newValue: Double) {
    let entry = ProgressEntry(dateAdded: Date(), value: newValue, goal: self)
    progressHistory.append(entry)
  }

  public var isExpired: Bool {
    if let endDate {
      return Date() > endDate
    }
    return false
  }

  public var daysUntilExpires: Int? {
    guard let endDate else { return nil }

    let calendar = Calendar.current
    let currentDate = Date()
    let components = calendar.dateComponents([.day], from: currentDate, to: endDate)
    return components.day
  }

  public var progressPercentage: Double {
    guard targetValue != 0 else {
      return 0
    }

    let progress = Double(currentValue) / Double(targetValue) * 100
    return min(max(progress, 0), 100)
  }

  public var formattedProgressPercentage: String {
    return String(format: "%.0f%%", progressPercentage)
  }

  public var currentValue: Double {
    return latestProgress?.value ?? 0
  }

  public var latestProgress: ProgressEntry? {
    return progressHistory.sorted(by: { $0.dateAdded < $1.dateAdded }).last
  }

  public var currentStreak: Int {
    var streak = 0

    let sortedHistory = progressHistory.sorted(by: { $0.dateAdded < $1.dateAdded })
    for (i, entry) in sortedHistory.enumerated() {
      guard i > 0 else {
        continue
      }
      if Calendar.current.isDate(entry.dateAdded, equalTo: sortedHistory[i - 1].dateAdded, toGranularity: .day) {
        streak += 1
      }
    }

    return streak
  }
}

// MARK: - Helper types

public extension Goal {
  public enum Category: String, CaseIterable, Sendable, Codable {
    case loseWeight, gainWeight, growMuscle, drinkWater, general

    public var label: String {
      switch self {
      case .loseWeight: "Lose weight"
      case .gainWeight: "Gain mass"
      case .growMuscle: "Grow muscles"
      case .drinkWater: "Drink water"
      case .general: "General"
      }
    }

    public var imageName: String {
      switch self {
      case .loseWeight: "treadmill-character"
      case .gainWeight: ""
      case .growMuscle: "muscle-icon"
      case .drinkWater: ""
      case .general: "dumbbell-icon"
      }
    }

    public static func initFromLabel(_ label: String) -> Self? {
      return Self.allCases.first { $0.label == label }
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

extension Goal: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(dateAdded)
  }
}
