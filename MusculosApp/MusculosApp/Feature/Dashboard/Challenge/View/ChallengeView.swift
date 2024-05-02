//
//  ChallengeView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.10.2023.
//

import SwiftUI

struct ChallengeView: View {
  let challenge: Challenge
  let onBack: () -> Void
  
  @State private var currentExercise: ChallengeExercise?
  @State private var currentExerciseIndex: Int = 0
  @State private var showExerciseView = false
  
  @EnvironmentObject private var tabBarSettings: AppManager
  
  init(challenge: Challenge, onBack: @escaping () -> Void) {
    self.challenge = challenge
    self.onBack = onBack
  }
  
  var body: some View {
    VStack(spacing: 5) {
      informationBox
      challengeExercises
      Spacer()
    }
    .safeAreaInset(edge: .bottom, spacing: 0) {
      GreenGrassButtonStyle(action: {
        showExerciseView.toggle()
      }, text: "Start")
    }
    .navigationDestination(isPresented: $showExerciseView) {
      if let exercise = currentExercise {
        ChallengeExerciseView(challengeExercise: exercise) { isCompleted in
          if isCompleted, let nextExercise = self.getNextExercise() {
            currentExercise = nextExercise
          }
          showExerciseView.toggle()
        }
      }
    }
    .onAppear(perform: {
      self.currentExercise = self.currentExercise ?? challenge.exercises.first
      tabBarSettings.isTabBarHidden = true
    })
    .navigationBarBackButtonHidden()
    .navigationTitle("")
    .toolbar(.hidden, for: .tabBar)
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var informationBox: some View {
    VStack(alignment: .leading) {
      Rectangle()
        .foregroundStyle(Color.AppColor.blue500)
        .ignoresSafeArea()
        .frame(height: 250)
        .overlay {
          VStack(spacing: 1) {
            navigationBar
            titleView
            if let participants = self.challenge.participants {
              PersonAvatarCircle(persons: participants)
              Text("\(participants.count) people attending")
                .foregroundStyle(.white)
                .font(.footnote)
            }
          }
        }
    }
  }
  
  @ViewBuilder
  private var challengeExercises: some View {
    VStack(spacing: 0) {
      ForEach(Array(challenge.exercises.enumerated()), id: \.element) { index, element in
        createListItem(for: element, with: index)
      }
    }
    .padding(.leading, 15)
  }
  
  @ViewBuilder
  private var titleView: some View {
    VStack(alignment: .center, content: {
      Text("Next challenge")
        .foregroundStyle(.white)
      Text(challenge.name)
        .foregroundStyle(.white)
        .font(.title)
        .bold()
      Color.white
        .frame(height: 1 / UIScreen.main.scale)
        .padding([.leading, .trailing], 50)
        .opacity(0.8)
    })
  }
  
  @ViewBuilder
  private var navigationBar: some View {
    HStack(spacing: 0) {
      backButton
      Spacer()
      addPersonButton
    }
    .padding([.leading, .trailing], 15)
  }
  
  @ViewBuilder
  private var backButton: some View {
    Button(action: onBack, label: {
      Image(systemName: "chevron.left")
        .resizable()
        .frame(width: 15, height: 20)
        .foregroundStyle(.white)
    })
  }
  
  @ViewBuilder
  private var addPersonButton: some View {
    Button {
      // do something
    } label: {
      Image(systemName: "person.badge.plus")
        .resizable()
        .frame(width: 30, height: 30)
        .foregroundStyle(.white)
    }
  }
}

// MARK: - Helper methods

extension ChallengeView {
  @ViewBuilder
  func createListItem(for challengeExercise: ChallengeExercise, with index: Int = 0) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      let isCurrentExercise = challengeExercise == self.currentExercise
      let viewOpacity = isCurrentExercise ? 1.0 : 0.5
      
      HStack {
        Circle()
          .frame(width: 30, height: 30)
          .foregroundStyle(isCurrentExercise ? Color.AppColor.blue600 : .gray)
          .opacity(viewOpacity)
          .overlay {
            VStack(alignment: .center) {
              Text("\(index + 1)")
                .foregroundStyle(isCurrentExercise ? .white : .black)
                .opacity(viewOpacity)
            }
          }
        
        VStack(alignment: .leading) {
          Text(challengeExercise.name)
            .bold()
            .opacity(viewOpacity)
          
          /// e.g. "3 rep | 30 sec rest"
          Text("\(challengeExercise.rounds) rep | \(challengeExercise.restDuration) sec rest")
            .font(.callout)
            .foregroundStyle(.gray)
            .opacity(viewOpacity)
        }
        .padding([.leading, .top], 10)
        Spacer()
        
        let minutesFromSeconds = challengeExercise.duration / 60
        Text("\(minutesFromSeconds) min")
          .padding(.trailing, 30)
          .font(.callout)
          .foregroundStyle(.gray)
          .opacity(0.8)
      }
      
      /// Draw a vertical line that connects the circles of all the list items
      /// Ends at the last item
      let isLast = challengeExercise == challenge.exercises.last
      if !isLast {
        Rectangle()
          .fill(.blue)
          .frame(width: 1, height: 35, alignment: .center)
          .padding(.leading, 15.5)
      }
    }
  }
  
  private func getNextExercise() -> ChallengeExercise? {
    let newIndex = currentExerciseIndex + 1
    if newIndex < challenge.exercises.count {
      currentExerciseIndex = newIndex
      return challenge.exercises[newIndex]
    } else {
      // If you reach the end, return back to the first exercise
      currentExerciseIndex = 0
      return challenge.exercises.first
    }
  }
}

#Preview {
  ChallengeView(challenge: MockConstants.challenge, onBack: {})
    .environmentObject(AppManager())
}
