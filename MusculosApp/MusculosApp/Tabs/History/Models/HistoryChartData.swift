//
//  HistoryChartData.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2025.
//

import Components
import Models

struct HistoryChartData {
  var calendarMarkers: [CalendarMarker]
  var muscleChartData: [MuscleChartData]
  var sessionsChartData: [SessionChartData]

  init(exerciseSessions: [ExerciseSession]) {
    calendarMarkers = Self.mapSessionsToCalendarMarkers(exerciseSessions)
    muscleChartData = Self.mapSessionsToMuscleChartData(exerciseSessions)
    sessionsChartData = Self.mapSessionsToSessionsChartData(exerciseSessions)
  }

  private static func mapSessionsToCalendarMarkers(_ sessions: [ExerciseSession]) -> [CalendarMarker] {
    sessions
      .map { CalendarMarker(date: $0.dateAdded, color: .red) }
  }

  private static func mapSessionsToMuscleChartData(_ sessions: [ExerciseSession]) -> [MuscleChartData] {
    sessions
      .flatMap { $0.exercise.muscleTypes }
      .reduce(into: [:]) { counts, muscle in
        counts[muscle.rawValue, default: 0] += 1
      }
      .map { MuscleChartData(muscle: $0.key, count: $0.value) }
  }

  private static func mapSessionsToSessionsChartData(_ sessions: [ExerciseSession]) -> [SessionChartData] {
    sessions
      .reduce(into: [:]) { result, session in
        let day = session.dateAdded.dayName()
        result[day, default: 0] += 1
      }
      .map { SessionChartData(dayName: $0.key, count: $0.value) }
  }
}
