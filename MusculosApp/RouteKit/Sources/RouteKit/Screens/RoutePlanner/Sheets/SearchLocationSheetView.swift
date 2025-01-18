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

struct SearchLocationSheetView: View {
  @Binding var destinationLocation: String
  var currentLocation: CLLocation?
  var mapItemResults: [MapItemData]
  var selectedMapItem: MapItemData?
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
              DetailCard(
                text: item.name,
                font: AppFont.body(.regular, size: 14.0),
                isSelected: item == selectedMapItem,
                content: { Text(getDistanceDisplay(item)) })
            })
        }
      }
    }
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
