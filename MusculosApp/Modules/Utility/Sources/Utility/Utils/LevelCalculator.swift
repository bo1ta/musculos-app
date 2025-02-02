//
//  LevelCalculator.swift
//  Utility
//
//  Created by Solomon Alexandru on 02.02.2025.
//

import Foundation

public enum LevelCalculator {

  /// Base XP required for level 1
  ///
  private static let baseXP = 100

  /// The exponent that controls how quickly XP requirements grow
  ///
  private static let exponent = 1.5

  /// Calculates the level based on the total XP
  /// - Parameter totalXP: The user's total experience points (XP)
  /// - Returns: The user's current level
  ///
  public static func calculateLevel(_ totalXP: Int) -> Int {
    guard totalXP >= 0 else {
      return 1
    }
    let level = Int(pow(Double(totalXP) / Double(baseXP), 1 / exponent)) + 1
    return max(1, level)
  }

  /// Calculates the total XP required to reach a specific level
  /// - Parameter level: The level to calculate the XP requirement for
  /// - Returns: The total XP required to reach the specified level
  ///
  public static func xpRequiredForLevel(_ level: Int) -> Int {
    Int(pow(Double(level), exponent) * Double(baseXP))
  }

  /// Calculates the XP range for a given level
  /// - Parameter level: The level to calculate the XP range for
  /// - Returns: A tuple containing the minimum and maximum XP required for the level
  ///
  public static func xpRangeForLevel(_ level: Int) -> (min: Int, max: Int) {
    let minXP = level == 1 ? 0 : xpRequiredForLevel(level - 1)
    let maxXP = xpRequiredForLevel(level)
    return (minXP, maxXP)
  }

  /// Calculates the remaining XP needed to reach the next level
  /// - Parameter totalXP: The user's total experience
  /// - Returns: The remaining XP needed to reach the next level
  ///
  public static func remainingXPToNextLevel(totalXP: Int) -> Int {
    let currentLevel = calculateLevel(totalXP)
    let requiredXPForCurrentLevel = xpRequiredForLevel(currentLevel)
    return max(0, requiredXPForCurrentLevel - totalXP)
  }
}
