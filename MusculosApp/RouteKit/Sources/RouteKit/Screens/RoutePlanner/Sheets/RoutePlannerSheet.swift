//
//  RoutePlannerSheetContainer.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 07.01.2025.
//

import Components
import Factory
import CoreLocation
import SwiftUI
import Utility

// MARK: - RoutePlannerSheetContainer

struct RoutePlannerSheet: View {

  enum WizardStep {
    case search
    case confirm
    case inProgress
  }

  @State private var activeDetent = PresentationDetent.minimized
  @State private var currentStep: WizardStep = .search

  var viewModel: RoutePlannerViewModel

  var body: some View {
    @Bindable var viewModel = viewModel

    VStack {
      switch currentStep {
      case .search:
        SearchLocationSheetView(
          destinationLocation: $viewModel.queryLocation,
          currentLocation: viewModel.currentLocation,
          mapItemResults: viewModel.queryResults,
          selectedMapItem: viewModel.destinationMapItem,
          onSelectResult: handleSelectSearchResult(_:))
          .transition(.move(edge: .trailing))

      case .confirm:
        ConfirmRouteSheetView(
          startLocation: $viewModel.startLocation,
          endLocation: $viewModel.endLocation,
          onStart: handleConfirmRoute)
          .transition(.move(edge: .leading).combined(with: .opacity))
          .task {
            await viewModel.loadCurrentLocationData()
          }

      case .inProgress:
        ProgressButton(elapsedTime: viewModel.elapsedTime, onClick: handleStopRunning)
          .padding(.top)
      }
      Spacer()
    }
    .padding()
    .padding(.top, 10)
    .onChange(of: viewModel.queryResults) { _, newValue in
      updateActiveDetentForResults(newValue)
    }
    .presentationDetents([.expanded, .middle, .minimized], selection: $activeDetent)
    .presentationBackgroundInteraction(.enabled)
    .presentationDragIndicator(.visible)
    .interactiveDismissDisabled()
    .animation(.easeInOut(duration: UIConstant.AnimationDuration.medium), value: currentStep)
  }

  private func updateActiveDetentForResults(_ results: [MapItemData]) {
    activeDetent = results.isEmpty ? .minimized : .expanded
  }

  private func updateActiveDetentForWizardStep(_ step: WizardStep) {
    activeDetent = step == .confirm ? .middle : .minimized
  }

  private func handleSelectSearchResult(_ result: MapItemData) {
    currentStep = .confirm
    updateActiveDetentForWizardStep(.confirm)
    viewModel.setRouteForItem(result)
  }

  private func handleConfirmRoute() {
    currentStep = .inProgress
    updateActiveDetentForWizardStep(.inProgress)
    viewModel.startRunning()
  }

  private func handleStopRunning() {
    currentStep = .search
    updateActiveDetentForWizardStep(.search)
    viewModel.stopRunning()
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
