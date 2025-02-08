//
//  SessionsChartView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.02.2025.
//

import Charts
import Components
import SwiftUI
import Utility

struct SessionsChartView: View {
  let data: [SessionChartData]

  var body: some View {
    ContentSectionWithHeader(headerTitle: "Exercises completed this week", withScroll: false) {
      Chart(data) { sessionData in
        BarMark(
          x: .value("Day", sessionData.dayName),
          y: .value("Count", sessionData.count))
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
  }
}
