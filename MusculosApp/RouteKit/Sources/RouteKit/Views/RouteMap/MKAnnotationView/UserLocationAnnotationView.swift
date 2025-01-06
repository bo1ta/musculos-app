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

    NSLayoutConstraint.activate([
      arrowImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      arrowImageView.widthAnchor.constraint(equalToConstant: 24),
      arrowImageView.heightAnchor.constraint(equalTo: arrowImageView.widthAnchor),
    ])
  }
}
