//
//  ExerciseDetailsView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2024.
//

import SwiftUI
import Kingfisher

struct ExerciseDetailsView: View {
  @Environment(\.mainWindowSize) private var mainWindowSize
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var tabBarSettings: TabBarSettings
  @EnvironmentObject private var exerciseStore: ExerciseStore

  @State var exercise: Exercise
  
  var body: some View {
    VStack(spacing: 10) {
      imageSection
      detailsSection
      stepsSection
      
      
      Spacer()
    }
    .onAppear(perform: {
      exerciseStore.loadAllImagesForExercise(exercise)
      tabBarSettings.isTabBarHidden = true
    })
    .onChange(of: exerciseStore.exerciseHasAllImages) { _ in
      if let exercise = exerciseStore.exerciseWithAllImages {
        self.exercise = exercise
        print(exercise.images)
      }
    }
    .navigationBarBackButtonHidden()
  }
  
  @ViewBuilder
  private var imageSection: some View {
    if let exerciseWithAllImages = exerciseStore.exerciseWithAllImages {
      AnimatedURLImageView(imageURLs: exerciseWithAllImages.images)
        .overlay {
          imageOverlay
        }
        .ignoresSafeArea()
    }
  }
  
  private var imageOverlay: some View {
    VStack {
      HStack {
        Button(action: {
          exerciseStore.exerciseWithAllImages = nil
          dismiss()
        }, label: {
          Circle()
            .frame(width: 40, height: 40)
            .foregroundStyle(.white)
            .overlay {
              Image(systemName: "arrow.left")
                .foregroundStyle(.gray)
                .bold()
            }
        })
        Spacer()
      }
      .padding(.top, 50)
      .padding(.leading, 10)
      Spacer()
      HStack {
        if let primaryMuscle = exercise.primaryMuscles.first {
          IconPill(option: IconPillOption(title: primaryMuscle))
        }
        ForEach(exercise.secondaryMuscles, id: \.self) { secondaryMuscle in
          IconPill(option: IconPillOption(title: secondaryMuscle))
        }
        Spacer()
      }
      .padding(.bottom, 40)
      .padding(.leading, 10)
    }
  }
  
  private var detailsSection: some View {
    HStack {
      VStack(alignment: .leading, spacing: 10) {
        Text(exercise.name)
          .font(.custom(AppFont.regular, size: 22))
        Group {
          if let equipment = exercise.equipment {
            createIconDetail(title: equipment, systemImageName: "dumbbell.fill")
          }
          createIconDetail(title: "4.5/5.0", systemImageName: "star.fill")
        }
        .padding(.leading, 10)
        
      }
      .padding(.leading, 20)
      .padding(.top, -50)
      Spacer()
    }
  }
  
  private func createIconDetail(title: String, systemImageName: String) -> some View {
    HStack {
      Image(systemName: systemImageName)
        .frame(width: 20, height: 20)
      Text(title)
        .font(.custom(AppFont.light, size: 14))
    }
  }
  
  @ViewBuilder
  private var stepsSection: some View {
    ScrollView {
      ForEach(Array(exercise.instructions.enumerated()), id: \.element) { index, instruction in
        DetailCardView(title: instruction, index: index + 1)
      }
    }
    .padding()
    .scrollIndicators(.hidden)
  }
}

#Preview {
  ExerciseDetailsView(exercise: MockConstants.exercise).environmentObject(TabBarSettings()).environmentObject(ExerciseStore())
}
