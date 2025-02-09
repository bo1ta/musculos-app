//
//  HistoryViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.11.2024.
//

import Combine
import Components
import DataRepository
import Factory
import Foundation
import Models
import Observation
import Storage
import Utility

@Observable
@MainActor
final class HistoryViewModel: BaseViewModel, TabViewModel {

  // MARK: Private

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseSessionRepository) private var repository

  private var cancellables: Set<AnyCancellable> = []
  private var fetchedResultsPublisher: FetchedResultsPublisher<ExerciseSessionEntity>?

  private var exerciseSessions: [ExerciseSession] = [] {
    didSet {
      guard !exerciseSessions.isEmpty else {
        return
      }
      historyChartData = HistoryChartData(exerciseSessions: exerciseSessions)
    }
  }

  // MARK: Public

  var historyChartData: HistoryChartData?
  var selectedDate: Date?

  var displayExercises: [Exercise] {
    let exerciseSessions =
      if let selectedDate {
        exerciseSessions.filter { Calendar.current.isDate($0.dateAdded, equalTo: selectedDate, toGranularity: .day) }
      } else {
        exerciseSessions
      }
    return exerciseSessions.map { $0.exercise }
  }

  var shouldLoad: Bool {
    exerciseSessions.isEmpty
  }

  init() {
    fetchedResultsPublisher = try? repository.fetchedResultsPublisherForCurrentUser()
    fetchedResultsPublisher?.publisher
      .sink { [weak self] event in
        self?.didReceiveFetchedResultsEvent(event)
      }
      .store(in: &cancellables)
  }

  private func didReceiveFetchedResultsEvent(_ event: FetchedResultsPublisher<ExerciseSessionEntity>.Event) {
    switch event {
    case .didUpdateContent(let results):
      exerciseSessions = results

    case .didInsertModel(let session):
      guard !exerciseSessions.contains(where: { $0.id == session.id }) else {
        return
      }
      exerciseSessions.append(session)

    case .didDeleteModel(let session):
      guard let firstIndex = exerciseSessions.firstIndex(where: { $0.id == session.id }) else {
        return
      }
      exerciseSessions.remove(at: firstIndex)

    case .didUpdateModel(let session):
      guard let firstIndex = exerciseSessions.firstIndex(where: { $0.id == session.id }) else {
        return
      }
      exerciseSessions[firstIndex] = session
    }
  }

  func initialLoad() async {
    guard shouldLoad else {
      return
    }

    do {
      exerciseSessions = try await repository.getExerciseSessions()
    } catch {
      Logger.error(error)
    }
  }
}
