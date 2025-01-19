//
//  ExerciseSessionHandler.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.01.2025.
//

import Combine
import DataRepository
import Factory
import Foundation
import Models
import Utility

class ExerciseSessionHandler: @unchecked Sendable {

  // MARK: Enums

  enum Event {
    case showXP(UserExperienceEntry)
    case didReceiveError(Error)
    case timerDidChange(Int)
    case timerDidReset
  }

  enum State {
    case idle
    case running(user: UserProfile, inputWeight: Double)
  }

  // MARK: Dependencies

  @LazyInjected(
    \DataRepositoryContainer
      .exerciseSessionRepository) private var exerciseSessionRepository: ExerciseSessionRepositoryProtocol

  @LazyInjected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepositoryProtocol

  // MARK: Properties

  private let exercise: Exercise
  private let eventSubject = PassthroughSubject<Event, Never>()

  private var state = State.idle
  private(set) var timerTask: Task<Void, Never>?
  private(set) var saveTask: Task<Void, Never>?
  private(set) var isTimerActive = false

  private(set) var elapsedTime = 0 {
    didSet {
      if elapsedTime > 0 {
        sendEvent(.timerDidChange(elapsedTime))
      }
    }
  }

  var eventPublisher: AnyPublisher<Event, Never> {
    eventSubject
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  init(exercise: Exercise) {
    self.exercise = exercise
  }

  // MARK: Public methods

  func startSession(forUser user: UserProfile, withInputWeight inputWeight: Double) {
    isTimerActive = true
    elapsedTime = 0
    state = .running(user: user, inputWeight: inputWeight)

    timerTask = Task { [weak self] in
      repeat {
        try? await Task.sleep(for: .seconds(1))
        self?.elapsedTime += 1
      } while !Task.isCancelled && self?.isTimerActive == true
    }
  }

  func stopSession() {
    isTimerActive = false
    timerTask?.cancel()
    eventSubject.send(.timerDidReset)

    guard case .running(let user, let inputWeight) = state else {
      return
    }

    saveTask = Task {
      do {
        let userExperience = try await saveSession(inputWeight: inputWeight, userProfile: user)
        eventSubject.send(.showXP(userExperience))
      } catch {
        eventSubject.send(.didReceiveError(error))
        Logger.error(error, message: "Could not save exercise session")
      }
    }
  }

  private func sendEvent(_ event: Event) {
    eventSubject.send(event)
  }

  nonisolated private func saveSession(inputWeight: Double, userProfile: UserProfile) async throws -> UserExperienceEntry {
    let exerciseSession = ExerciseSession(
      user: userProfile,
      exercise: exercise,
      duration: Double(elapsedTime),
      weight: inputWeight)
    let userExperienceEntry = try await exerciseSessionRepository.addSession(exerciseSession)
    await maybeUpdateGoals(for: exerciseSession)
    return userExperienceEntry
  }

  nonisolated private func maybeUpdateGoals(for exerciseSession: ExerciseSession) async {
    do {
      try await goalRepository.updateGoalProgress(exerciseSession: exerciseSession)
    } catch {
      Logger.error(error, message: "Cannot update goal progress")
    }
  }

  func cancelTasks() {
    timerTask?.cancel()
    saveTask?.cancel()
  }
}
