//
//  SearchLocationSheet.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 06.01.2025.
//

import Components
import CoreLocation
import SwiftUI
import Utility

struct SearchLocationSheet: View {
  private typealias PresentationState = UIConstant.PresentationDetentState

  @State private var activeDetent: PresentationDetent = PresentationState.minimized

  @Binding var destinationLocation: String
  var currentLocation: CLLocation?
  var mapItemResults: [MapItemData]
  var onSelectResult: (MapItemData) -> Void

  var body: some View {
    VStack(spacing: 20) {
      FormField(text: $destinationLocation, textHint: "Search for location", imageIcon: Image("search-icon"))
        .padding(.top)

      if !mapItemResults.isEmpty {
        ForEach(mapItemResults, id: \.identifier) { item in
          Button(
            action: { onSelectResult(item) },
            label: {
              DetailCard(text: item.name, content: { Text(getDistanceDisplay(item)) })
            })
        }
      }
      Spacer()
    }
    .padding(.horizontal)
    .onChange(of: mapItemResults, { _, newValue in
      updateActiveDetentForResults(newValue)
    })
    .presentationDetents([.fraction(0.1), .fraction(0.5)], selection: $activeDetent)
    .presentationBackgroundInteraction(.enabled)
    .presentationDragIndicator(.visible)
    .interactiveDismissDisabled()
  }

  private func updateActiveDetentForResults(_ results: [MapItemData]) {
    activeDetent = results.isEmpty ? PresentationState.minimized : PresentationState.expanded
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
