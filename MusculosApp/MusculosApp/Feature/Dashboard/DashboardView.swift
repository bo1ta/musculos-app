//
//  DashboardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.10.2023.
//

import SwiftUI
import Utilities

struct DashboardView: View {
  @Environment(\.appManager) private var appManager

  private var challenge: Challenge = MockConstants.challenge
  @State private var showChallenge = false
  
  var body: some View {
    NavigationStack {
      VStack(alignment: .center) {
        challengeCard
        HintIconView(systemImage: "dumbbell", textHint: "No challenges completed yet!")
        Spacer()
      }
      .onAppear(perform: appManager.showTabBar)
      .navigationDestination(isPresented: $showChallenge) {
        ChallengeView(challenge: challenge) {
          showChallenge.toggle()
        }
      }
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
            .padding(.horizontal, 20)

          PersonAvatarCircle(persons: MockConstants.persons)
          Text("\(MockConstants.persons.count) people attending")
            .font(.callout)
            .foregroundStyle(.gray)
          GreenGrassButtonStyle(action: {
            showChallenge.toggle()
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
      .foregroundStyle(AppColor.blue700)
      .frame(maxWidth: .infinity)
      .frame(height: 100)
      .overlay {
        VStack(alignment: .center) {
          if let exercise = challenge.exercises.first, let image = exercise.image {
            Image(image)
              .resizable()
              .scaledToFit()
          }
        }
      }
  }
}


#Preview {
  DashboardView()
}
