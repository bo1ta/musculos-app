//
//  RoutePlannerScreen.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 31.12.2024.
//

import Components
import CoreLocation
import SwiftUI
import Utility

public struct RoutePlannerScreen: View {
  @State private var averagePace: Double = 0
  @State private var showRouteForm = true
  @State private var startLocation = ""
  @State private var endLocation = ""
  @State private var currentLocation: CLLocation?
  public var body: some View {
    ZStack(alignment: .bottom) {
      RouteView(currentLocation: $currentLocation, averagePace: $averagePace)

      RoundedRectangle(cornerRadius: 14)
        .fill(Color.white)
        .frame(height: 200)
        .padding(20)
        .overlay(
          VStack(spacing: 20) {
            FormField(text: $startLocation, textHint: "Start location")
            FormField(text: $endLocation, textHint: "End location")
            PrimaryButton(title: "Plan route", action: planRoute)
          }
          .padding(.horizontal, 40))
        .opacity(showRouteForm ? 1 : 0)
    }
    .ignoresSafeArea()
  }

  private func planRoute() { }
}

#Preview {
  RoutePlannerScreen()
}
