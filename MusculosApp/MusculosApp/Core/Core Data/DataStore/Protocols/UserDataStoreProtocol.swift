//
//  UserDataStoreProtocol.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.05.2024.
//

import Foundation

protocol UserDataStoreProtocol {
  func createUser(person: Person) async
  func updateUser(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) async
}
