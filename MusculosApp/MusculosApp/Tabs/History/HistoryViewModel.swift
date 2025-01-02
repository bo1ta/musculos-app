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
  @Injected(
    \DataRepositoryContainer
      .exerciseSessionRepository) private var exerciseSessionRepository: ExerciseSessionRepositoryProtocol

  private var exerciseSessions: [ExerciseSession] = [] {
    didSet {
      calendarMarkers = exerciseSessions.map { .init(date: $0.dateAdded, color: .red) }
    }
  }

  private(set) var filteredSessions: [ExerciseSession] = []
  private(set) var calendarMarkers: [CalendarMarker] = []

  var selectedDate: Date? {
    didSet {
      updateFilteredSessions()
    }
  }

  func initialLoad() async {
    do {
      exerciseSessions = try await exerciseSessionRepository.getExerciseSessions()
      updateFilteredSessions()
    } catch {
      Logger.error(error, message: "Cannot fetch sessions for History screen")
    }
  }

  private func updateFilteredSessions() {
    if let date = selectedDate {
      filteredSessions = filterSessionByDay(date: date)
    } else {
      filteredSessions = exerciseSessions
    }
  }

  private func filterSessionByDay(date: Date) -> [ExerciseSession] {
    exerciseSessions.filter { Calendar.current.isDate($0.dateAdded, equalTo: date, toGranularity: .day) }
  }
}
