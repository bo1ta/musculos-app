//
//  ConfirmRouteSheet.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 06.01.2025.
//

import Components
import SwiftUI
import Utility

struct ConfirmRouteSheetView: View {
  @Binding var startLocation: String
  @Binding var endLocation: String
  var destinationData: MapItemData?

  var onStart: () -> Void
  var onBack: () -> Void

  var body: some View {
    VStack(spacing: 10) {
      HStack {
        BackRectButton(onBack: onBack)
        Spacer()
      }
      FormField(text: $startLocation, label: "Start location")
      FormField(text: $endLocation, label: "Destination")

      if let destinationData {
        Text(destinationData.getDistanceDisplay())
          .font(.body(.light, size: 14.0))
          .foregroundStyle(.gray)
          .opacity(0.9)
      }
      PrimaryButton(title: "Start exercise", action: onStart)
    }
  }
}
