//
//  WorkoutFeedView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.07.2023.
//

import SwiftUI

struct WorkoutFeedView: View {
  @StateObject var viewModel = WorkoutFeedViewModel()

  private let options = ["Favorites", "Home workout", "Gym workout"]

  var body: some View {
    backgroundView {
      VStack(spacing: 5) {
        SearchBarView(placeholderText: "Search workouts", searchQuery: $viewModel.searchQuery, onFiltersTapped: {
          self.viewModel.isFiltersPresented.toggle()
        })

        ButtonHorizontalStackView(selectedOption: $viewModel.selectedFilter, options: self.options, buttonsHaveEqualWidth: false)

        ScrollView(.vertical, showsIndicators: false, content: {
          ForEach(viewModel.currentExercises, id: \.self) { exercise in
            Button {
              self.viewModel.selectedExercise = exercise
              self.viewModel.isExerciseDetailPresented = true
            } label: {
              CurrentWorkoutCardView(exercise: exercise)
            }
          }
        })
        .padding(0)
      }
    }
    .task {
      await self.viewModel.loadExercises()
    }
    .sheet(isPresented: $viewModel.isFiltersPresented) {
      SelectMuscleView(selectedMuscles: self.$viewModel.selectedMuscles)
    }
    .sheet(isPresented: $viewModel.isExerciseDetailPresented) {
      ExerciseView(exercise: viewModel.selectedExercise!)
    }
  }

  @ViewBuilder
  private func backgroundView(@ViewBuilder content: () -> some View) -> some View {
    ZStack {
      Image("weightlifting-background")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(minWidth: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .overlay {
          Color.black
            .opacity(0.8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }

      content()
        .padding(4)
    }
  }
}

struct WorkoutFeedView_Preview: PreviewProvider {
  static var previews: some View {
    WorkoutFeedView()
  }
}

struct BackgroundClearView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {}
}
