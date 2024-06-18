//
//  Person.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.10.2023.
//

import Foundation

struct Person: Codable {
  var uuid = UUID()
  let avatar: String?
  let fullName: String?
  let username: String
  let email: String

  init(email: String, fullName: String? = nil, username: String, avatar: String? = nil) {
    self.email = email
    self.fullName = fullName
    self.username = username
    self.avatar = avatar
  }

  var avatarUrl: URL? {
    guard let avatar else { return nil }
    return URL(string: avatar)
  }
}

extension Person: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(avatar)
    hasher.combine(fullName)
    hasher.combine(username)
    hasher.combine(email)
  }
}
