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
  
  private var imageView: UIImageView?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let imageView = UIImageView(gifURL: url)
    imageView.contentMode = .scaleAspectFill
    imageView.frame = bounds
    self.addSubview(imageView)
    self.imageView = imageView
  }
  
  func refreshGIF() {
    guard let imageView else { return }
    imageView.setGifFromURL(url)
  }
}
