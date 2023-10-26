//
//  ChallengeExerciseView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.10.2023.
//

import SwiftUI

struct ChallengeExerciseView: View {
  let challengeExercise: ChallengeExercise
  
  @State private var currentRound = 1
  
  var body: some View {
    VStack {
      topSection
      bodySection
      Spacer()
    }
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var backButton: some View {
    Button {
      // do something
    } label: {
      Image(systemName: "chevron.left")
        .resizable()
        .bold()
        .frame(width: 15, height: 20)
        .foregroundStyle(.white)
    }
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
            HStack {
              backButton
                .padding(15)
              Spacer()
            }
            Spacer()
          }
          Image("wall-sit")
            .resizable()
            .scaledToFit()
        }
      }
  }
  
  @ViewBuilder
  private var bodySection: some View {
    VStack(alignment: .center) {
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
          .padding(.top)
          .foregroundStyle(.gray)
          .font(.callout)
          .padding([.leading, .trailing], 4)
      }
      
      CircleTimerView(durationInSeconds: challengeExercise.duration)
    }
    .padding([.leading, .trailing], 10)
  }
  
  /// e.g. `Round 1/3 | 30 sec rest`
  private var subtitleText: String {
    return "Round \(currentRound)/\(challengeExercise.rounds) | \(challengeExercise.restDuration) sec rest"
  }
  
}

fileprivate let mockExercise = ChallengeExercise(name: "Wall sit", instructions: "Sit down with your back against the wall as if there was a chair, and hold the position", rounds: 3, duration: 30, restDuration: 30)

#Preview {
  ChallengeExerciseView(challengeExercise: mockExercise)
}
