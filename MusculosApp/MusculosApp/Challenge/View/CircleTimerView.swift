//
//  CircleTimerView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.10.2023.
//

import SwiftUI
import Combine

struct CircleTimerView: View {
  @ObservedObject var viewModel: CircleTimerViewModel
  
  private let durationInSeconds: UInt
  private let subtitle: String
  private var color: Color
  private var onTimerCompleted: () -> Void
  
  init(durationInSeconds: Int, subtitle: String = "min", color: Color = Color.appColor(with: .grassGreen), onTimerCompleted: @escaping () -> Void) {
    self.durationInSeconds = UInt(durationInSeconds)
    self.subtitle = subtitle
    self.viewModel = CircleTimerViewModel(timeDuration: Double(durationInSeconds))
    self.color = color
    self.onTimerCompleted = onTimerCompleted
  }
  
  private var animation: Animation {
    Animation
      .linear(duration: Double(durationInSeconds))
      .repeatForever(autoreverses: false)
  }
  
  var body: some View {
    ZStack {
      Circle()
        .fill(
          Color.gray.opacity(0.6)
        )
        .foregroundStyle(.tertiary)
        .padding()
        .frame(width: 240, height: 240)
      
      Circle()
        .fill(
          Color(.white)
        )
        .padding()
        .frame(width: 220, height: 220)
      
      VStack(spacing: 0) {
        Text(viewModel.formattedCurrentTime)
          .font(.largeTitle)
          .fontWeight(.black)
          .foregroundStyle(color)
        Text(subtitle)
          .font(.title)
          .foregroundStyle(.gray)
          .opacity(0.6)
      }
      
    }
    .overlay {
      ZStack {
        Circle()
          .trim(from: 0, to: viewModel.isAnimating ? .leastNormalMagnitude : 1)
          .stroke(lineWidth: 16)
          .foregroundColor(color.opacity(0.5))
          .frame(width: 190, height: 190)
          .rotationEffect(.degrees(-90))
        
        Circle()
          .trim(from: 0, to: viewModel.isAnimating ? .leastNormalMagnitude : 1)
          .stroke(lineWidth: 8)
          .foregroundColor(color)
          .frame(width: 200, height: 200)
          .rotationEffect(.degrees(-90))
      }
      .overlay {
        ZStack {
          Circle()
            .frame(width: 4, height: 4)
            .foregroundColor(color)
        }
        .rotationEffect(Angle(degrees: 90))
        .rotationEffect(Angle(degrees: viewModel.isAnimating ? 0 : 360))
      }
    }
    .onAppear {
      DispatchQueue.main.async {
        withAnimation(animation) {
          if !viewModel.isAnimating {
            viewModel.startTimer(workoutDuration: Double(durationInSeconds))
          }
        }
      }
    }
    .onChange(of: viewModel.isWorkoutComplete) { isComplete in
      if isComplete {
        viewModel.stopTimer()
        onTimerCompleted()
      }
    }
  }
}



struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    CircleTimerView(durationInSeconds: 120, onTimerCompleted: {})
      .preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
  }
}
