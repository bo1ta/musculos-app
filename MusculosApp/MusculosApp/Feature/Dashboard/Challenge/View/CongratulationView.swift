//
//  CongratulationView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.10.2023.
//

import SwiftUI

struct CongratulationView: View {
  let exerciseName: String
  let onGetReward: () -> Void
  
  var body: some View {
    VStack(alignment: .center, spacing: 10, content: {
      Image("golden-cup")
        .resizable()
        .frame(width: 100, height: 100)
        .padding(.top, 10)
      Text("Congratulations!")
        .font(.title2)
        .bold()
      Text("You and your team just finished the \(exerciseName) challenge. Get your reward!")
        .font(.callout)
        .foregroundStyle(.gray)
        .opacity(0.9)
      
      GreenGrassButtonStyle(action: self.onGetReward, text: "Get Reward")
        .padding(.top, 10)
      
    })
    .padding(20)
  }
}

#Preview {
  CongratulationView(exerciseName: "Chest Master", onGetReward: {})
}
