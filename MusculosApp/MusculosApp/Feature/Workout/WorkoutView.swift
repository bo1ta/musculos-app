//
//  WorkoutView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.03.2024.
//

import SwiftUI
import Shimmer

struct WorkoutView: View {
  @StateObject private var viewModel = WorkoutViewModel()
  
  var body: some View {
    VStack {
      Text("Workouts")
        .font(.header(.bold, size: 20.0))
      
      switch viewModel.state {
      case .loading:
        ForEach(1..<6, id: \.self) { _ in
          RoundedRectangle(cornerRadius: 12)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .shimmering()
        }
      case .loaded(let workouts):
        ScrollView {
          VStack(alignment: .leading) {
            RoundedTextField(text: $viewModel.searchQuery, textHint: "Search workout")
              .padding(.bottom)
            
            ForEach(workouts, id: \.hashValue) { workout in
              WorkoutCard(workout: workout)
              
            }
            .padding()
          }
        }
      case .empty:
        Color.clear
      case .error(let errorMessage):
        Text(errorMessage)
      }
    }
    .onAppear(perform: viewModel.initialLoad)
  }
  
}

#Preview {
  WorkoutView()
}
