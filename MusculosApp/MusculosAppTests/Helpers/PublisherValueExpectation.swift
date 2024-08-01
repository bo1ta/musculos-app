//
//  PublisherValueExpectation.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.08.2024.
//

import XCTest
import Combine

public final class PublisherValueExpectation<P: Publisher>: XCTestExpectation {
  private var cancellable: AnyCancellable?

  public init(
    _ publisher: P,
    condition: @escaping (P.Output) -> Bool)
  {
    super.init(description: "Publisher expected to emit a value that matches the condition.")
    cancellable = publisher.sink { _ in
    } receiveValue: { [weak self] value in
      if condition(value) {
        self?.fulfill()
      }
    }
  }

  public convenience init(
      _ publisher: P,
      expectedValue: P.Output
  ) where P.Output: Equatable {
      let description = "Publisher expected to emit the value '\(expectedValue)'"
      self.init(publisher, condition: { $0 == expectedValue })
  }
}
