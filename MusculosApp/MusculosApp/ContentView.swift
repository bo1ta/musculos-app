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
    ChallengeView(challenge: MockConstants.challenge, participants: MockConstants.persons)
    
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
