//
//  MarkerAnnotationView.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 04.01.2025.
//

import Foundation
import MapKit
import UIKit

class MarkerAnnotationView: MKMarkerAnnotationView {
  static let reuseIdentifier = "RouteMapAnnotationView"

  override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  func configure(for category: MapItemData.Category) {
    glyphImage = UIImage(systemName: category.systemImageName)

    markerTintColor = category.colorRepresentation
    displayPriority = .required
  }
}
