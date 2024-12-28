//
//  HistoryScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.11.2024.
//

import Components
import Models
import SwiftUI
import Utility

struct HistoryScreen: View {
  @State private var viewModel = HistoryViewModel()

  private let cardGradient = LinearGradient(colors: [.blue, .blue.opacity(0.5)], startPoint: .top, endPoint: .bottom)

  var body: some View {
    ScrollView {
      VStack {
        CalendarView(
          selectedDate: $viewModel.selectedDate,
          calendarMarkers: viewModel.calendarMarkers
        )
      }

      if !viewModel.filteredSessions.isEmpty {
        ForEach(viewModel.filteredSessions, id: \.sessionId) { exerciseSession in
          SmallCardWithContent(
            title: exerciseSession.exercise.name,
            description: exerciseSession.dateAdded.ISO8601Format(),
            gradient: cardGradient,
            rightContent: {}
          )
        }
      }

      Spacer()
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
