//
//  ExerciseDetailsViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.05.2024.
//

import Combine
import Components
import DataRepository
import Factory
import Foundation
import Models
import Storage
import SwiftUI
import Utility

@Observable
@MainActor
final class ExerciseDetailsViewModel {

  // MARK: Dependencies

  @ObservationIgnored
  @Injected(\.toastManager) private var toastManager: ToastManagerProtocol

  @ObservationIgnored
  @Injected(\.userStore) var userStore: UserStoreProtocol

  @ObservationIgnored
  @Injected(\.soundManager) var soundManager: SoundManager

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.ratingRepository) private var ratingRepository: RatingRepositoryProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepositoryProtocol

  @ObservationIgnored
  @Injected(
    \DataRepositoryContainer
      .exerciseSessionRepository) private var exerciseSessionRepository: ExerciseSessionRepositoryProtocol

  // MARK: Public

  private(set) var markFavoriteTask: Task<Void, Never>?
  private(set) var saveExerciseSessionTask: Task<Void, Never>?
  private(set) var saveRatingTask: Task<Void, Never>?
  private(set) var timerTask: Task<Void, Never>?

  private(set) var showChallengeExercise = false
  private(set) var isTimerActive = false
  private(set) var elapsedTime = 0

  var showInputDialog = false
  var showRatingDialog = false
  var showXPGainDialog = false
  var currentUserExperienceEntry: UserExperienceEntry?
  var userRating = 0
  var exerciseRatings: [ExerciseRating] = []
  var inputWeight: Double = 0

  var currentUser: UserProfile? {
    userStore.currentUser
  }

  var ratingAverage: Double {
    guard !exerciseRatings.isEmpty else {
      return 0.0
    }
    return exerciseRatings.reduce(0) { $0 + $1.rating } / Double(exerciseRatings.count)
  }

  var currentXPGain: Int {
    guard let currentUserExperienceEntry else {
      return 0
    }
    return currentUserExperienceEntry.xpGained
  }

  var isFavorite: Bool {
    exercise.isFavorite ?? false
  }

  var goals: [Goal] {
    currentUser?.goals ?? []
  }

  // MARK: - Init and Setup

  var exercise: Exercise

  init(exercise: Exercise) {
    self.exercise = exercise
  }

  // MARK: - Public methods

  func initialLoad() async {
    async let exerciseDetailsTask: Void = loadExerciseDetails()
    async let exerciseRatingsTask: Void = loadExerciseRatings()

    _ = await (exerciseDetailsTask, exerciseRatingsTask)
  }

  func cancelAllTasks() {
    markFavoriteTask?.cancel()
    saveExerciseSessionTask?.cancel()
    saveRatingTask?.cancel()
    timerTask?.cancel()
  }

  private func loadExerciseDetails() async {
    do {
      exercise = try await exerciseRepository.getExerciseDetails(for: exercise.id)
    } catch {
      showErrorToast()
      Logger.error(error, message: "Cannot load exercise details")
    }
  }

  private func loadExerciseRatings() async {
    do {
      exerciseRatings = try await ratingRepository.getRatingsForExercise(exercise.id)

      guard
        let currentUserID = currentUser?.userId,
        let userRating = exerciseRatings.last(where: { $0.userID == currentUserID })?.rating
      else {
        return
      }
      self.userRating = Int(userRating)

    } catch {
      showErrorToast()
      Logger.error(error, message: "Could not load exercise ratings")
    }
  }

  private func showErrorToast() {
    toastManager.showError("Oops! Something went wrong")
  }

  func handleSubmit() {
    if isTimerActive {
      stopSession()
    } else {
      showInputDialog.toggle()
    }
  }

  func startSession() {
    soundManager.playSound(.exerciseSessionInProgress)

    isTimerActive = true
    elapsedTime = 0

    timerTask = Task { [weak self] in
      repeat {
        try? await Task.sleep(for: .seconds(1))
        self?.elapsedTime += 1
      } while !Task.isCancelled && self?.isTimerActive == true
    }
  }

  func stopSession() {
    soundManager.stopSound()

    isTimerActive = false
    timerTask?.cancel()

    saveExerciseSession()
  }

  func saveRating(_ rating: Int) {
    saveRatingTask = Task {
      do {
        try await ratingRepository.addRating(rating: Double(rating), for: exercise.id)
        showRatingDialog = false
      } catch {
        Logger.error(error, message: "Could not save rating")
      }
    }
  }

  func toggleIsFavorite() {
    markFavoriteTask?.cancel()

    markFavoriteTask = Task {
      do {
        try Task.checkCancellation()

        try await exerciseRepository.setFavoriteExercise(exercise, isFavorite: !isFavorite)
        await loadExerciseDetails()

        playFavoriteExerciseActionSound()
      } catch {
        showErrorToast()
        Logger.error(error, message: "Could not update exercise.isFavorite")
      }
    }
  }

  private func playFavoriteExerciseActionSound() {
    if isFavorite {
      soundManager.playSound(.favoriteExercise)
    } else {
      soundManager.playSound(.unfavoriteExercise)
    }
  }

  private func saveExerciseSession() {
    saveExerciseSessionTask = Task {
      guard let currentUser else {
        return
      }

      do {
        let exerciseSession = ExerciseSession(
          user: currentUser,
          exercise: exercise,
          duration: Double(elapsedTime),
          weight: inputWeight)

        let userExperience = try await exerciseSessionRepository.addSession(exerciseSession)

        await showUserExperience(userExperience)
        await maybeUpdateGoals(for: exerciseSession)

      } catch {
        showErrorToast()
        Logger.error(error, message: "Could not save exercise session")
      }
    }
  }

  private func showUserExperience(_ userExperience: UserExperienceEntry) async {
    currentUserExperienceEntry = userExperience

    withAnimation {
      showXPGainDialog = true
    }

    try? await Task.sleep(for: .milliseconds(500))
    soundManager.playSound(.gainedExperience)

    try? await Task.sleep(for: .seconds(2))

    withAnimation {
      showXPGainDialog = false
    }
  }

  nonisolated private func maybeUpdateGoals(for exerciseSession: ExerciseSession) async {
    do {
      try await goalRepository.updateGoalProgress(exerciseSession: exerciseSession)
    } catch {
      Logger.error(error, message: "Cannot update goal progress")
    }
  }
}
