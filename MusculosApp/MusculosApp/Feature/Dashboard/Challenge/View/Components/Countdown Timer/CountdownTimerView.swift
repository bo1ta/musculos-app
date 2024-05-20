//
//  CountdownTimerView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.10.2023.
//

import SwiftUI
import Combine

struct CountdownTimerView: View {
  @StateObject var viewModel: CountdownTimerViewModel
  @Binding var durationInSeconds: Int

  private let subtitle: String
  private var color: Color
  private var onTimerCompleted: () -> Void
    
  init(
    durationInSeconds: Binding<Int>,
    subtitle: String = "min",
    color: Color = Color.AppColor.green500,
    onTimerCompleted: @escaping () -> Void
  ) {
    self._durationInSeconds = durationInSeconds
    self._viewModel = .init(
      wrappedValue: CountdownTimerViewModel(timeDuration: Double(durationInSeconds.wrappedValue))
    )
    self.subtitle = subtitle
    self.color = color
    self.onTimerCompleted = onTimerCompleted
  }
  
  var body: some View {
    VStack {
      circleView
      pauseButton
    }
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var circleView: some View {
    innerCircle
      .overlay {
        animatingRing
      }
      .onAppear {
        guard !viewModel.isAnimating else { return }
        viewModel.initializeTimer()
      }
      .onChange(of: viewModel.isTimerComplete) { isComplete in
        if isComplete {
          viewModel.clearTimer()
          onTimerCompleted()
        }
      }
  }
  
  @ViewBuilder
  private var innerCircle: some View {
    ZStack {
      Circle()
        .fill(Color.gray.opacity(0.6))
        .foregroundStyle(.tertiary)
        .padding()
        .frame(width: 240, height: 240)

      Circle()
        .fill(Color(.white))
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
  }
  
  @ViewBuilder
  private var animatingRing: some View {
    ZStack {
      Circle()
        .trim(from: 0, to: viewModel.currentTrimValue)
        .stroke(lineWidth: 16)
        .foregroundColor(color)
        .frame(width: 190, height: 190)
        .rotationEffect(.degrees(-90))
      
      Circle()
        .trim(from: 0, to: viewModel.currentTrimValue)
        .stroke(lineWidth: 8)
        .foregroundColor(color)
        .frame(width: 200, height: 200)
        .rotationEffect(.degrees(-90))
    }
  }
  
  @ViewBuilder
  private var pauseButton: some View {
    let isPaused = viewModel.isPaused
    Button(action: {
      if isPaused {
        viewModel.resumeTimer()
      } else {
        viewModel.pauseTimer()
      }
    }, label: {
      Circle()
        .frame(width: 50)
        .foregroundStyle(Color.gray.opacity(0.9))
        .overlay {
          let buttonImage = isPaused ? "play" : "pause"
          Image(systemName: buttonImage)
            .foregroundStyle(.white)
        }
        .shadow(radius: 2)
    })
    .disabled(viewModel.isTimerComplete)
  }
}



struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    CountdownTimerView(durationInSeconds: .constant(120), onTimerCompleted: {})
      .preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
  }
}
