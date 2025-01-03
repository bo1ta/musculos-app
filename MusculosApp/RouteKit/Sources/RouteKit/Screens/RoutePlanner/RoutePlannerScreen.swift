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
  @State private var viewModel = RoutePlannerViewModel()

  public init() { }

  public var body: some View {
    ZStack(alignment: .bottom) {
      RouteView(currentLocation: $viewModel.currentLocation, averagePace: $viewModel.averagePace)
    }
    .sheet(isPresented: .constant(true)) {
      VStack(spacing: 20) {
        FormField(text: $viewModel.endLocation, textHint: "Search for location", imageIcon: Image("search-icon"))
          .padding(.top)
      }
      .padding(.horizontal)
      .presentationDetents([.fraction(0.1), .fraction(0.5)])
      .presentationBackgroundInteraction(.enabled)
      .presentationDragIndicator(.visible)
      .interactiveDismissDisabled()
    }
    .ignoresSafeArea()
    .onDisappear(perform: viewModel.onDisappear)
  }

  private func planRoute() { }
}

#Preview {
  RoutePlannerScreen()
}
