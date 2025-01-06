//
//  ConfirmRouteSheet.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 06.01.2025.
//

import Components
import SwiftUI
import Utility

struct ConfirmRouteSheet: View {
  @Binding var startLocation: String
  @Binding var endLocation: String

  var onStart: () -> Void

  var body: some View {
    VStack(spacing: 20) {
      FormField(text: $startLocation, label: "Start location")
      FormField(text: $endLocation, label: "Destination")
      PrimaryButton(title: "Start exercise", action: onStart)
    }
  }
}
