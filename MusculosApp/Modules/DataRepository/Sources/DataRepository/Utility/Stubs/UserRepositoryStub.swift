//
//  File.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Foundation
import Models
import Storage
import Utility

public struct UserRepositoryStub: UserRepositoryProtocol {
  let expectedSession: UserSession?
  let expectedProfile: UserProfile?
  let shouldFail: Bool

  public init(
    expectedSession: UserSession? = nil,
    expectedProfile: UserProfile? = nil,
    shouldFail: Bool = false)
  {
    self.expectedSession = expectedSession
    self.expectedProfile = expectedProfile
    self.shouldFail = shouldFail
  }

  public func register(email _: String, password _: String, username _: String) async throws -> UserSession {
    if let expectedSession {
      return expectedSession
    }
    throw MusculosError.unexpectedNil
  }

  public func login(email _: String, password _: String) async throws -> UserSession {
    if let expectedSession {
      return expectedSession
    }
    throw MusculosError.unexpectedNil
  }

  public func getCurrentUser() async throws -> UserProfile? {
    expectedProfile
  }

  public func getUserByID(_: UUID) async -> UserProfile? {
    expectedProfile
  }

  public func updateProfileUsingOnboardingData(_: Models.OnboardingData) async throws { }

  public func observeUserChanges(forUserID userID: UUID) -> EntityPublisher<UserProfileEntity> {
    StorageContainer.shared.coreDataStore().userPublisherForID(userID)
  }
}
