//
//  GoalStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.01.2025.
//

import Combine
import DataRepository
import Factory
import Foundation
import Models
import Storage

@Observable
final class GoalStore {
  private var cancellable: AnyCancellable?
  private(set) var goals: [Goal] = []
  private let entityPublisher: FetchedResultsPublisher<GoalEntity>

  init() {
    entityPublisher = DataRepositoryContainer.shared.goalRepository().goalsPublisher()

    setupPublisher()
  }

  private func setupPublisher() {
    cancellable = entityPublisher
      .publisher
      .sink { [weak self] event in
        switch event {
        case .didUpdateContent(let goals):
          self?.goals = goals
        default:
          break
        }
      }

    entityPublisher.performFetch()
  }
}
