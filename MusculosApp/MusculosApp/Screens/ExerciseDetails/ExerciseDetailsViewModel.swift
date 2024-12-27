//
//  ExerciseDetailsViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.05.2024.
//

import Foundation
import Factory
import Combine
import SwiftUI
import Models
import Storage
import Utility
import DataRepository
import Components

@Observable
@MainActor
final class ExerciseDetailsViewModel {

  @ObservationIgnored
  @Injected(\StorageContainer.userManager) private var userManager: UserSessionManagerProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.ratingRepository) private var ratingRepository: RatingRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseSessionRepository) private var exerciseSessionRepository: ExerciseSessionRepository

  // MARK: - Observed properties

  private(set) var showChallengeExercise = false
  private(set) var isTimerActive = false
  private(set) var elapsedTime: Int = 0

  var showInputDialog = false
  var showRatingDialog = false
  var showXPGainDialog = false
  var currentUserExperienceEntry: UserExperienceEntry?
  var userRating = 0
  var exerciseRatings: [ExerciseRating] = []
  var inputWeight: Double = 0

  var toastPublisher: AnyPublisher<Toast, Never> {
    return toastSubject
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
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
    return exercise.isFavorite ?? false
  }

  private let toastSubject = PassthroughSubject<Toast, Never>()

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

      if let currentUserID = userManager.currentUserID, let userRating = exerciseRatings.first(where: { $0.userID == currentUserID })?.rating {
        self.userRating = Int(userRating)
      }
    } catch {
      showErrorToast()
      Logger.error(error, message: "Could not load exercise ratings")
    }
  }

  private func showErrorToast() {
    toastSubject.send(Toast(style: .error, message: "Oops! Something went wrong..."))
  }

  func saveRating(_ rating: Int) {
    showRatingDialog = false

    saveRatingTask = Task { [weak self] in
      guard let self else { return }

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
      guard let self else { return }

      do {
        try await exerciseRepository.setFavoriteExercise(exercise, isFavorite: !isFavorite)
        await loadExerciseDetails()
      } catch {
        Logger.error(error, message: "Could not update exercise.isFavorite")
      }
    }
  }

  func saveExerciseSession() {
    saveExerciseSessionTask = Task { [weak self] in
      guard let self else { return }
      do {
        let userExperience = try await exerciseSessionRepository.addSession(exercise, dateAdded: Date(), duration: Double(self.elapsedTime), weight: inputWeight)
        await showUserExperience(userExperience)

        try await maybeUpdateGoals()
      } catch {
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
      } while (!Task.isCancelled && isTimerActive)
    }
  }

  func stopTimer() {
    isTimerActive = false
    timerTask?.cancel()

    saveExerciseSession()
  }

  // TODO: Use progress entry to update the goal
  private func maybeUpdateGoals() async throws {
    //    let goals = await goalDataStore.getAll()
    //
    //    for goal in goals {
    //      if let _ = ExerciseConstants.goalToExerciseCategories[goal.category] {
    //        try await goalDataStore.incrementCurrentValue(goal)
    //      }
    //    }
  }

  // MARK: - Clean up

  func cleanUp() {
    markFavoriteTask?.cancel()
    saveExerciseSessionTask?.cancel()
    saveRatingTask?.cancel()
    timerTask?.cancel()
  }
}
