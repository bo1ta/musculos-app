//
//  MuscleChartSection.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.03.2024.
//

import SwiftUI
import Charts

struct MuscleChartSection: View {
  let xLabel: String = "Type"
  let yLabel: String = "Completed"
  
    var body: some View {
      return HStack {
        VStack(alignment: .leading) {
          Text("Completed exercise by muscles this week")
            .font(.header(.medium, size: 18))
          Chart {
              BarMark(x: .value(xLabel, "chest"), y: .value(yLabel, 2))
                .foregroundStyle(.blue)
                .cornerRadius(10)
              
              BarMark(x: .value(xLabel, "back"), y: .value(yLabel, 10))
                .foregroundStyle(.red)
                .cornerRadius(10)
              
              BarMark(x: .value(xLabel, "legs"), y: .value(yLabel, 2))
                .foregroundStyle(.orange)
                .cornerRadius(10)
              
              BarMark(x: .value(xLabel, "biceps"), y: .value(yLabel, 2))
                .foregroundStyle(.green)
                .cornerRadius(10)
              
              BarMark(x: .value(xLabel, "triceps"), y: .value(yLabel, 10))
                .foregroundStyle(.black)
                .cornerRadius(10)
              
              BarMark(x: .value(xLabel, "shoulder"), y: .value(yLabel, 2))
                .foregroundStyle(.purple)
                .cornerRadius(10)
          }
          .frame(height: 200)
        }
        Spacer()
      }
      .padding(.leading, 20)
    }
}

#Preview {
    MuscleChartSection()
}
