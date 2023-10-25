//
//  Person.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.10.2023.
//

import Foundation

struct Person {
  let avatar: String
  let name: String
  
  init(avatar: String, name: String) {
    self.avatar = avatar
    self.name = name
  }
  
  var avatarUrl: URL? {
    return URL(string: avatar)
  }
}

extension Person: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(avatar)
    hasher.combine(name)
  }
}
