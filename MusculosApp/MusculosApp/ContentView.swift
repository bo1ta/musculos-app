//
//  ContentView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.06.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @State private var selection: String = "workout"
  @State private var tabSelection: TabBarItem = .workout

  var body: some View {
    ChallengeView(challenge: challengeMock, participants: participantsMock)
    
//    CustomTabBarContainerView(selection: $tabSelection) {
//      ChallengeView(challenge: challengeMock, participants: participantsMock)
//        .tabBarItem(tab: .workout, selection: $tabSelection)
//
//      AddExerciseView()
//        .tabBarItem(tab: .add, selection: $tabSelection)
//    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

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
