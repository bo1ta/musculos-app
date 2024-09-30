//
//  PersonFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation

public struct UserProfileFactory {
  public struct Default {
    public static let userId: UUID = UUID()
    public static let email: String = "test@test.com"
    public static let username: String =  "test_user"
  }

  public static func createProfile(
    userId: UUID = Default.userId,
    email: String = Default.email,
    username: String = Default.username
  ) -> UserProfile {
    return UserProfile(
      userId: userId,
      email: email,
      username: username
    )
  }
}
