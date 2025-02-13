//
//  Image+Extension.swift
//
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import SwiftUI

extension Image {
  public func resizedToFit(_ size: Double) -> some View {
    resizable()
      .frame(width: size, height: size)
  }
}
