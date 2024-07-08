//
//  AsyncOperation.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2024.
//

import Foundation

public class AsyncOperation: Operation, @unchecked Sendable {
  public override var isAsynchronous: Bool {
    true
  }
  
  public override var isReady: Bool {
    super.isReady && self.state == .ready
  }
  
  public override var isExecuting: Bool {
    self.state == .executing
  }
  
  public override var isFinished: Bool {
    self.state == .finished
  }
  
  override open func start() {
    if isCancelled {
      state = .finished
      return
    }
    main()
    state = .executing
  }
  
  override open func cancel() {
    super.cancel()
    state = .finished
  }
  
  // MARK: Public
  
  public enum State: String {
    case ready
    case executing
    case finished
    
    // MARK: Fileprivate
    
    fileprivate var keyPath: String {
      "is" + rawValue.capitalized
    }
  }
  
  public var state = State.ready {
    willSet {
      willChangeValue(forKey: newValue.keyPath)
      willChangeValue(forKey: state.keyPath)
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: state.keyPath)
    }
  }
}
