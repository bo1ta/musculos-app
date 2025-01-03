//
//  MapKitClient.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 03.01.2025.
//

import MapKit
import Foundation
import Utility

public class MapKitClient {
  @MainActor
  public func getLocationsByQuery(_ query: String, on region: MKCoordinateRegion) async throws -> [MapResultItem] {
    let request = MKLocalPointsOfInterestRequest(coordinateRegion: region)
    let localSearch = MKLocalSearch(request: request)

    return try await withCheckedThrowingContinuation { continuation in
      localSearch.start { [weak self] response, error in
        guard let self, error == nil else {
          continuation.resume(throwing: error ?? MusculosError.unknownError)
          return
        }

        guard let response else {
          continuation.resume(throwing: MusculosError.unexpectedNil)
          return
        }

        continuation.resume(returning: mapItemsToResults(response.mapItems))
      }
    }
  }

  private func mapItemsToResults(_ items: [MKMapItem]) -> [MapResultItem] {
    items.compactMap { item in
      guard let name = item.name else {
        return nil
      }
      return MapResultItem(identifier: UUID(), name: name, placemark: item.placemark, pointOfInterestCategory: item.pointOfInterestCategory)
    }
  }
}

public struct MapResultItem: Sendable {
  var identifier: UUID
  var name: String
  var placemark: MKPlacemark
  var pointOfInterestCategory: MKPointOfInterestCategory?
}
