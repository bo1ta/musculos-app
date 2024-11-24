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

  private(set) var exerciseSessions: [ExerciseSession] = []
  private(set) var filteredSessions: [ExerciseSession] = []
  private(set) var calendarMarkers: [CalendarMarker] = []

  var selectedDate: Date? {
    didSet {
      guard let selectedDate else { return }
      filterSessions(by: selectedDate)
    }
  }

  func filterSessions(by date: Date) {
    filteredSessions = exerciseSessions.filter({ Calendar.current.isDate($0.dateAdded, equalTo: date, toGranularity: .day) })
  }

  func initialLoad() async {
    do {
      exerciseSessions = try await exerciseSessionRepository.getExerciseSessions()
      calendarMarkers = exerciseSessions.map { .init(date: $0.dateAdded, color: .red) }
    } catch {
      MusculosLogger.logError(error, message: "Cannot fetch sessions for History screen", category: .dataRepository)
    }
  }
}

