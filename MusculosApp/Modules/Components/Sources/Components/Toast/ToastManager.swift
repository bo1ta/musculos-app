//
//  ToastManager.swift
//  Components
//
//  Created by Solomon Alexandru on 01.01.2025.
//

import Combine
import SwiftUI
import Utility

// MARK: - ToastManagerProtocol

public protocol ToastManagerProtocol {
  var toastPublisher: AnyPublisher<Toast?, Never> { get }

  func show(_ toast: Toast, autoDismissAfter seconds: TimeInterval)
}

extension ToastManagerProtocol {
  private static var standardDuration: TimeInterval { UIConstant.toastStandardDuration }

  public func showInfo(_ message: String) {
    show(.info(message), autoDismissAfter: Self.standardDuration)
  }

  public func showWarning(_ message: String) {
    show(.warning(message), autoDismissAfter: Self.standardDuration)
  }

  public func showSuccess(_ message: String) {
    show(.success(message), autoDismissAfter: Self.standardDuration)
  }

  public func showError(_ message: String) {
    show(.error(message), autoDismissAfter: Self.standardDuration)
  }
}

// MARK: - ToastManager

public class ToastManager: @unchecked Sendable, ToastManagerProtocol {
  private let toastSubject = CurrentValueSubject<Toast?, Never>(nil)

  public var toastPublisher: AnyPublisher<Toast?, Never> {
    toastSubject
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  public init() { }

  public func show(_ toast: Toast, autoDismissAfter seconds: TimeInterval = UIConstant.toastStandardDuration) {
    toastSubject.send(toast)
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
      self?.toastSubject.send(nil)
    }
  }
}
