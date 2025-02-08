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
  @State private var viewModel = HistoryViewModel()

  var body: some View {
    ScrollView {
      VStack {
        CalendarView(
          selectedDate: $viewModel.selectedDate,
          calendarMarkers: viewModel.calendarMarkers)

        if !viewModel.muscleChartData.isEmpty {
          MusclesChartView(data: viewModel.muscleChartData)
        }
        if !viewModel.sessionsChartData.isEmpty {
          SessionsChartView(data: viewModel.sessionsChartData)
        }
      }
    }
    .padding(.horizontal, 16)
    .task {
      await viewModel.initialLoad()
    }
  }
}

#Preview {
  HistoryScreen()
}
