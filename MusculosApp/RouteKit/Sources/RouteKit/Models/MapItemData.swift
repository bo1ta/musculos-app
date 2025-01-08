//
//  MapItemData.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 04.01.2025.
//

import Foundation
import MapKit
import UIKit

// MARK: - MapItemData

public struct MapItemData: Sendable {
  var identifier: UUID
  var name: String
  var placemark: MKPlacemark
  var category: Category
  var isCurrentLocation: Bool

  init(
    identifier: UUID,
    name: String,
    placemark: MKPlacemark,
    pointOfInterestCategory: MKPointOfInterestCategory? = nil,
    isCurrentLocation: Bool)
  {
    self.identifier = identifier
    self.name = name
    self.placemark = placemark
    self.category = Category.categoryFromPointOfInterest(pointOfInterestCategory)
    self.isCurrentLocation = isCurrentLocation
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
