//
//  DateHelper.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.06.2024.
//

import Foundation

struct DateHelper {
  static func getCurrentDayRange() -> (Date, Date?) {
    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: Date())
    
    var dateComponents = DateComponents()
    dateComponents.day = 1
    
    let endOfDay = calendar.date(byAdding: dateComponents, to: startOfDay)
    return (startOfDay, endOfDay)
  }
  
  static func getPastWeekRange() -> (Date?, Date) {
    let calendar = Calendar.current
    let now = Date()
    
    var dateComponents = DateComponents()
    dateComponents.day = -7
    let startOfPastWeek =  calendar.date(byAdding: dateComponents, to: now)
    
    return (startOfPastWeek, now)
  }
  
  static func getDateFromNextWeek() -> Date? {
    let calendar = Calendar.current
    let now = Date()
    
    var dateComponents = DateComponents()
    dateComponents.day = 7
    
    return calendar.date(byAdding: dateComponents, to: now)
  }
}
