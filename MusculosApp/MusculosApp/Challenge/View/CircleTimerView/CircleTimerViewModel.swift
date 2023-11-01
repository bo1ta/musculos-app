//
//  CircleTimerViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.10.2023.
//

import Foundation
import Combine
import SwiftUI

class CircleTimerViewModel: ObservableObject {
  private var timerSubscription: Cancellable?
  private var timerCancellable: AnyCancellable?
  private var totalDuration: Double
  
  @Published var isAnimating: Bool = false
  @Published var isPaused: Bool = true
    
  @Published var currentTime: TimeInterval
  @Published var rotationAngle: Angle = .degrees(360)
  
  let timer = Timer.publish(every: 1, on: .main, in: .common)
  
  init(timeDuration: TimeInterval) {
    self.currentTime = timeDuration
    self.totalDuration = Double(timeDuration)
  }
  
  var isWorkoutComplete: Bool {
    return currentTime == 0
  }
  
  var formattedCurrentTime: String {
    let minutes = Int(currentTime) / 60
    let seconds = Int(currentTime) % 60
    return String(format: "%d:%02d", minutes, seconds)
  }
  
  private var currentRotationAngle: Double {
    let angle = (1 - (currentTime / totalDuration)) * 360
    return angle
  }
  
  func startTimer(workoutDuration: TimeInterval) {
    isAnimating = isPaused ? false : true
    timerSubscription = timer.autoconnect().sink(receiveValue: { [weak self] _ in
      guard let isPaused = self?.isPaused else { return }
      if isPaused {
        self?.isAnimating = false
      } else {
        self?.currentTime -= 1
      }
    })
  }
  
  func pauseTimer() {
    isAnimating = false
    isPaused = true
    rotationAngle = Angle(degrees: currentRotationAngle)
  }
  
  func resumeTimer() {
    isAnimating = true
    isPaused = false
  }
  
  func stopTimer() {
    isAnimating = false
    timerSubscription?.cancel()
    timerCancellable = nil
  }
}

