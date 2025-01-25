//
//  ProfileScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.03.2024.
//

import Components
import Models
import Charts
import SwiftUI
import Utility

struct ProfileScreen: View {
  @Environment(\.navigator) private var navigator

  @State private var viewModel = ProfileViewModel()

  private static let highlights: [ProfileHighlight] = [
    ProfileHighlight(highlightType: .steps, value: "5432", description: "updated 10 mins ago"),
    ProfileHighlight(highlightType: .sleep, value: "7 hr 31 min", description: "updated 10 mins ago"),
    ProfileHighlight(highlightType: .waterIntake, value: "4.2 ltr", description: "updated now"),
    ProfileHighlight(highlightType: .workoutTracking, value: "1 day since last workout", description: "updated a day ago"),
  ]

  var body: some View {
    ScrollView {
      VStack(spacing: 10) {
        UserHeader(profile: viewModel.currentUser, onNotificationsTap: { })

        ContentSectionWithHeader(headerTitle: "Highlights", withScroll: false) {
          VStack {
            ForEach(Self.highlights, id: \.hashValue) { profileHighlight in
              HighlightCard(profileHighlight: profileHighlight)
            }
          }
        }

        ContentSectionWithHeader(headerTitle: "Exercises completed by muscle types", withScroll: false) {
          Chart(viewModel.muscleChartData) { muscleData in
            SectorMark(
              angle: .value("Count", muscleData.count),
              innerRadius: .ratio(0.4),
              outerRadius: .automatic,
              angularInset: 1.5
            )
            
            .foregroundStyle(by: .value("Muscle", muscleData.muscleName))
            .annotation(position: .overlay) {
              VStack {
                Text(muscleData.muscleName)
                  .font(.body(.regular, size: 13.0))
                  .foregroundColor(.white)
                  .shadow(radius: 1.0)
                Text("\(muscleData.count)")
                  .font(.body(.bold, size: 13.0))
                  .foregroundColor(.white)
                  .shadow(radius: 1.0)
              }
            }
          }
          .chartLegend(.hidden)
          .frame(height: 300)
        }

        ContentSectionWithHeader(headerTitle: "Exercises completed this week", withScroll: false) {
          Chart(viewModel.sessionsChartData) { sessionData in
              BarMark(
                  x: .value("Day", sessionData.dayName),
                  y: .value("Count", sessionData.count)
              )
              .foregroundStyle(Color.blue.gradient)
              .cornerRadius(8)
          }
          .chartXAxis {
              AxisMarks(position: .bottom, values: .automatic) {
                  AxisValueLabel()
                      .font(AppFont.body(.regular, size: 12.0))
              }
          }
          .chartYAxis {
              AxisMarks(position: .leading) {
                  AxisGridLine()
                  AxisValueLabel()
              }
          }
          .frame(minHeight: 150, maxHeight: 250)
        }

        ContentSectionWithHeader(headerTitle: "Favorite exercises") {
          ExerciseCardsStack(
            exercises: viewModel.favoriteExercises,
            onTapExercise: { navigator.navigate(to: CommonDestinations.exerciseDetails($0)) })
        }
      }
      .padding(.horizontal, 15)
      .padding(.bottom, 30)
    }
    .task {
      await viewModel.initialLoad()
    }
    .scrollIndicators(.hidden)
  }
}

#Preview {
  ProfileScreen()
}
