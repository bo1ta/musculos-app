//
//  WorkoutListView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.03.2024.
//

import SwiftUI
import Shimmer

struct WorkoutListView: View {
  @Environment(\.navigationRouter) private var navigationRouter

  @State private var viewModel = WorkoutListViewModel()
  
  var body: some View {
    NavigationStack {
      VStack {
        Text("Workouts")
          .font(.header(.bold, size: 20.0))
        
        switch viewModel.state {
        case .loading:
          loadingSkeleton
        case .loaded(let workouts):
          ScrollView {
            VStack(alignment: .leading) {
              ForEach(workouts, id: \.hashValue) { workout in
                Button {
                  navigationRouter.present(.workoutFlow(workout))
                } label: {
                  WorkoutCard(workout: workout)
                }
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
  
  private var loadingSkeleton: some View {
    VStack {
      ForEach(1..<6, id: \.self) { _ in
        RoundedRectangle(cornerRadius: 12)
          .foregroundStyle(.gray)
          .frame(maxWidth: .infinity)
          .frame(height: 200)
          .shimmering()
      }
    }
  }
}

#Preview {
  WorkoutListView()
}
