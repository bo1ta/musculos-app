//
//  ProgressEntry+IdentifiableEntity.swift
//  Storage
//
//  Created by Solomon Alexandru on 26.10.2024.
//

import Foundation
import Models

extension ProgressEntry: IdentifiableEntity {
  public static let identifierKey: String = "progressID"

  public var identifierValue: UUID {
    progressID
  }
}
