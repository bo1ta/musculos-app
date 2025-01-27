//
//  MapItemData.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 04.01.2025.
//

import Foundation
import MapKit
import UIKit
import Utility

// MARK: - MapItemData

public struct MapItemData: Sendable {
  var identifier: UUID
  var name: String
  var placemark: MKPlacemark
  var category: Category
  var isCurrentLocation: Bool?

  init(
    identifier: UUID,
    name: String,
    placemark: MKPlacemark,
    pointOfInterestCategory: MKPointOfInterestCategory? = nil,
    isCurrentLocation: Bool? = nil)
  {
    self.identifier = identifier
    self.name = name
    self.placemark = placemark
    self.category = Category.categoryFromPointOfInterest(pointOfInterestCategory)
    self.isCurrentLocation = isCurrentLocation
  }

  init?(_ mapItem: MKMapItem) {
    guard let name = mapItem.name else {
      return nil
    }
    self.name = name
    identifier = UUID()
    placemark = mapItem.placemark
    category = Category.categoryFromPointOfInterest(mapItem.pointOfInterestCategory)
    isCurrentLocation = mapItem.isCurrentLocation
  }

  init(_ clPlacemark: CLPlacemark) throws {
    identifier = UUID()
    category = .general
    name = clPlacemark.name ?? ""

    guard let coordinate = clPlacemark.location?.coordinate else {
      throw MusculosError.unexpectedNil
    }
    placemark = MKPlacemark(coordinate: coordinate)
  }

  /// Returns the distance display in km. E.g `1.2 km`.
  /// Uses the shared instance of the `LocationManager` for the currentLocation
  /// Kinda hacky...but also kinda convenient
  ///
  func getDistanceDisplay() -> String {
    guard let currentLocation = RouteKitContainer.shared.locationManager().currentLocation else {
      return "0 km"
    }
    let distanceInKM = currentLocation
      .distance(from: placemark.coordinate.toCLLocation())
      .inKilometers()
    return String(format: "%.2f km", distanceInKM)
  }
}

// MARK: MapItemData.Category

extension MapItemData {
  enum Category {
    case general
    case park
    case beach
    case campground
    case tennis
    case fitnessCenter
    case golf
    case school

    var systemImageName: String {
      switch self {
      case .park:
        "leaf.fill"
      case .beach:
        "sun.max.fill"
      case .campground:
        "tent.fill"
      case .fitnessCenter:
        "figure.run.circle.fill"
      case .tennis:
        "sportscourt.fill"
      case .golf:
        "flag.fill"
      default:
        "mappin"
      }
    }

    var colorRepresentation: UIColor {
      switch self {
      case .general, .school:
        .blue
      case .park, .tennis, .golf:
        .green
      case .beach:
        .yellow
      case .campground:
        .brown
      case .fitnessCenter:
        .purple
      }
    }

    static func categoryFromPointOfInterest(
      _ pointOfInterestCategory: MKPointOfInterestCategory?)
      -> Category
    {
      guard let pointOfInterestCategory else {
        return .general
      }

      switch pointOfInterestCategory {
      case .park, .nationalPark:
        return .park
      case .beach:
        return .beach
      case .campground:
        return .campground
      case .fitnessCenter:
        return .fitnessCenter
      case .school:
        return .school
      default:
        if #available(iOS 18.0, *) {
          switch pointOfInterestCategory {
          case .tennis: return .tennis
          case .golf: return .golf
          default: break
          }
        }
        return .general
      }
    }
  }
}

// MARK: Equatable

extension MapItemData: Equatable {
  public static func ==(_ lhs: MapItemData, rhs: MapItemData) -> Bool {
    lhs.identifier == rhs.identifier
  }
}
