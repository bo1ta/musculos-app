//
//  Date+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.03.2024.
//
// swiftlint:disable force_unwrapping

import Foundation

extension Date {
  public static var yesterday: Date {
    Date().dayBefore
  }

  public static var tomorrow: Date {
    Date().dayAfter
  }

  public var dayBefore: Date {
    Calendar.current.date(byAdding: .day, value: -1, to: noon)!
  }

  public var dayAfter: Date {
    Calendar.current.date(byAdding: .day, value: 1, to: noon)!
  }

  public var noon: Date {
    Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
  }

  public var month: Int {
    Calendar.current.component(.month, from: self)
  }

  public var day: Int {
    Calendar.current.component(.day, from: self)
  }

  public var isLastDayOfMonth: Bool {
    dayAfter.month != month
  }

  public func monthName() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    return formatter.string(from: self)
  }

  public func dayName() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    return formatter.string(from: self)
  }
}

// swiftlint:enable force_unwrapping
