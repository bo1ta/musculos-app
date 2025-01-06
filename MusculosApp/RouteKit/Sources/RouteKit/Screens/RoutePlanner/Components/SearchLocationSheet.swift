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
  @Binding var destinationLocation: String

  var currentLocation: CLLocation?
  var mapItemResults: [MapItemResult]
  var onSelectResult: (MapItemResult) -> Void

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
    }
    .padding(.horizontal)
    .presentationDetents([.fraction(0.1), .fraction(0.5)])
    .presentationBackgroundInteraction(.enabled)
    .presentationDragIndicator(.visible)
    .interactiveDismissDisabled()
  }

  func getDistanceDisplay(_ item: MapItemResult) -> String {
    guard let currentLocation else {
      return ""
    }

    let distanceInKM = currentLocation
      .distance(from: item.placemark.coordinate.toCLLocation())
      .inKilometers()
    return String(format: "%.2f km", distanceInKM)
  }
}
