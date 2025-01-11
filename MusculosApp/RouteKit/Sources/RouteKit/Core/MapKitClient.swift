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
          return MapItemData(item)
        }
        continuation.resume(returning: results)
      }
    }
  }

  public func getLocationDetails(_ location: CLLocation) async throws -> MapItemData? {
    let geocoder = CLGeocoder()
    let placemarks = try await geocoder.reverseGeocodeLocation(location)

    guard let firstPlacemark = placemarks.first else {
      return nil
    }

    return try MapItemData(firstPlacemark)
  }

  public func getDirections(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) async throws -> DirectionData {
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
    request.transportType = .walking

    let directions = MKDirections(request: request)
    let response = try await directions.calculate()
    let etaResponse = try await directions.calculateETA()

    return DirectionData(
      routes: response.routes,
      expectedArrivalDate: etaResponse.expectedArrivalDate,
      expectedTravelTime: etaResponse.expectedTravelTime,
      distance: etaResponse.distance,
      originCoordinates: etaResponse.source.placemark.coordinate,
      destinationCoordinates: etaResponse.destination.placemark.coordinate
    )
  }
}

// MARK: - MKDirections.Response + @unchecked Sendable

extension MKDirections.Response: @unchecked Sendable { }

extension MKDirections.ETAResponse: @unchecked Sendable { }

public struct DirectionData: @unchecked Sendable {
  var routes: [MKRoute]
  var expectedArrivalDate: Date
  var expectedTravelTime: TimeInterval
  var distance: CLLocationDistance
  var originCoordinates: CLLocationCoordinate2D
  var destinationCoordinates: CLLocationCoordinate2D
}
