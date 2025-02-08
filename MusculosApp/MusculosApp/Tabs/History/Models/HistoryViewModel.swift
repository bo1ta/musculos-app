//
//  HistoryViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.11.2024.
//

import Components
import DataRepository
import Factory
import Foundation
import Models
import Observation
import Utility

// MARK: - HistoryViewModel

@Observable
@MainActor
final class HistoryViewModel {
  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseSessionRepository) private var repository

  private(set) var filteredSessions: [ExerciseSession] = []
  private(set) var calendarMarkers: [CalendarMarker] = []
  private(set) var muscleChartData: [MuscleChartData] = []
  private(set) var sessionsChartData: [SessionChartData] = []

  private var exerciseSessions: [ExerciseSession] = []

  var selectedDate: Date? {
    didSet {
      updateFilteredSessions()
    }
  }

  func initialLoad() async {
    do {
      exerciseSessions = try await repository.getExerciseSessions()
      updateFilteredSessions()
      updateCalendarMarkers()
      updateChartData()
    } catch {
      Logger.error(error, message: "Cannot fetch sessions for History screen")
    }
  }

  private func updateCalendarMarkers() {
    calendarMarkers = exerciseSessions.map { .init(date: $0.dateAdded, color: .red) }
  }

  private func updateFilteredSessions() {
    if let date = selectedDate {
      filteredSessions = exerciseSessions.filter { Calendar.current.isDate($0.dateAdded, equalTo: date, toGranularity: .day) }
    } else {
      filteredSessions = exerciseSessions
    }
  }

  private func updateChartData() {
    muscleChartData = exerciseSessions
      .flatMap { $0.exercise.muscleTypes }
      .reduce(into: [:]) { counts, muscle in
        counts[muscle.rawValue, default: 0] += 1
      }
      .map { MuscleChartData(muscle: $0.key, count: $0.value) }

    sessionsChartData = exerciseSessions
      .reduce(into: [:]) { result, session in
        let day = session.dateAdded.dayName()
        result[day, default: 0] += 1
      }
      .map { SessionChartData(dayName: $0.key, count: $0.value) }
  }
}
