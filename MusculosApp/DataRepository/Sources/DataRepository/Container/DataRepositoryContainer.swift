//
//  DataRepositoryContainer.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 18.10.2024.
//

import Factory
import Foundation

public final class DataRepositoryContainer: SharedContainer {
  nonisolated(unsafe) public static let shared = DataRepositoryContainer()

  public var manager = ContainerManager()
}

extension DataRepositoryContainer {
  public var userRepository: Factory<UserRepository> {
    self { UserRepository() }
  }

  public var exerciseRepository: Factory<ExerciseRepository> {
    self { ExerciseRepository() }
  }
}
