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
    return backgroundView {
      VStack(spacing: 5) {
        searchBar
        ButtonHorizontalStackView(
          selectedOption: $viewModel.selectedFilter,
          options: self.options,
          buttonsHaveEqualWidth: false
        )
        exerciseCards
      }
    }
    .task {
      await viewModel.loadInitialData()
    }
    .sheet(isPresented: $viewModel.isFiltersPresented) {
      SelectMuscleView(selectedMuscles: self.$viewModel.selectedMuscles)
    }
    .sheet(isPresented: $viewModel.isExerciseDetailPresented) {
      ExerciseView(exercise: viewModel.selectedExercise!)
    }
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var searchBar: some View {
    SearchBarView(placeholderText: "Search workouts", searchQuery: $viewModel.searchQuery, onFiltersTapped: {
      self.viewModel.isFiltersPresented.toggle()
    })
  }
  
  @ViewBuilder
  private var exerciseCards: some View {
    let enumeratedExercises = Array(viewModel.currentExercises.enumerated())
    List(enumeratedExercises, id: \.element.id) { index, item in
      Button {
        self.viewModel.selectedExercise = item
        self.viewModel.isExerciseDetailPresented = true
      } label: {
        CurrentWorkoutCardView(exercise: item)
          .onAppear {
            Task { await viewModel.maybeRequestMoreExercises(index: index) }
          }
      }
      .listRowBackground(Color.clear)
      .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
    }
    .frame(maxHeight: .infinity)
    .listRowBackground(Color.clear)
    .scrollContentBackground(.hidden)
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
