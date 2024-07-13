//
//  PersonFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation

public struct UserProfileFactory {
  public static func createProfile(userId: UUID = UUID(), email: String = "test@test.com", username: String =  "test_user") -> UserProfile {
    return UserProfile(userId: userId, email: email, username: username)
  }
}
