//
//  MusclesChartView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.02.2025.
//

import Charts
import Components
import SwiftUI
import Utility

struct MusclesChartView: View {
  let data: [MuscleChartData]

  var body: some View {
    ContentSectionWithHeader(headerTitle: "Exercises completed by muscle types", withScroll: false) {
      Chart(data) { muscleData in
        SectorMark(
          angle: .value("Count", muscleData.count),
          innerRadius: .ratio(0.4),
          outerRadius: .automatic,
          angularInset: 1.5)
          .foregroundStyle(
            randomGradientForPieChart())
          .cornerRadius(5)
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
  }

  private func randomGradientForPieChart() -> LinearGradient {
    let randomColor = Color(
      red: Double.random(in: 0.0...0.6),
      green: Double.random(in: 0.0...0.6),
      blue: Double.random(in: 0.0...0.6))
    let randomColor2 = Color(
      red: Double.random(in: 0...1),
      green: Double.random(in: 0...1),
      blue: Double.random(in: 0...1))
    return LinearGradient(
      gradient: Gradient(colors: [randomColor.opacity(0.7), randomColor2]),
      startPoint: .topLeading,
      endPoint: .bottomTrailing)
  }
}
