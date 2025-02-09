//
//  HistoryScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.11.2024.
//

import Charts
import Components
import CoreLocation
import Models
import SwiftUI
import Utility

struct HistoryScreen: View {
  @Environment(\.navigator) private var navigator

  @State private var viewModel = HistoryViewModel()

  var body: some View {
    ScrollView {
      VStack {
        CalendarView(
          selectedDate: $viewModel.selectedDate,
          calendarMarkers: viewModel.historyChartData?.calendarMarkers ?? [])

        if let selectedDate = viewModel.selectedDate, !viewModel.displayExercises.isEmpty {
          ContentSectionWithHeader(headerTitle: "Completed exercises on \(DateHelper.labelDisplayForDate(selectedDate))") {
            ExerciseCardsStack(
              exercises: viewModel.displayExercises,
              onTapExercise: navigateToExerciseDetails(_:))
          }
          .transition(.scale)
        }

        if let chartData = viewModel.historyChartData {
          if !chartData.muscleChartData.isEmpty {
            MusclesChartView(data: chartData.muscleChartData)
          }

          if !chartData.sessionsChartData.isEmpty {
            SessionsChartView(data: chartData.sessionsChartData)
          }
        }
      }
      .animation(.smooth(duration: UIConstant.AnimationDuration.short), value: viewModel.selectedDate)
    }
    .padding(.horizontal, 16)
    .task {
      await viewModel.initialLoad()
    }
  }

  private func navigateToExerciseDetails(_ exercise: Exercise) {
    navigator.navigate(to: CommonDestinations.exerciseDetails(exercise))
  }
}

#Preview {
  HistoryScreen()
}
