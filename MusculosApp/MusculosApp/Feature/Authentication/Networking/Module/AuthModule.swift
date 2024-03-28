//
//  AuthModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation

final class AuthModule: MusculosModule {
  var client: MusculosClientProtocol
  
  init(client: MusculosClientProtocol = MusculosClient()) {
    self.client = client
  }
}

extension AuthModule: Authenticatable {
  func register(email: String, password: String, username: String, fullName: String) async throws -> String {
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
    return result.token
  }
  
  func login(email: String, password: String) async throws -> String {
    let body = ["email": email, "password": password]
    let request = APIRequest(method: .post, path: .login, body: body)
    
    let data = try await client.dispatch(request)
    let result = try AuthenticationResult.createFrom(data)
    return result.token
  }
}

extension AuthModule {
  struct AuthenticationResult: Codable, DecodableModel {
    var token: String
  }
}
