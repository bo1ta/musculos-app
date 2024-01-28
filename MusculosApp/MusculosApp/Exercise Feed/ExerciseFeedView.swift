//
//  ExerciseFeedView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.07.2023.
//

import SwiftUI

struct ExerciseFeedView: View {
  @StateObject var viewModel = ExerciseFeedViewModel()

  // use local store instead of making a network request
  private let overrideLocalExercises: Bool

  private let options = ["Favorites", "Home workout", "Gym workout"]
  
  init(overrideLocalExericses: Bool = false) {
    self.overrideLocalExercises = overrideLocalExericses
  }

  var body: some View {
    NavigationStack {
      backgroundView {
        VStack(spacing: 5) {
          Group {
            searchBar
            filterButtonsStack
          }
          .padding([.leading, .trailing], 5)
          
          exerciseCards
        }
        .task {
          viewModel.overrideLocalPreview = overrideLocalExercises
          await viewModel.loadInitialData()
        }
        .navigationDestination(isPresented: $viewModel.isExerciseDetailPresented, destination: {
          if let exercise = viewModel.selectedExercise {
            ExerciseView(exercise: exercise, onBack: {
              viewModel.isExerciseDetailPresented = false
            })
          } else {
            EmptyView()
          }
        })
        .sheet(isPresented: $viewModel.isFiltersPresented) {
          SelectMuscleView(selectedMuscles: $viewModel.selectedMuscles)
        }
      }
      .overlay {
        if viewModel.isLoading {
          LoadingOverlayView()
        }
      }
    }
  }
  
  // MARK: - Views
  
  private var searchBar: some View {
    SearchBarView(placeholderText: "Search workouts", searchQuery: $viewModel.searchQuery, onFiltersTapped: {
      self.viewModel.isFiltersPresented.toggle()
    })
  }
  
  private var filterButtonsStack: some View {
    ButtonHorizontalStackView(
      selectedOption: $viewModel.selectedFilter,
      options: self.options,
      buttonsHaveEqualWidth: false
    )
  }
  
  @ViewBuilder
  private var exerciseCards: some View {
    let enumeratedExercises = Array(viewModel.currentExercises.enumerated())
    
    ScrollView {
      LazyVStack {
        ForEach(enumeratedExercises, id: \.element.hashValue) { index, item in
          Button {
            self.viewModel.selectedExercise = item
            self.viewModel.isExerciseDetailPresented = true
          } label: {
            CurrentWorkoutCardView(exercise: item, isGif: false)
              .task {
                await viewModel.maybeRequestMoreExercises(index: index)
              }
              .padding(.bottom, 10)
          }
        }
      }
    }
    .frame(maxHeight: .infinity)
    .scrollContentBackground(.hidden)
  }

  private func backgroundView(
    @ViewBuilder content: () -> some View
  ) -> some View {
    ZStack {
      Image("weightlifting-background")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(minWidth: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .overlay {
          Color.black
            .opacity(0.4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }

      content()
    }
  }
}

struct WorkoutFeedView_Preview: PreviewProvider {
  static var previews: some View {
    ExerciseFeedView(overrideLocalExericses: false)
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
