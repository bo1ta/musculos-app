//
//  CircleTimerViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.10.2023.
//

import Foundation
import Combine

class CircleTimerViewModel: ObservableObject {
  private var timerSubscription: Cancellable?
  private var timerCancellable: AnyCancellable?
    
  @Published var currentTime: TimeInterval
  @Published var isAnimating: Bool = false
  
  let timer = Timer.publish(every: 1, on: .main, in: .common)
  
  init(timeDuration: TimeInterval) {
    self.currentTime = timeDuration
  }
  
  var isWorkoutComplete: Bool {
    return currentTime == 0
  }
  
  var formattedCurrentTime: String {
    let minutes = Int(currentTime) / 60
    let seconds = Int(currentTime) % 60
    return String(format: "%d:%02d", minutes, seconds)
  }
  
  func startTimer(workoutDuration: TimeInterval) {
    isAnimating = true
    timerSubscription = timer.autoconnect().sink(receiveValue: { [weak self] _ in
      self?.currentTime -= 1
    })
  }
  
  func stopTimer() {
    isAnimating = false
    timerSubscription?.cancel()
    timerCancellable = nil
  }
}

