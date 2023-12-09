//
//  UserDefaultsWrapper.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation

public class UserDefaultsWrapper: NSObject {
  private static var sharedWrapper: UserDefaultsWrapper = {
    return UserDefaultsWrapper()
  }()

  class var shared: UserDefaultsWrapper {
    get {
      return self.sharedWrapper
    }
    set {
      self.sharedWrapper = newValue
    }
  }

  private let userDefaults: UserDefaults

  private let IS_AUTHENTICATED = "authenticated"
  var isAuthenticated: Bool {
    get {
      return self.userDefaults.bool(forKey: IS_AUTHENTICATED)
    }
    set {
      self.userDefaults.setValue(newValue, forKey: IS_AUTHENTICATED)
    }
  }

  private override init() {
    self.userDefaults = UserDefaults.standard
  }
}
