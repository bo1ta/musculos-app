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

@MainActor
public struct MapKitClient {
  public func getLocationsByQuery(_: String, on region: MKCoordinateRegion) async throws -> [MapItemResult] {
    let request = MKLocalPointsOfInterestRequest(coordinateRegion: region)
    let localSearch = MKLocalSearch(request: request)

    return try await withCheckedThrowingContinuation { continuation in
      localSearch.start { response, error in
        guard error == nil else {
          continuation.resume(throwing: error ?? MusculosError.unknownError)
          return
        }

        guard let response else {
          continuation.resume(throwing: MusculosError.unexpectedNil)
          return
        }

        continuation.resume(returning: self.mapItemsToResults(response.mapItems))
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
