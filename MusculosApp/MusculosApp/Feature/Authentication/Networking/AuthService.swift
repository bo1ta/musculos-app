//
//  AuthService.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation

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
    
    try await saveCurrentUser(authResult: result, email: email, fullName: fullName, username: username)
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
  
  private func saveCurrentUser(authResult: AuthenticationResult, email: String, fullName: String? = nil, username: String? = nil) async throws {
    guard authResult.token.count > 0 else { throw MusculosError.forbidden }
    
    if let fullName, let username {
      let person = User(email: email, fullName: fullName, username: username)
      try await dataStore.createUser(person: person)
    }
    UserDefaults.standard.setValue(authResult.token, forKey: UserDefaultsKeyConstant.authToken.rawValue)
  }
}
