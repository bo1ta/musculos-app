//
//  MapKitClient.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 03.01.2025.
//

import Foundation
import MapKit
import Utility

// MARK: - MapKitClient

public class MapKitClient {
  @MainActor
  public func getLocationsByQuery(_: String, on region: MKCoordinateRegion) async throws -> [MapItemResult] {
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

  private func mapItemsToResults(_ items: [MKMapItem]) -> [MapItemResult] {
    items.compactMap { item in
      guard let name = item.name else {
        return nil
      }
      return MapItemResult(
        identifier: UUID(),
        name: name,
        placemark: item.placemark,
        pointOfInterestCategory: item.pointOfInterestCategory)
    }
  }
}

// MARK: - MapItemResult

public struct MapItemResult: Sendable {
  var identifier: UUID
  var name: String
  var placemark: MKPlacemark
  var pointOfInterestCategory: MKPointOfInterestCategory?
}
