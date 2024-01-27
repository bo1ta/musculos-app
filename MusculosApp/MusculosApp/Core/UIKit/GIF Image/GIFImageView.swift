//
//  GIFImageView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.01.2024.
//

import Foundation
import UIKit

class GIFImageView: UIView {
  private var url: URL
  
  init(url: URL) {
    self.url = url
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var imageView = {
    let imageView = UIImageView(gifURL: url)
    imageView.contentMode = .scaleAspectFill
    imageView.frame = bounds
    return imageView
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.addSubview(imageView)
  }
}
