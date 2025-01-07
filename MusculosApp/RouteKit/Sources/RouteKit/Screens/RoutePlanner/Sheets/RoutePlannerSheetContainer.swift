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
}

// MARK: - RoutePlannerSheetContainer

struct RoutePlannerSheetContainer: View {
  @State private var activeDetent = PresentationDetent.minimized

  @Binding var wizardStep: RoutePlannerWizardStep
  @Binding var destinationLocation: String
  @Binding var startLocation: String

  var currentLocation: CLLocation?
  var mapItemResults: [MapItemData]
  var selectedMapITem: MapItemData?
  var onSelectResult: (MapItemData) -> Void
  var onStart: () -> Void

  var body: some View {
    VStack {
      switch wizardStep {
      case .search:
        SearchLocationSheet(
          destinationLocation: $destinationLocation,
          currentLocation: currentLocation,
          mapItemResults: mapItemResults,
          selectedMapItem: selectedMapITem,
          onSelectResult: onSelectResult)
          .transition(.move(edge: .trailing))

      case .confirm:
        ConfirmRouteSheet(startLocation: $startLocation, endLocation: $destinationLocation, onStart: onStart)
          .transition(.move(edge: .leading).combined(with: .opacity))
      }
      Spacer()
    }
    .padding()
    .padding(.top, 10)
    .onChange(of: mapItemResults) { _, newValue in
      updateActiveDetentForResults(newValue)
    }
    .onChange(of: wizardStep) { _, newValue in
      updateActiveDetentForWizardStep(newValue)
    }
    .presentationDetents([.expanded, .middle, .minimized], selection: $activeDetent)
    .presentationBackgroundInteraction(.enabled)
    .presentationDragIndicator(.visible)
    .interactiveDismissDisabled()
    .animation(.easeInOut(duration: UIConstant.AnimationDuration.medium), value: wizardStep)
  }

  private func updateActiveDetentForResults(_ results: [MapItemData]) {
    activeDetent = results.isEmpty ? .minimized : .expanded
  }

  private func updateActiveDetentForWizardStep(_ step: RoutePlannerWizardStep) {
    activeDetent = step == .confirm ? .middle : .minimized
  }

  func getDistanceDisplay(_ item: MapItemData) -> String {
    guard let currentLocation else {
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
