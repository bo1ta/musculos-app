//
//  WorkoutFeedView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.07.2023.
//

import SwiftUI

struct WorkoutFeedView: View {
  @StateObject var viewModel = WorkoutFeedViewModel()

  let overrideLocalExercises: Bool
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
    List(enumeratedExercises, id: \.element.id) { index, item in
      Button {
        self.viewModel.selectedExercise = item
        self.viewModel.isExerciseDetailPresented = true
      } label: {
        CurrentWorkoutCardView(exercise: item)
          .task {
            await viewModel.maybeRequestMoreExercises(index: index)
          }
          .padding(.bottom, 10)
      }
      .listRowBackground(Color.clear)
      .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
    }
    .frame(maxHeight: .infinity)
    .scrollContentBackground(.hidden)
  }

  @ViewBuilder
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
          Color.white
            .opacity(0.6)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }

      content()
    }
  }
}

struct WorkoutFeedView_Preview: PreviewProvider {
  static var previews: some View {
    WorkoutFeedView(overrideLocalExericses: true)
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
