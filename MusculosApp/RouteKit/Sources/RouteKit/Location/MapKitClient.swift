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

  // MARK: Public

  public func getLocationsByQuery(_ query: String, on region: MKCoordinateRegion) async throws -> [MapItemResult] {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    request.region = region
    request.pointOfInterestFilter = MKPointOfInterestFilter(including: getPointOfInterestCategories())

    if #available(iOS 18.0, *) {
      request.regionPriority = .required
    }

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

  public func getDirections(
    from source: CLLocationCoordinate2D,
    to destination: CLLocationCoordinate2D)
    async throws -> MKDirections.Response
  {
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
    request.transportType = .walking

    let directions = MKDirections(request: request)
    return try await directions.calculate()
  }

  // MARK: Private

  private func getPointOfInterestCategories() -> [MKPointOfInterestCategory] {
    var types: [MKPointOfInterestCategory] = [.park, .beach, .campground, .school, .fitnessCenter]

    if #available(iOS 18.0, *) {
      types.append(.tennis)
      types.append(.golf)
    }
    return types
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
        pointOfInterestCategory: item.pointOfInterestCategory,
        isCurrentLocation: item.isCurrentLocation)
    }
  }
}

// MARK: - MKDirections.Response + @unchecked Sendable

extension MKDirections.Response: @unchecked Sendable { }
