//
//  HomeViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.09.2024.
//

import Observation
import Models
import Utility
import Factory
import DataRepository
import Storage
import Combine
import Foundation

@Observable
@MainActor
final class HomeViewModel {

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.exerciseRepository) private var exerciseRepository: ExerciseRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepository

  private var cancellables = Set<AnyCancellable>()
  private(set) var isLoading = false
  private(set) var challenges: [Challenge] = []
  private(set) var goals: [Goal] = []
  private(set) var quickExercise: Exercise?
  private(set) var errorMessage: String?
  private(set) var notificationTask: Task<Void, Never>?

  private let coreNotificationHandler: CoreModelNotificationHandler

  init() {
    coreNotificationHandler = CoreModelNotificationHandler(storageType: StorageContainer.shared.storageManager().writerDerivedStorage)
    coreNotificationHandler.eventPublisher
      .debounce(for: .milliseconds(700), scheduler: DispatchQueue.main)
      .sink { [weak self] event in
        self?.handleNotificationEvent(event)
      }
      .store(in: &cancellables)
  }

  func onDisappear() {
    notificationTask?.cancel()
    notificationTask = nil
  }

  private func handleNotificationEvent(_ event: CoreModelNotificationHandler.Event) {
    notificationTask = Task {
      switch event {
      case .didUpdateGoal:
        await fetchGoals()
      default:
        break
      }
    }
  }

  func fetchData() async {
    isLoading = true
    defer { isLoading = false }

    async let goalsTask: Void = fetchGoals()
    async let exerciseTask: Void = fetchQuickExercise()

    let (_, _) = await (goalsTask, exerciseTask)
  }

  private func fetchGoals() async {
    do {
      goals = try await goalRepository.getGoals()
    } catch {
      MusculosLogger.logError(error, message: "Error loading goals for home view", category: .dataRepository)
    }
  }

  private func fetchQuickExercise() async {
    do {
      quickExercise = try await exerciseRepository.getExercisesByWorkoutGoal(.improveEndurance).first
    } catch {
      MusculosLogger.logError(error, message: "Error loading exercises for home view", category: .dataRepository)
    }
  }
}
