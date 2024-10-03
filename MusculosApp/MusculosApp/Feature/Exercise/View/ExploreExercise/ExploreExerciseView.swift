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

struct ExploreExerciseView: View {
  @Environment(\.navigationRouter) private var navigationRouter
  
  @State private var viewModel = ExploreExerciseViewModel()

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        AchievementCard()

        HStack {
          FormField(text: $viewModel.searchQuery, textHint: "Search by muscle", imageIcon: Image("search-icon"))
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
    .background(
      Color.white.opacity(0.98)
    )
    .onDisappear(perform: viewModel.cleanUp)
  }
}

#Preview {
  ExploreExerciseView()
}

