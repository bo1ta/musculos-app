//
//  ToastManager.swift
//  Components
//
//  Created by Solomon Alexandru on 01.01.2025.
//

import Combine
import SwiftUI
import Utility

public class ToastManager: @unchecked Sendable {
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

  public func showInfo(_ message: String) {
    show(.info(message))
  }

  public func showWarning(_ message: String) {
    show(.warning(message))
  }

  public func showSuccess(_ message: String) {
    show(.success(message))
  }

  public func showError(_ message: String) {
    show(.error(message))
  }
}
