//
//  SelectWeightSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.12.2024.
//

import Components
import SwiftUI
import Utility

struct SelectWeightSheet: View {
  @Environment(\.dismiss) private var dismiss

  @Binding var weight: Double
  var onSubmit: () -> Void

  var body: some View {
    VStack {
      Text("Select a weight")
        .foregroundStyle(.black)
        .font(AppFont.spartan(.bold, size: 26))

      Slider(
        value: Binding(
          get: { weight },
          set: { weight = roundWeight($0) }
        ),
        in: 0 ... 150
      )
      .padding(.vertical)
      .tint(.red)

      Text(String(format: "%.1f", weight))
        .foregroundStyle(.red)
        .font(AppFont.poppins(.bold, size: 27))

      PrimaryButton(title: "Submit", action: {
        onSubmit()
        dismiss()
      })
    }
    .padding()
  }

  /// Round the weight to the nearest multiple of 0.5.
  /// E.g. 1.0, 1.5, 2.0
  ///
  private func roundWeight(_ weight: Double) -> Double {
    return (weight * 2).rounded() / 2
  }
}

#Preview {
  SelectWeightSheet(weight: .constant(40), onSubmit: {})
}
