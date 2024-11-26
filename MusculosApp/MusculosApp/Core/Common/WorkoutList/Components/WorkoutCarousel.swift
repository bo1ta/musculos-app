//
//  WorkoutCarousel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 17.05.2024.
//

import SwiftUI
import Models
import Utility
import NetworkClient

struct WorkoutCarousel: View {
  @State private var currentIndex = 0
  private let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
  
  var workoutExercises: [WorkoutExercise]
  
  var body: some View {
    VStack {
      TabView(selection: $currentIndex,
              content:  {
        ForEach(workoutExercises, id: \.hashValue) { workoutExercise in
          if let imageUrl = workoutExercise.exercise.getImagesURLs().first {
            AsyncCachedImage(url: imageUrl) { imagePhase in
              switch imagePhase {
              case .empty:
                Color.white
                  .frame(width: 100, height: 100)
                  .shadow(radius: 1.3)
              case .success(let image):
                image
                  .resizable()
                  .scaledToFill()
                  .overlay {
                    Color.black.opacity(0.6)
                  }
              case .failure(let error):
                Color.white
                  .frame(width: 100, height: 100)
                  .shadow(radius: 1.3)
                  .onAppear {
                    MusculosLogger.logError(error, message: "Error on CarouselExercise", category: .ui)
                  }
              @unknown default:
                Color.clear
                  .onAppear {
                    MusculosLogger.logError(MusculosError.unknownError, message: "Errored on CarouselView", category: .ui)
                  }
              }
            }
            .tag(workoutExercise)
          }
        }
      })
      .tabViewStyle(PageTabViewStyle())
    }
    .onReceive(timer) { _ in
      withAnimation {
        currentIndex = (currentIndex + 1) % workoutExercises.count
      }
    }
  }
}
