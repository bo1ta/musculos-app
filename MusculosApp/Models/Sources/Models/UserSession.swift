//
//  AuthToken.swift
//  
//
//  Created by Solomon Alexandru on 08.09.2024.
//

import Utility
import Foundation

public struct UserSession: Sendable, Codable, DecodableModel {
  public var token: Token
  public var user: User

  public init(token: Token, user: User) {
    self.token = token
    self.user = user
  }

  public struct Token: Codable, Sendable {
    public var createdAt: String?
    public var expiresAt: String?
    public var value: String
  }

  public struct User: Codable, Sendable {
    public var id: UUID
  }
}
