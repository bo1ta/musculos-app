//
//  ChallengeView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.10.2023.
//

import SwiftUI

struct ChallengeView: View {
  let challenge: Challenge
  let participants: [Person]?

  @State private var currentExercise: ChallengeExercise?
  @State private var currentExerciseIndex: Int = 0

  @State private var showExerciseView = false

  init(challenge: Challenge, participants: [Person]?, currentExercise: ChallengeExercise? = nil) {
    self.challenge = challenge
    self.participants = participants
  }

  var body: some View {
    NavigationStack {
      VStack(spacing: 5) {
        informationBox
        challengeExercises
        Spacer()
      }
      .safeAreaInset(edge: .bottom, spacing: 0) {
        startButton
      }
      .navigationDestination(isPresented: $showExerciseView) {
        if let exercise = currentExercise {
          ChallengeExerciseView(challengeExercise: exercise) { isCompleted in
            showExerciseView.toggle()
            if isCompleted, let nextExercise = self.getNextExercise() {
              currentExercise = nextExercise
            }
          }
        }
      }
    }
    .onAppear(perform: {
      self.currentExercise = challenge.exercises.first
    })
  }

  // MARK: - Views

  @ViewBuilder
  private var startButton: some View {
    Button(action: {
      showExerciseView.toggle()
    }, label: {
      Rectangle()
        .frame(height: 60)
        .foregroundStyle(Color.appColor(with: .grassGreen))
        .overlay {
          Text("Start")
            .font(.body)
            .bold()
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
        }
    })
  }

  @ViewBuilder
  private var informationBox: some View {
    VStack(alignment: .leading) {
      Rectangle()
        .foregroundStyle(Color.appColor(with: .navyBlue))
        .ignoresSafeArea()
        .frame(height: 250)
        .overlay {
          VStack(spacing: 1) {
            navigationBar
            titleView
            if let participants = self.participants {
              createAvatarCircles(participants: participants)
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
    Button {
      // do something
    } label: {
      Image(systemName: "chevron.left")
        .resizable()
        .frame(width: 15, height: 20)
        .foregroundStyle(.white)
    }
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
  private func createAvatarCircles(participants: [Person]) -> some View {
    let baseAvatarCircle = Circle()
      .frame(width: 40, height: 40)
      .foregroundStyle(.white)
    
    HStack(alignment: .center, spacing: -25, content: {
      ForEach(Array(participants.enumerated()), id: \.element) { index, element in
        if index > 3 {
          Circle()
            .frame(width: 40, height: 40)
            .overlay {
              Text("+\(participants.count - 4)")
                .font(.callout)
                .foregroundStyle(.gray)
            }
            .foregroundStyle(.white)
            .padding(.leading, 10)
        } else {
          AsyncImage(url: element.avatarUrl) { phase in
            switch phase {
            case .empty:
              ProgressView()
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 60, height: 60)
            case .failure:
              baseAvatarCircle
            @unknown default:
              EmptyView()
            }
          }
        }
      }
    })
  }
  
  @ViewBuilder
  func createListItem(for challengeExercise: ChallengeExercise, with index: Int = 0) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      let isCurrentExercise = challengeExercise == self.currentExercise
      let viewOpacity = isCurrentExercise ? 1.0 : 0.5
      
      HStack {
        Circle()
          .frame(width: 30, height: 30)
          .foregroundStyle(isCurrentExercise ? Color.appColor(with: .navyBlue) : .gray)
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
          .fill(Color.blue)
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
          // If you reach the end, loop back to the first exercise
          currentExerciseIndex = 0
          return challenge.exercises.first
      }
  }
}

#Preview {
  ChallengeView(challenge: MockConstants.challenge, participants: MockConstants.persons)
}
