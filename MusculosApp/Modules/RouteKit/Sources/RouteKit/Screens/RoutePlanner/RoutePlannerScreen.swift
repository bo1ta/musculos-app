//
//  RoutePlannerScreen.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 31.12.2024.
//

import BottomSheet
import Components
import SwiftUI

public struct RoutePlannerScreen: View {

  @State private var viewModel = RoutePlannerViewModel()
  @State private var bottomSheetPosition = BottomSheetPosition.absolute(BottomSheetSizes.minimized)

  public init() { }

  public var body: some View {
    ZStack(alignment: .bottom) {
      RouteMap(
        currentLocation: $viewModel.currentLocation,
        averagePace: $viewModel.averagePace,
        mapItemResults: $viewModel.queryResults,
        currentRoute: $viewModel.currentRoute,
        mapCameraType: $viewModel.mapCameraType)
    }
    .bottomSheet(
      bottomSheetPosition: $bottomSheetPosition,
      switchablePositions: [
        .absolute(BottomSheetSizes.minimized),
        .absolute(BottomSheetSizes.expanded),
        .absolute(BottomSheetSizes.middle),
      ],
      content: {
        RoutePlannerSheet(viewModel: viewModel)
          .onPreferenceChange(BottomSheetSizePreferenceKey.self, perform: { [$bottomSheetPosition] bottomSheetPosition in
            $bottomSheetPosition.wrappedValue = .absolute(bottomSheetPosition)
          })
      })
    .ignoresSafeArea()
    .onDisappear(perform: viewModel.onDisappear)
  }
}

#Preview {
  RoutePlannerScreen()
}
