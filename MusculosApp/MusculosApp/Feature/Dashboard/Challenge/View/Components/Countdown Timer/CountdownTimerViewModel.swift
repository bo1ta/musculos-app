//
//  CircleTimerViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.10.2023.
//

import Foundation
import Combine
import SwiftUI

class CountdownTimerViewModel: ObservableObject {
  private var timerSubscription: Cancellable?
  private var timerCancellable: AnyCancellable?
  private var totalDuration: Double
  
  @Published var isAnimating: Bool = false
  @Published var isPaused: Bool = false
  @Published var currentTime: TimeInterval
  
  private let timer = Timer.publish(every: 1, on: .main, in: .common)
  
  init(timeDuration: TimeInterval) {
    self.currentTime = timeDuration
    self.totalDuration = Double(timeDuration)
  }
  
  // MARK: - Timer
  
  func initializeTimer() {
    isAnimating = isPaused ? false : true
    timerSubscription = timer.autoconnect().sink(receiveValue: { [weak self] _ in
      if self?.isPaused == true {
        self?.isAnimating = false
      } else {
        self?.currentTime -= 1
      }
    })
  }
  
  func pauseTimer() {
    isAnimating = false
    isPaused = true
  }
  
  func resumeTimer() {
    isAnimating = true
    isPaused = false
  }
  
  func clearTimer() {
    isAnimating = false
    timerSubscription?.cancel()
    timerCancellable = nil
  }
  
  // MARK: - Computed properties
  
  var isTimerComplete: Bool {
    currentTime == 0
  }
  
  var formattedCurrentTime: String {
    let minutes = Int(currentTime) / 60
    let seconds = Int(currentTime) % 60
    return String(format: "%d:%02d", minutes, seconds)
  }

  var currentTrimValue: CGFloat {
    1 - CGFloat(1 - (currentTime / totalDuration))
  }
}

