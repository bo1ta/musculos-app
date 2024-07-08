//
//  PersonFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation

struct PersonFactory {
  static func createPerson(email: String = "test@test.com", username: String =  "test_user") -> User {
    return User(email: email, username: username)
  }
}
