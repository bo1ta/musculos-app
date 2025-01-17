//
//  RoutePlannerSheetContainer.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 07.01.2025.
//

import Components
import CoreLocation
import SwiftUI
import Utility

// MARK: - RoutePlannerWizardStep

enum RoutePlannerWizardStep {
  case search
  case confirm
  case inProgress
}

// MARK: - RoutePlannerSheetContainer

struct RoutePlannerSheetContainer: View {
  @State private var activeDetent = PresentationDetent.minimized

  var viewModel: RoutePlannerViewModel
  var onStart: () -> Void

  var body: some View {
    @Bindable var viewModel = viewModel

    VStack {
      switch viewModel.wizardStep {
      case .search:
        SearchLocationSheet(
          destinationLocation: $viewModel.queryLocation,
          currentLocation: viewModel.currentLocation,
          mapItemResults: viewModel.queryResults,
          selectedMapItem: viewModel.destinationMapItem,
          onSelectResult: viewModel.setRouteForItem(_:))
          .transition(.move(edge: .trailing))

      case .confirm:
        ConfirmRouteSheet(
          startLocation: $viewModel.startLocation,
          endLocation: $viewModel.endLocation,
          onStart: viewModel.startRunning)
          .transition(.move(edge: .leading).combined(with: .opacity))
          .task {
            await viewModel.loadCurrentLocationData()
          }

      case .inProgress:
        ProgressButton(elapsedTime: viewModel.elapsedTime, onClick: viewModel.stopRunning)
          .padding(.top)
      }
      Spacer()
    }
    .padding()
    .padding(.top, 10)
    .onChange(of: viewModel.queryResults) { _, newValue in
      updateActiveDetentForResults(newValue)
    }
    .onChange(of: viewModel.wizardStep) { _, newValue in
      updateActiveDetentForWizardStep(newValue)
    }
    .presentationDetents([.expanded, .middle, .minimized], selection: $activeDetent)
    .presentationBackgroundInteraction(.enabled)
    .presentationDragIndicator(.visible)
    .interactiveDismissDisabled()
    .animation(.easeInOut(duration: UIConstant.AnimationDuration.medium), value: viewModel.wizardStep)
  }

  private func updateActiveDetentForResults(_ results: [MapItemData]) {
    activeDetent = results.isEmpty ? .minimized : .expanded
  }

  private func updateActiveDetentForWizardStep(_ step: RoutePlannerWizardStep) {
    activeDetent = step == .confirm ? .middle : .minimized
  }

  func getDistanceDisplay(_ item: MapItemData) -> String {
    guard let currentLocation = viewModel.currentLocation else {
      return ""
    }

    let distanceInKM = currentLocation
      .distance(from: item.placemark.coordinate.toCLLocation())
      .inKilometers()
    return String(format: "%.2f km", distanceInKM)
  }
}

extension PresentationDetent {
  public static let minimized = PresentationDetent.fraction(0.1)
  public static let expanded = PresentationDetent.fraction(0.5)
  public static let middle = PresentationDetent.fraction(0.3)
}
