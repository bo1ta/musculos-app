//
//  Navigator+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.01.2025.
//

import Navigator

extension Navigator {
  @MainActor
  func popOrDismiss() {
    if self.isPresented {
      self.dismiss()
    } else {
      self.pop()
    }
  }
}
