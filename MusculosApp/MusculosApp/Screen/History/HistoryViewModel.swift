//
//  HistoryViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.11.2024.
//

import Observation
import Foundation
import Factory
import Models
import DataRepository
import Utility
import Components

@Observable
@MainActor
final class HistoryViewModel {

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseSessionRepository) private var exerciseSessionRepository: ExerciseSessionRepository

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
      MusculosLogger.logError(error, message: "Cannot fetch sessions for History screen", category: .dataRepository)
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
   return exerciseSessions.filter({ Calendar.current.isDate($0.dateAdded, equalTo: date, toGranularity: .day) })
  }
}

