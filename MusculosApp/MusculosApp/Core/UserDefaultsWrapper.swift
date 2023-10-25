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

    private let tokenKey = "AuthToken"
    var authToken: String? {
        get {
            return self.userDefaults.string(forKey: self.tokenKey)
        }
        set {
            self.userDefaults.set(newValue, forKey: self.tokenKey)
        }
    }

    private override init() {
        self.userDefaults = UserDefaults.standard
    }
}
