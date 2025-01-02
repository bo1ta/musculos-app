//
//  MockToastManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Combine
import Foundation
import XCTest

@testable import Components

class MockToastManager: ToastManagerProtocol {
  var showExpectation: XCTestExpectation?

  var toastPublisher: AnyPublisher<Toast?, Never> {
    toastSubject.eraseToAnyPublisher()
  }

  private let toastSubject = CurrentValueSubject<Toast?, Never>(nil)

  func show(_: Components.Toast, autoDismissAfter _: TimeInterval) {
    showExpectation?.fulfill()
  }
}
