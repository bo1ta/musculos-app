//
//  WorkoutChallenge.swift
//  Models
//
//  Created by Solomon Alexandru on 19.01.2025.
//

import Foundation

public enum ChallengeLevel: String, Codable {
  case beginner
  case intermediate
  case advanced
}

public struct WorkoutChallenge: Codable, Identifiable {
    public let id: UUID
    public let title: String
    public let description: String
    public let level: ChallengeLevel
    public let durationInDays: Int
    public let dailyWorkouts: [DailyWorkout]
    public var currentDay: Int
    public var startDate: Date?
    public var completionDate: Date?

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        level: ChallengeLevel,
        durationInDays: Int,
        dailyWorkouts: [DailyWorkout],
        currentDay: Int = 1,
        startDate: Date? = nil,
        completionDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.level = level
        self.durationInDays = durationInDays
        self.dailyWorkouts = dailyWorkouts
        self.currentDay = currentDay
        self.startDate = startDate
        self.completionDate = completionDate
    }
}
