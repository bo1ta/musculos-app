//
//  RouteMapAnnotationView.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 04.01.2025.
//

import Foundation
import MapKit
import UIKit

class RouteMapAnnotationView: MKAnnotationView {
  static let reuseIdentifier = "RouteMapAnnotationView"

  private lazy var circleView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 20
    view.backgroundColor = .systemPurple
    return view
  }()

  private lazy var glyphImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(systemName: "arrow.2.circlepath")
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .white
    return imageView
  }()

  override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setupViews()
  }

  private func setupViews() {
    addSubview(circleView)
    addSubview(glyphImageView)

    NSLayoutConstraint.activate([
      circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
      circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
      circleView.widthAnchor.constraint(equalToConstant: 40),
      circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor),

      glyphImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
      glyphImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
      glyphImageView.widthAnchor.constraint(equalTo: circleView.widthAnchor, multiplier: 0.6),
      glyphImageView.heightAnchor.constraint(equalTo: glyphImageView.widthAnchor),
    ])
  }
}
