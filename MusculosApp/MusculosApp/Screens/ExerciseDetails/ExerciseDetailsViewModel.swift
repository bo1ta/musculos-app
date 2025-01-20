//
//  ExerciseDetailsViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.05.2024.
//

import Combine
import DataRepository
import Factory
import Foundation
import Models
import Storage
import SwiftUI
import Utility

@Observable
@MainActor
final class ExerciseDetailsViewModel: BaseViewModel {

  // MARK: Dependencies

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepositoryProtocol

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.ratingRepository) private var ratingRepository: RatingRepositoryProtocol

  private let exerciseSessionHandler: ExerciseSessionHandler
  private let entityPublisher: EntityPublisher<ExerciseEntity>

  // MARK: Properties

  private var cancellables: Set<AnyCancellable> = []
  private(set) var markFavoriteTask: Task<Void, Never>?
  private(set) var saveRatingTask: Task<Void, Never>?

  private(set) var elapsedTime = 0
  private(set) var currentXPGain = 0
  private(set) var exerciseRatings: [ExerciseRating] = []
  private(set) var currentUserExperienceEntry: UserExperienceEntry?

  var showInputDialog = false
  var showRatingDialog = false
  var showXPGainDialog = false
  var userRating = 0

  var inputWeight: Double = 0

  var ratingAverage: Double {
    guard !exerciseRatings.isEmpty else {
      return 0.0
    }
    return exerciseRatings.reduce(0) { $0 + $1.rating } / Double(exerciseRatings.count)
  }

  var isTimerActive: Bool {
    exerciseSessionHandler.isTimerActive
  }

  var isFavorite: Bool {
    exercise.isFavorite ?? false
  }

  // MARK: Init and Setup

  var exercise: Exercise

  init(exercise: Exercise) {
    self.exercise = exercise
    self.exerciseSessionHandler = ExerciseSessionHandler(exercise: exercise)
    self.entityPublisher = StorageContainer.shared.coreDataStore().exercisePublisherForID(exercise.id)

    setupPublishers()
  }

  private func setupPublishers() {
    entityPublisher
      .publisher
      .sink { [weak self] exercise in
        self?.exercise = exercise
      }
      .store(in: &cancellables)

    exerciseSessionHandler.eventPublisher
      .sink { [weak self] event in
        self?.handleSessionEvent(event)
      }
      .store(in: &cancellables)
  }

  private func handleSessionEvent(_ event: ExerciseSessionHandler.Event) {
    switch event {
    case .showXP(let userExperienceEntry):
      showUserExperience(userExperienceEntry)
    case .didReceiveError:
      showGenericErrorToast()
    case .timerDidChange(let elapsedTime):
      self.elapsedTime = elapsedTime
    case .timerDidReset:
      elapsedTime = 0
    }
  }

  // MARK: - Public methods

  func initialLoad() async {
    do {
      exerciseRatings = try await ratingRepository.getRatingsForExercise(exercise.id)

      guard
        let currentUserID = currentUser?.id,
        let userRating = exerciseRatings.last(where: { $0.userID == currentUserID })?.rating
      else {
        return
      }
      self.userRating = Int(userRating)

    } catch {
      showGenericErrorToast()
      Logger.error(error, message: "Could not load exercise ratings")
    }
  }

  func handleSubmit() {
    if exerciseSessionHandler.isTimerActive {
      exerciseSessionHandler.stopSession()
    } else {
      showInputDialog.toggle()
    }
  }

  func startSession() {
    guard let currentUser else {
      return
    }
    exerciseSessionHandler.startSession(forUser: currentUser, withInputWeight: inputWeight)
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

        playFavoriteExerciseActionSound()
      } catch {
        showGenericErrorToast()
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

  private func showUserExperience(_ userExperience: UserExperienceEntry) {
    Task { [weak self] in
      guard let self else {
        return
      }

      currentXPGain = userExperience.xpGained

      withAnimation {
        self.showXPGainDialog = true
      }

      try? await Task.sleep(for: .milliseconds(500))
      soundManager.playSound(.gainedExperience)

      try? await Task.sleep(for: .seconds(2))

      withAnimation {
        self.showXPGainDialog = false
      }
    }
  }

  func cancelAllTasks() {
    markFavoriteTask?.cancel()
    exerciseSessionHandler.cancelTasks()
  }
}
