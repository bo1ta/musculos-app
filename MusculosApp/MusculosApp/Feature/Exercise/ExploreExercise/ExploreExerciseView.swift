//
//  ExploreExerciseView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import SwiftUI
import Components
import Storage
import Models
import Utility

struct ExploreExerciseView: View {
  @Environment(\.navigationRouter) private var navigationRouter
  
  @State private var viewModel = ExploreExerciseViewModel()
  @StateObject private var debouncedQueryObserver = DebouncedQueryObserver()

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        AchievementCard()

        HStack {
          FormField(text: $debouncedQueryObserver.searchQuery, textHint: "Search by muscle", imageIcon: Image("search-icon"))
          Button(action: {
            viewModel.showFilterView.toggle()
          }, label: {
            Image(systemName: "line.3.horizontal.decrease")
              .resizable()
              .renderingMode(.template)
              .aspectRatio(contentMode: .fit)
              .frame(height: 15)
              .foregroundStyle(.black.opacity(0.9))
          })
            .buttonStyle(.plain)
            .padding(.horizontal, 5)
        }

        ExerciseSectionsContentView(
          categorySection: $viewModel.currentSection,
          contentState: $viewModel.contentState,
          recommendedExercisesByGoals: $viewModel.recommendedByGoals,
          recommendedExercisesByPastSessions: $viewModel.recommendedByPastSessions,
          onExerciseTap: { exercise in
            navigationRouter.push(.exerciseDetails(exercise))
          }
        )
        .transition(.slide)

        WhiteBackgroundCard()
      }
      .padding()
      .animation(.snappy(), value: viewModel.currentSection)
      .scrollIndicators(.hidden)
    }
    .popover(isPresented: $viewModel.showFilterView) {
      ExerciseFilterView(onFiltered: { filteredExercises in
        viewModel.contentState = .loaded(filteredExercises)
      })
    }
    .task {
      await viewModel.initialLoad()
    }
    .onChange(of: debouncedQueryObserver.debouncedQuery) { oldQuery, newQuery in
      if newQuery.isEmpty && !oldQuery.isEmpty {
        viewModel.didChangeSection(to: .discover)
      } else {
        if newQuery.count > 3 {
          viewModel.searchByMuscleQuery(newQuery)
        }
      }
    }
    .background(
      Color.white.opacity(0.98)
    )
    .onDisappear(perform: viewModel.cleanUp)
  }
}

#Preview {
  ExploreExerciseView()
}

// MARK: - Section Type

enum ExploreCategorySection: String, CaseIterable {
  case discover, workout, myFavorites

  var title: String {
    switch self {
    case .discover:
      "Discover"
    case .workout:
      "Workout"
    case .myFavorites:
      "Favorites"
    }
  }
}
