//
//  ExerciseDetailsView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2024.
//

import SwiftUI
import Factory
import Models
import Components

struct ExerciseDetailsView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.appManager) private var appManager

  @State private var viewModel: ExerciseDetailsViewModel
  
  var exercise: Exercise
  var onComplete: (() -> Void)? = nil
  
  init(exercise: Exercise, onComplete: (() -> Void)? = nil) {
    self.viewModel = ExerciseDetailsViewModel(exercise: exercise)
    self.exercise = exercise
    self.onComplete = onComplete
  }
  
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
    .task {
      await viewModel.initialLoad()
    }
    .onDisappear(perform: viewModel.cleanUp)
    .onReceive(viewModel.event) { event in
      handleEvent(event)
    }
    .navigationBarBackButtonHidden()
    .safeAreaInset(edge: .bottom) {
      if viewModel.isTimerActive {
        Button(action: {
          appManager.showToast(style: .success, message: "Finished in \(viewModel.elapsedTime) seconds!")
          viewModel.stopTimer()
          onComplete?()
        }, label: {
          Text("Finish (\(viewModel.elapsedTime) sec)")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(SecondaryButtonStyle())
        .padding()
      } else {
        Button(action: viewModel.startTimer, label: {
          Text("Start workout")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(PrimaryButtonStyle())
        .padding()
        
      }
    }
  }

  private func handleEvent(_ event: ExerciseDetailsViewModel.Event) {
    switch event {
    case .didSaveSession:
      appManager.showToast(style: .success, message: "Completed exercise in \(viewModel.elapsedTime) seconds")
      appManager.notifyModelUpdate(.didAddExerciseSession)
    case .didSaveSessionFailure(let error):
      appManager.showToast(style: .error, message: "Could not complete exercise. \(error.localizedDescription)")
    case .didUpdateFavorite(let exercise, let bool):
      appManager.notifyModelUpdate(.didFavoriteExercise)
    case .didUpdateFavoriteFailure(let error):
      appManager.showToast(style: .error, message: "Could not favorite exercise. \(error.localizedDescription)")
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
      viewModel.isFavorite.toggle()
    }, label: {
      Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
        .resizable()
        .frame(width: 30, height: 25)
        .foregroundStyle(viewModel.isFavorite ? .red : .white)
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
}
