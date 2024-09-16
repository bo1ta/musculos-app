//
//  AuthToken.swift
//  
//
//  Created by Solomon Alexandru on 08.09.2024.
//

import Utility
import Foundation

public struct UserSession: Codable, DecodableModel {
  public var token: Token
  public var user: User

  public init(token: Token, user: User) {
    self.token = token
    self.user = user
  }

  public struct Token: Codable {
    public var createdAt: String?
    public var expiresAt: String?
    public var value: String
  }

  public struct User: Codable {
    public var username: String
    public var email: String
    public var id: UUID?
    public var isOnboarded: Bool?
    public var weight: Double?
    public var height: Double?
    public var level: String?
    public var primaryGoal: String?

    public init(username: String, email: String, id: UUID? = nil, isOnboarded: Bool = false) {
      self.username = username
      self.email = email
      self.id = id
      self.isOnboarded = isOnboarded
    }

    public mutating func setIsOnboarded(_ isOnboarded: Bool) {
      self.isOnboarded = isOnboarded
    }
  }
}
