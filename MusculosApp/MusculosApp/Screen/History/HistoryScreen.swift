//
//  HistoryScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.11.2024.
//

import SwiftUI
import Components
import Utility
import Models

struct HistoryScreen: View {
  @State private var selectedDate: Date?
  @State private var calendarMarkers: [CalendarMarker] = []
  @State private var viewModel = HistoryViewModel()

  var body: some View {
    VStack {
      CalendarView(selectedDate: $selectedDate, calendarMarkers: $calendarMarkers)

      if !viewModel.filteredSessions.isEmpty {
        ForEach(viewModel.filteredSessions, id: \.sessionId) { exerciseSession in
          Text(exerciseSession.exercise.name)
        }
      }

      Spacer()

    }
    .ignoresSafeArea()
    .task {
      await viewModel.initialLoad()
    }
  }
}

#Preview {
  HistoryScreen()
}
