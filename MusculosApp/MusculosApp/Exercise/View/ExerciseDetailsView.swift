//
//  ExerciseDetailsView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2024.
//

import SwiftUI

struct ExerciseDetailsView: View {
  @Environment(\.mainWindowSize) private var mainWindowSize
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var tabBarSettings: TabBarSettings
  
  private let client = MusculosClient()
  
  var exercise: Exercise
  
  var body: some View {
    VStack(spacing: 10) {
      imageSection
      ScrollView {
        detailsSection
        stepsSection
          .padding([.top, .bottom], 10)
      }
      .scrollIndicators(.hidden)
      .padding(.top, -50)
      
      Spacer()
    }
    .onAppear {
      DispatchQueue.main.async {
        tabBarSettings.isTabBarHidden = true
      }
    }
    .navigationBarBackButtonHidden()
  }
  
  @ViewBuilder
  private var imageSection: some View {
    if exercise.imageUrls.count > 0 {
      let images = exercise.getImagesURLs()
      AnimatedURLImageView(imageURLs: images)
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
      .padding(.top)
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
    LazyVStack {
      ForEach(Array(exercise.instructions.enumerated()), id: \.element) { index, instruction in
        DetailCardView(title: instruction, index: index + 1)
      }
    }
  }
}

#Preview {
  ExerciseDetailsView(exercise: MockConstants.createMockExercise())
    .environmentObject(TabBarSettings())
    .environmentObject(ExerciseStore())
}
