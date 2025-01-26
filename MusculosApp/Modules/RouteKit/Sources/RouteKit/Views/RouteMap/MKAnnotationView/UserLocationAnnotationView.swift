//
//  UserLocationAnnotationView.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 04.01.2025.
//

import MapKit
import UIKit

class UserLocationAnnotationView: MKAnnotationView {
  static var identifier: String { "UserLocationAnnotationView" }

  private lazy var arrowImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(systemName: "location.north.fill")
    imageView.tintColor = .red
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private var arrowWidthAnchorConstraint: NSLayoutConstraint?

  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    setupView()
  }

  private func setupView() {
    addSubview(arrowImageView)

    arrowImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    arrowImageView.heightAnchor.constraint(equalTo: arrowImageView.widthAnchor).isActive = true

    arrowWidthAnchorConstraint = arrowImageView.widthAnchor.constraint(equalToConstant: 24)
    arrowWidthAnchorConstraint?.isActive = true
  }

  func updateArrowSize(_ size: Double) {
    arrowWidthAnchorConstraint = arrowImageView.widthAnchor.constraint(equalToConstant: size)
  }
}
