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
  @Injected(\StorageContainer.coreDataStore) private var coreDataStore: CoreDataStore

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.userStore) private var userStore: UserStoreProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepositoryProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.ratingRepository) private var ratingRepository: RatingRepositoryProtocol

  @ObservationIgnored
  @Injected(
    \DataRepositoryContainer
      .exerciseSessionRepository) private var exerciseSessionRepository: ExerciseSessionRepositoryProtocol

  // MARK: - Observed properties

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

  private var currentUserID: UUID? {
    userStore.currentUser?.userId
  }

  private var currentUserProfile: UserProfile? {
    userStore.currentUser
  }

  // MARK: - Tasks

  private(set) var markFavoriteTask: Task<Void, Never>?
  private(set) var saveExerciseSessionTask: Task<Void, Never>?
  private(set) var saveRatingTask: Task<Void, Never>?
  private(set) var timerTask: Task<Void, Never>?

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
        let currentUserID,
        let userRating = exerciseRatings.first(where: { $0.userID == currentUserID })?.rating
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
      stopTimer()
    } else {
      showInputDialog.toggle()
    }
  }

  func startTimer() {
    isTimerActive = true
    elapsedTime = 0

    timerTask = Task { [weak self, isTimerActive] in
      repeat {
        try? await Task.sleep(for: .seconds(1))
        self?.elapsedTime += 1
      } while !Task.isCancelled && isTimerActive
    }
  }

  func stopTimer() {
    isTimerActive = false
    timerTask?.cancel()

    saveExerciseSession()
  }

  func saveRating(_ rating: Int) {
    showRatingDialog = false

    saveRatingTask = Task { [weak self] in
      guard let self else {
        return
      }

      do {
        try await ratingRepository.addRating(rating: Double(rating), for: exercise.id)
        await loadExerciseRatings()
      } catch {
        Logger.error(error, message: "Could not save rating")
      }
    }
  }

  func toggleIsFavorite() {
    markFavoriteTask?.cancel()

    markFavoriteTask = Task { [weak self] in
      guard let self else {
        return
      }

      do {
        try await exerciseRepository.setFavoriteExercise(exercise, isFavorite: !isFavorite)
        await loadExerciseDetails()
      } catch {
        showErrorToast()
        Logger.error(error, message: "Could not update exercise.isFavorite")
      }
    }
  }

  private func saveExerciseSession() {
    saveExerciseSessionTask = Task { [weak self] in
      guard let self, let currentUserProfile = userStore.currentUser else {
        return
      }

      do {
        let exerciseSession = ExerciseSession(
          user: currentUserProfile,
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

    try? await Task.sleep(for: .seconds(2))

    withAnimation {
      showXPGainDialog = false
    }
  }

  private func maybeUpdateGoals(for exerciseSession: ExerciseSession) async {
    guard let currentUserID else {
      return
    }

    do {
      try await coreDataStore.updateGoalProgress(userID: currentUserID, exerciseSession: exerciseSession)
    } catch {
      Logger.error(error, message: "Cannot update goal progress")
    }
  }

  // MARK: - Clean up

  func cleanUp() {
    markFavoriteTask?.cancel()
    saveExerciseSessionTask?.cancel()
    saveRatingTask?.cancel()
    timerTask?.cancel()
  }
}
