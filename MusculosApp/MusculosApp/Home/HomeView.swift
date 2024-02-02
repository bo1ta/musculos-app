//
//  HomeView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.10.2023.
//

import SwiftUI

struct HomeView: View {
  let challenge: Challenge
  
  @State private var isChallengePresented = false
  
  var body: some View {
    NavigationStack {
      VStack(alignment: .center) {
        challengeCard
        hintChallengeView
        Spacer()
      }
      .navigationDestination(isPresented: $isChallengePresented) {
        ChallengeView(challenge: challenge) {
          isChallengePresented.toggle()
        }
      }
      .onAppear {
        Task {
          let userProfile = await UserProfile.currentUserProfile(context: CoreDataStack.shared.backgroundContext)
          print(userProfile)
        }
      }
    }
  }
  
  @ViewBuilder
  var hintChallengeView: some View {
    VStack {
      Image("yoga-position")
        .renderingMode(.template)
        .resizable()
        .scaledToFit()
        .frame(width: 80, height: 100)
        .opacity(0.3)
        .foregroundStyle(.gray)
      Text("No challenges completed yet!")
        .font(.callout)
        .fontWeight(.regular)
        .italic()
        .opacity(0.3)
    }
  }
  
  @ViewBuilder
  var challengeCard: some View {
    Rectangle()
      .shadow(radius: 10)
      .frame(height: 400)
      .foregroundStyle(.white)
      .overlay {
        VStack(alignment: .center, content: {
          topSection
          
          Text("Next challenge")
            .font(.body)
            .bold()
            .padding(.top)
          Text(challenge.name)
            .font(.title)
            .bold()
          Divider()
            .padding([.leading, .trailing], 20)
          
          PersonAvatarCircle(persons: MockConstants.persons)
          Text("\(MockConstants.persons.count) people attending")
            .font(.callout)
            .foregroundStyle(.gray)
          GreenGrassButton(action: {
            isChallengePresented.toggle()
          }, text: "Learn More")
          .padding()
          
          Spacer()

        })
      }
      .padding(10)
  }
  
  @ViewBuilder
  var topSection: some View {
    Rectangle()
      .foregroundStyle(Color.appColor(with: .navyBlue))
      .frame(maxWidth: .infinity)
      .frame(height: 100)
      .overlay {
        VStack(alignment: .center) {
          if let exercise = challenge.exercises.first {
            Image(exercise.image)
              .resizable()
              .scaledToFit()
          }
        }
      }
  }
}

#Preview {
  HomeView(challenge: MockConstants.challenge)
}
