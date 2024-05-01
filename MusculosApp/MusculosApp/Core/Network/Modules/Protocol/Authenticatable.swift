//
//  Authenticatable.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Foundation

protocol Authenticatable {  
  var dataStore: UserDataStoreProtocol { get set }
  func register(email: String, password: String, username: String, fullName: String) async throws
  func login(email: String, password: String) async throws
}
