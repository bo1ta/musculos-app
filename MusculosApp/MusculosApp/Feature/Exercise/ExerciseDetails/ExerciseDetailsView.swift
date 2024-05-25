//
//  ExerciseDetailsView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2024.
//

import SwiftUI

final class ExerciseDetailsViewModel: ObservableObject {
  @Published  private(set) var isFavorite = false
  @Published  private(set) var showChallengeExercise = false
  @Published  private(set) var isTimerActive = false
  @Published  private(set) var timer: Timer? = nil
  @Published  private(set) var elapsedTime: Int = 0
}

struct ExerciseDetailsView: View {
  @Environment(\.dismiss) private var dismiss
  
  @EnvironmentObject private var appManager: AppManager
  @EnvironmentObject private var exerciseStore: ExerciseStore
  
  @State private var isFavorite = false
  @State private var showChallengeExercise = false
  @State private var isTimerActive = false
  @State private var timer: Timer? = nil
  @State private var elapsedTime: Int = 0
  
  var exercise: Exercise
  var onComplete: (() -> Void)? = nil
  
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
        appManager.hideTabBar()
        
        isFavorite = exerciseStore.checkIsFavorite(exercise: exercise)
      }
    }
    .onDisappear(perform: exerciseStore.cleanUp)
    .navigationBarBackButtonHidden()
    .safeAreaInset(edge: .bottom) {
      if isTimerActive {
        Button(action: {
          appManager.showToast(style: .success, message: "Finished in \(elapsedTime) seconds!")
          stopTimer()
        }, label: {
          Text("Finish (\(elapsedTime) sec)")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(SecondaryButtonStyle())
        .padding()
      } else {
        Button(action: startTimer, label: {
          Text("Start workout")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(PrimaryButtonStyle())
        .padding()
        
      }
    }
  }
}

// MARK: - Views

extension ExerciseDetailsView {
  private var imageSection: some View {
    AnimatedURLImageView(imageURLs: exercise.getImagesURLs())
      .overlay {
        imageOverlay
      }
      .ignoresSafeArea()
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
        ForEach(exercise.secondaryMuscles.chunked(into: 2).first ?? [], id: \.self) { secondaryMuscle in
          IconPill(option: IconPillOption(title: secondaryMuscle))
        }
        Spacer()
        favoriteButton
      }
      .padding(.bottom, 40)
      .padding([.trailing, .leading], 10)
    }
  }
  
  private var favoriteButton: some View {
    Button(action: {
      isFavorite.toggle()
      exerciseStore.favoriteExercise(exercise, isFavorite: isFavorite)
    }, label: {
      Image(systemName: isFavorite ? "heart.fill" : "heart")
        .resizable()
        .frame(width: 30, height: 25)
        .foregroundStyle(isFavorite ? .red : .white)
        .shadow(radius: 1.0)
    })
  }
  
  private var detailsSection: some View {
    HStack {
      VStack(alignment: .leading, spacing: 10) {
        Text(exercise.name)
          .font(.header(.regular, size: 22))
        Group {
          if let equipment = exercise.equipment {
            createIconDetail(title: equipment, systemImageName: "dumbbell.fill")
          }
          createIconDetail(title: "4.5/5.0", systemImageName: "star.fill")
        }
        .padding(.leading, 10)
        
      }
      .padding(.leading, 20)
      Spacer()
    }
  }
  
  private func createIconDetail(title: String, systemImageName: String) -> some View {
    HStack {
      Image(systemName: systemImageName)
        .frame(width: 20, height: 20)
      Text(title)
        .font(.body(.light, size: 14))
    }
  }
  
  private func startTimer() {
    isTimerActive = true
    elapsedTime = 0
    
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
      elapsedTime += 1
    })
    
    if let timer {
      RunLoop.current.add(timer, forMode: .common)
    }
  }
  
  private func stopTimer() {
    isTimerActive = false
    timer?.invalidate()
    timer = nil
    
    appManager.showToast(style: .success, message: "Finished in \(elapsedTime) seconds!")
    onComplete?()
  }
  
  private var stepsSection: some View {
    VStack {
      ForEach(Array(exercise.instructions.enumerated()), id: \.element) { index, instruction in
        DetailCardView(title: instruction, index: index + 1)
      }
    }
  }
}
  
  #Preview {
    ExerciseDetailsView(exercise: ExerciseFactory.createExercise())
      .environmentObject(AppManager())
      .environmentObject(ExerciseStore())
  }
