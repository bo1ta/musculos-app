//
//  UserSession.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.07.2024.
//

import Foundation
import Utility

struct UserSession: Codable, DecodableModel {
  var authToken: String
  var userId: UUID
  var email: String
  var username: String?
  var isOnboarded: Bool
}

@globalActor actor UserSessionActor {
  static let shared = UserSessionActor()
  
  var _currentUser: UserSession?
  
  func currentUser() -> UserSession? {
    if let currentUser = _currentUser {
      return currentUser
    } else {
      
      guard
        let data = UserDefaults.standard.object(forKey: UserDefaultsKeyConstant.userSessionKey) as? Data,
        let userSession = try? UserSession.createFrom(data)
      else { return nil }
      
      _currentUser = userSession
      return userSession
    }
  }
  
  func createSession(from userSession: UserSession) {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(userSession) {
      UserDefaults.standard.set(data, forKey: UserDefaultsKeyConstant.userSessionKey)
    }
    
    _currentUser = userSession
  }
  
  func updateSession(token: String? = nil, isOnboarded: Bool? = nil) {
    let shouldEarlyReturn = token == nil && isOnboarded == nil
    if shouldEarlyReturn {
      return
    }
    
    guard var userCopy = _currentUser else { return }
    
    if let token = token {
      userCopy.authToken = token
    }
    
    if let isOnboarded = isOnboarded {
      userCopy.isOnboarded = isOnboarded
    }
    
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(userCopy) {
      UserDefaults.standard.set(data, forKey: UserDefaultsKeyConstant.userSessionKey)
    }
    
    _currentUser = userCopy
  }
}
