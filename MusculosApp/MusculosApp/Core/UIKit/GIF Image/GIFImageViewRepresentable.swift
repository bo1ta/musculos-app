//
//  GIFImageViewRepresentable.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 24.09.2023.
//

import Foundation
import SwiftUI
import SwiftyGif

enum URLType {
  case name(String)
  case url(URL)

  var url: URL! {
    switch self {
    case .name(let name):
      return Bundle.main.url(forResource: name, withExtension: "gif")
    case .url(let remoteURL):
      return remoteURL
    }
  }
}

struct GIFImageViewRepresentable: UIViewRepresentable {
  private let urlType: URLType
  private let resize: CGSize?
  
  private var gifImageView: GIFImageView? = nil
  
  init(urlType: URLType, resize: CGSize? = nil) {
    self.urlType = urlType
    self.resize = resize
  }

  func makeUIView(context: Context) -> GIFImageView {
    return GIFImageView(url: urlType.url)
  }

  func updateUIView(_ uiView: GIFImageView, context: Context) {
    uiView.refreshGIF()
  }
}
