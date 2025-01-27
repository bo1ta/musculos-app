//
//  RoutePlannerSheetContainer.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 07.01.2025.
//

import Components
import CoreLocation
import Factory
import SwiftUI
import Utility

// MARK: - RoutePlannerSheet

struct RoutePlannerSheet: View {

  enum WizardStep {
    case search
    case confirm
    case inProgress
  }

  @Namespace private var animationNamespace
  @State private var activeDetent = PresentationDetent.minimized
  @State private var currentStep = WizardStep.search

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
          .preference(
            key: BottomSheetSizePreferenceKey.self,
            value: viewModel.queryResults.isEmpty ? BottomSheetSizes.minimized : BottomSheetSizes.middle)

      case .confirm:
        ConfirmRouteSheetView(
          startLocation: $viewModel.startLocation,
          endLocation: $viewModel.endLocation,
          onStart: handleConfirmRoute)
          .transition(.move(edge: .leading).combined(with: .opacity))
          .matchedGeometryEffect(id: "sheet", in: animationNamespace)
          .task {
            await viewModel.loadCurrentLocationData()
          }
          .preference(key: BottomSheetSizePreferenceKey.self, value: BottomSheetSizes.expanded)

      case .inProgress:
        ProgressButton(elapsedTime: viewModel.elapsedTime, onClick: handleStopRunning)
          .padding(.top)
          .matchedGeometryEffect(id: "sheet", in: animationNamespace)
          .transition(.move(edge: .top).combined(with: .opacity))
          .preference(key: BottomSheetSizePreferenceKey.self, value: BottomSheetSizes.minimized)
      }
      Spacer()
    }
    .padding()
    .padding(.top, 10)
    .onChange(of: viewModel.queryResults) { _, newValue in
      updateActiveDetentForResults(newValue)
    }

    .animation(.easeInOut(duration: UIConstant.AnimationDuration.short), value: currentStep)
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
  public static let expandedExtra = PresentationDetent.fraction(0.7)
  public static let middle = PresentationDetent.fraction(0.3)
}
