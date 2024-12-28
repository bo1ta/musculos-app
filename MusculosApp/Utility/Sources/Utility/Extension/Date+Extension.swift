//
//  Date+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.03.2024.
//
// swiftlint:disable force_unwrapping

import Foundation

public extension Date {
  static var yesterday: Date {
    return Date().dayBefore
  }

  static var tomorrow: Date {
    return Date().dayAfter
  }

  var dayBefore: Date {
    return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
  }

  var dayAfter: Date {
    return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
  }

  var noon: Date {
    return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
  }

  var month: Int {
    return Calendar.current.component(.month, from: self)
  }

  var day: Int {
    Calendar.current.component(.day, from: self)
  }

  var isLastDayOfMonth: Bool {
    return dayAfter.month != month
  }

  func monthName() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    return formatter.string(from: self)
  }

  func dayName() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    return formatter.string(from: self)
  }
}

// swiftlint:enable force_unwrapping
