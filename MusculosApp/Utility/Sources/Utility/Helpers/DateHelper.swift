//
//  DateHelper.swift
//  Utility
//
//  Created by Solomon Alexandru on 08.06.2024.
//
// swiftlint:disable force_unwrapping

import Foundation

public enum DateHelper {
  public static func getCurrentDayRange() -> (Date, Date?) {
    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: Date())

    var dateComponents = DateComponents()
    dateComponents.day = 1

    let endOfDay = calendar.date(byAdding: dateComponents, to: startOfDay)
    return (startOfDay, endOfDay)
  }

  public static func getPastWeekRange() -> (Date?, Date) {
    let calendar = Calendar.current
    let now = Date()

    var dateComponents = DateComponents()
    dateComponents.day = -7
    let startOfPastWeek = calendar.date(byAdding: dateComponents, to: now)

    return (startOfPastWeek, now)
  }

  public static func getDateFromNextWeek() -> Date? {
    let calendar = Calendar.current
    let now = Date()

    var dateComponents = DateComponents()
    dateComponents.day = 7

    return calendar.date(byAdding: dateComponents, to: now)
  }

  public static func currentDayDisplay() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E dd MMM" // Format: Tue 11 Jul
    return dateFormatter.string(from: Date())
  }

  public static func nowPlusMinutes(_ minutes: Double) -> Date {
    return Date().addingTimeInterval(minutes * 60)
  }

  public static func nowPlusDays(_ days: Int) -> Date {
    return Calendar.current.date(byAdding: .day, value: days, to: Date())!
  }

  public static func nowPlusYears(_ years: Int) -> Date {
    return Calendar.current.date(byAdding: .year, value: years, to: Date())!
  }

  public static func formatTimeFromSeconds(_ seconds: Double) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = .pad
    return formatter.string(from: TimeInterval(seconds)) ?? ""
  }
}

// swiftlint:enable force_unwrapping
