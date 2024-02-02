//
//  UserDefaultsWrapper.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation

public class UserDefaultsWrapper: NSObject {
  private override init() {
    self.userDefaults = UserDefaults.standard
  }
  
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
  
  func setBool(value: Bool, key: UserDefaultsKey) {
    userDefaults.setValue(value, forKey: key.rawValue)
  }
  
  func getBool(_ key: UserDefaultsKey) -> Bool {
    userDefaults.bool(forKey: key.rawValue)
  }
}
