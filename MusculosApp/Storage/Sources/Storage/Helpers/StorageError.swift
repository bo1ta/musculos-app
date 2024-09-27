//
//  StorageError.swift
//  Storage
//
//  Created by Solomon Alexandru on 27.09.2024.
//

import Foundation

public enum StorageError: Error {
  case invalidUser
  case syncingFailed(String)
}
