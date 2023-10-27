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

// MARK: - Preview

private let challengeMock = Challenge(
  name: "Squat master",
  exercises: [
    ChallengeExercise(name: "Wall Sit", instructions: "Sit down with your back against the wall as if there was a chair, and hold the position", rounds: 1, duration: 5, restDuration: 5),
    ChallengeExercise(name: "Braced squat", rounds: 2, duration: 180, restDuration: 30),
    ChallengeExercise(name: "Barbell squat", rounds: 3, duration: 300, restDuration: 30),
    ChallengeExercise(name: "Jump squat", rounds: 2, duration: 180, restDuration: 30)
  ])

private let participantsMock = [
  Person(avatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=1000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww", name: "Andreea"),
  Person(avatar: "https://www.masslive.com/resizer/kNl3qvErgJ3B0Cu-WSBWFYc1B8Q=/arc-anglerfish-arc2-prod-advancelocal/public/W5HI6Y4DINDTNP76R6CLA5IWRU.jpeg", name: "Naomi"),
  Person(avatar: "https://image.cnbcfm.com/api/v1/image/107241090-1684160036619-gettyimages-1255019394-AFP_33F44YL.jpeg?v=1685596344", name: "Elon"),
  Person(avatar: "https://ebizfiling.com/wp-content/uploads/2017/12/images_29-3.jpg", name: "David"),
  Person(avatar: "https://www.bentbusinessmarketing.com/wp-content/uploads/2013/02/35844588650_3ebd4096b1_b-1024x683.jpg", name: "Ionut")
]

#Preview {
  ChallengeView(challenge: challengeMock, participants: participantsMock)
}
