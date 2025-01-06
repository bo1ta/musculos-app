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
      RouteMap(
        currentLocation: $viewModel.currentLocation,
        averagePace: $viewModel.averagePace,
        mapItemResults: $viewModel.mapItemResults,
        currentRoute: $viewModel.currentRoute)
    }
    .sheet(isPresented: .constant(true)) {
      SearchLocationSheet(
        destinationLocation: $viewModel.endLocation,
        currentLocation: viewModel.currentLocation,
        mapItemResults: viewModel.mapItemResults,
        onSelectResult: viewModel.setRouteForItem(_:))
    }
    .ignoresSafeArea()
    .onDisappear(perform: viewModel.onDisappear)
  }
}

#Preview {
  RoutePlannerScreen()
}
