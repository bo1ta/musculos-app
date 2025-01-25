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
import SwiftUI

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

  @LazyInjected(\DataRepositoryContainer.exerciseSessionRepository) private var sessionRepository

  @LazyInjected(\DataRepositoryContainer.goalRepository) private var goalRepository

  // MARK: Properties

  private let exercise: Exercise
  private let eventSubject = PassthroughSubject<Event, Never>()
  private var state = State.idle
  private var timer: Timer?

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

  deinit {
    timer?.invalidate()
  }

  // MARK: Public methods

  func startSession(forUser user: UserProfile, withInputWeight inputWeight: Double) {
    isTimerActive = true
    elapsedTime = 0
    state = .running(user: user, inputWeight: inputWeight)

    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(incrementElapsedTime), userInfo: nil, repeats: true)
    if let timer {
      RunLoop.main.add(timer, forMode: .tracking)
    }
  }

  @objc private func incrementElapsedTime() {
    elapsedTime += 1
  }

  func stopSession() {
    isTimerActive = false
    timer?.invalidate()
    eventSubject.send(.timerDidReset)

    guard case .running(let user, let inputWeight) = state else {
      return
    }

    Task {
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
    let userExperienceEntry = try await sessionRepository.addSession(exerciseSession)
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
}
