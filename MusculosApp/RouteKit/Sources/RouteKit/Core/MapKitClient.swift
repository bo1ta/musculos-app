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

public struct MapKitClient: Sendable {

  // MARK: Private

  private static let supportedInterestCategories: [MKPointOfInterestCategory] = {
    var categories: [MKPointOfInterestCategory] = [.park, .beach, .campground, .school, .fitnessCenter]
    if #available(iOS 18.0, *) {
      categories.append(.tennis)
      categories.append(.golf)
    }
    return categories
  }()

  // MARK: Public

  public func getLocationsByQuery(_ query: String, on region: MKCoordinateRegion) async throws -> [MapItemData] {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    request.region = region
    request.pointOfInterestFilter = MKPointOfInterestFilter(including: Self.supportedInterestCategories)

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

        let results = response.mapItems.compactMap { item -> MapItemData? in
          guard let name = item.name else {
            return nil
          }
          return MapItemData(
            identifier: UUID(),
            name: name,
            placemark: item.placemark,
            pointOfInterestCategory: item.pointOfInterestCategory,
            isCurrentLocation: item.isCurrentLocation)
        }
        continuation.resume(returning: results)
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

  public func getLocationDetails(_ location: CLLocation) async throws -> [CLPlacemark] {
    return try await CLGeocoder().reverseGeocodeLocation(location)
  }
}

// MARK: - MKDirections.Response + @unchecked Sendable

extension MKDirections.Response: @unchecked Sendable { }
