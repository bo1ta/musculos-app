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

@Observable
@MainActor
final class HistoryViewModel {
  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseSessionRepository) private var repository

  private(set) var filteredSessions: [ExerciseSession] = []
  private(set) var calendarMarkers: [CalendarMarker] = []

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
      updateCalendarMarkers(from: exerciseSessions)
    } catch {
      Logger.error(error, message: "Cannot fetch sessions for History screen")
    }
  }

  private func updateCalendarMarkers(from exerciseSessions: [ExerciseSession]) {
    calendarMarkers = exerciseSessions.map { .init(date: $0.dateAdded, color: .red) }
  }

  private func updateFilteredSessions() {
    if let date = selectedDate {
      filteredSessions = exerciseSessions.filter { Calendar.current.isDate($0.dateAdded, equalTo: date, toGranularity: .day) }
    } else {
      filteredSessions = exerciseSessions
    }
  }
}
