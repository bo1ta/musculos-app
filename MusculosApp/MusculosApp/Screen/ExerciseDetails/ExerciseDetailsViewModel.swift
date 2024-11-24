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

  var isFavorite = false
  var showInputDialog = false
  var showRatingDialog = false
  var inputWeight: Double? = nil
  var userRating = 0
  var exerciseRatings: [ExerciseRating] = []

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
    async let userRatingTask: Void = loadUserRating()
    async let exerciseRatingsTask: Void = loadExerciseRatings()

    let (_, _, _) = await (exerciseDetailsTask, userRatingTask, exerciseRatingsTask)
  }

  private func loadExerciseDetails() async {
    do {
      exercise = try await exerciseRepository.getExerciseDetails(for: exercise.id)
    } catch {
      showErrorToast()
      MusculosLogger.logError(error, message: "Cannot load exercise details", category: .dataRepository)
    }
  }

  private func loadUserRating() async {
    do {
      userRating = Int(try await ratingRepository.getUserRatingForExercise(exercise.id))
    } catch {
      showErrorToast()
      MusculosLogger.logError(error, message: "Could not load user rating", category: .dataRepository)
    }
  }

  private func loadExerciseRatings() async {
    do {
      exerciseRatings = try await ratingRepository.getRatingsForExercise(exercise.id)
    } catch {
      showErrorToast()
      MusculosLogger.logError(error, message: "Could not load exercise ratings", category: .dataRepository)
    }
  }

  private func showErrorToast() {
    toastSubject.send(Toast(style: .error, message: "Oops! Something went wrong..."))
  }

  func saveRating(_ rating: Int) {
    saveRatingTask = Task { [weak self] in
      guard let self else { return }

      do {
        try await ratingRepository.addRating(rating: Double(rating), for: exercise.id)
        showRatingDialog = false
      } catch {
        MusculosLogger.logError(error, message: "Could not save rating", category: .dataRepository)
      }
    }
  }

  func handleDialogInput(_ input: String) {
    guard let inputWeight = Double(input) else { return }
    self.inputWeight = inputWeight
    startTimer()
  }

  func updateFavorite(_ isFavorite: Bool) {
    markFavoriteTask?.cancel()

    markFavoriteTask = Task { [weak self] in
      guard let self else { return }

      do {
        // short debounce
        try await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }

        try await exerciseRepository.setFavoriteExercise(exercise, isFavorite: self.isFavorite)

      } catch {
        self.isFavorite = !isFavorite
        MusculosLogger.logError(error, message: "Could not update exercise.isFavorite", category: .coreData)
      }
    }
  }

  func saveExerciseSession() {
    saveExerciseSessionTask = Task { [weak self] in
      guard let self else { return }
      do {
        try await exerciseSessionRepository.addSession(exercise, dateAdded: Date(), duration: Double(self.elapsedTime), weight: inputWeight ?? 0)
        try await maybeUpdateGoals()
      } catch {
        MusculosLogger.logError(error, message: "Could not save exercise session", category: .coreData)
      }
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
