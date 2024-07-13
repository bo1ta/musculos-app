//
//  AuthService.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import Utility
import Models
import Storage

protocol AuthServiceProtocol: Sendable {
  var dataStore: UserDataStoreProtocol { get set }
  func register(email: String, password: String, username: String, fullName: String) async throws
  func login(email: String, password: String) async throws
}

struct AuthService: MusculosService {
  var client: MusculosClientProtocol
  var dataStore: UserDataStoreProtocol
  
  init(client: MusculosClientProtocol = MusculosClient(),
       dataStore: UserDataStoreProtocol = UserDataStore()) {
    self.client = client
    self.dataStore = dataStore
  }
}

extension AuthService: AuthServiceProtocol {
  func register(email: String, password: String, username: String, fullName: String) async throws {
    var body = [
      "email": email,
      "password": password,
      "username": username
    ]
    if fullName.count > 0 {
      body["fullName"] = fullName
    }
    
    let request = APIRequest(method: .post, path: .register, body: body)
    let data = try await client.dispatch(request)
    let result = try AuthenticationResult.createFrom(data)
    
    try await saveCurrentUser(authResult: result, email: email, fullName: fullName, username: username, isOnboarded: false)
  }
  
  func login(email: String, password: String) async throws {
    let body = ["email": email, "password": password]
    
    let request = APIRequest(method: .post, path: .login, body: body)
    let data = try await client.dispatch(request)
    let result = try AuthenticationResult.createFrom(data)
    
    try await saveCurrentUser(authResult: result, email: email)
  }
}

// MARK: - Authentication Result helper
//
extension AuthService {
  struct AuthenticationResult: Codable, DecodableModel {
    var token: String
  }
  
  @UserSessionActor
  private func saveCurrentUser(authResult: AuthenticationResult, email: String, fullName: String? = nil, username: String? = nil, isOnboarded: Bool = false) async throws {
    
    let token = authResult.token
    guard token.count > 0 else { throw MusculosError.forbidden }
    
    
    if let _ = await UserSessionActor.shared.currentUser() {
      await UserSessionActor.shared.updateSession(token: token, isOnboarded: isOnboarded)
    } else {
      let userSession = UserSession(authToken: token, userId: UUID(), email: email, isOnboarded: false)
      await UserSessionActor.shared.createSession(from: userSession)
    }
    
    let userId = await UserSessionActor.shared.currentUser()?.userId
    
    if let fullName, let username, let userId {
      let person = UserProfile(userId: userId, email: email, fullName: fullName, username: username)
      try await dataStore.createUser(person: person)
    }
  }
}
