//
//  HomeView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.08.2024.
//

import SwiftUI
import Utility
import Components
import Models

struct HomeView: View {
  @Environment(\.userStore) private var userStore: UserStore
  @State private var text: String = ""

  let goals: [Goal.Category] = [.general, .growMuscle, .loseWeight]

  var body: some View {
    VStack {
      HomeSearchCard(displayName: userStore.displayName, searchQueryText: $text)
        .padding(.bottom, 40)

      ForEach(goals, id: \.self) { goal in
        DetailCard(text: goal.label, font: AppFont.poppins(.semibold, size: 19), content: {
          Image(goal.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70)
        })
      }
      .padding(.top, 30)

      Spacer()
    }
    .ignoresSafeArea()
  }
}

#Preview {
  HomeView()
}
