//
//  ChallengeExerciseView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.10.2023.
//

import SwiftUI

enum TimerType {
  case active, rest, completed
}

struct ChallengeExerciseView: View {
  let challengeExercise: ChallengeExercise
  let onClose: (_: Bool) -> Void
  
  @State private var currentRound = 0
  @State private var timerType: TimerType = .active
  
  var body: some View {
    VStack {
      topSection
      bodySection
      Spacer()
    }
    .navigationBarBackButtonHidden()
    .toolbar(.hidden, for: .tabBar)
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var backButton: some View {
    Button(action: {
      onClose(timerType == .completed)
    }, label: {
      Image(systemName: "chevron.left")
        .resizable()
        .bold()
        .frame(width: 15, height: 20)
        .foregroundStyle(.white)
    })
  }
  
  @ViewBuilder
  private var topSection: some View {
    Rectangle()
      .ignoresSafeArea()
      .frame(height: 200)
      .foregroundStyle(Color.appColor(with: .navyBlue))
      .overlay {
        ZStack {
          VStack {
            /// if it's completed we'll show the `Get reward` button so no need for the back button
            if timerType != .completed {
              HStack {
                backButton
                  .padding(15)
                Spacer()
              }
            }
            Spacer()
          }
          Image(challengeExercise.image)
            .resizable()
            .scaledToFit()
        }
      }
  }
  
  @ViewBuilder
  private var bodySection: some View {
    VStack(alignment: .center, spacing: 10) {
      if self.isExerciseComplete {
        CongratulationView(challengeExercise: challengeExercise, onGetReward: {
          onClose(true)
        })
      } else {
        Text(challengeExercise.name)
          .foregroundStyle(.black)
          .font(.title)
          .bold()
          .padding(.top)
        Text(subtitleText)
          .foregroundStyle(.gray)
          .font(.callout)
        if let instructions = challengeExercise.instructions {
          Text(instructions)
            .foregroundStyle(.gray)
            .font(.callout)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .padding([.leading, .trailing], 10)
        }

        circleView
          .padding(.top)
      }
    }
    .padding([.leading, .trailing], 10)
  }
  
  @ViewBuilder
  private var circleView: some View {
    if timerType == TimerType.active {
      CircleTimerView(durationInSeconds: challengeExercise.duration, subtitle: "min", color: Color.appColor(with: .navyBlue), onTimerCompleted: handleNextTimer)
      .id(UUID())
    } else if timerType == TimerType.rest {
      CircleTimerView(durationInSeconds: challengeExercise.restDuration, subtitle: "rest", color: .gray, onTimerCompleted: handleNextTimer)
      .id(UUID())
    }
  }
  
  // MARK: - Helpers and computed properties
  
  /// e.g. `Round 1/3 | 30 sec rest`
  private var subtitleText: String {
    return "Round \(currentRound)/\(challengeExercise.rounds) | \(challengeExercise.restDuration) sec rest"
  }
  
  private var isExerciseComplete: Bool {
    return timerType == .completed
  }
  
  private func handleNextTimer() {
    if timerType == .active {
      currentRound += 1
      timerType = .rest
      
      if currentRound >= challengeExercise.rounds {
        timerType = .completed
      }
    } else {
      timerType = .active
    }
  }
}

#Preview {
  ChallengeExerciseView(challengeExercise: MockConstants.challengeExercise, onClose: {_ in })
}
