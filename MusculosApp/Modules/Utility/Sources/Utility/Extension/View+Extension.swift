//
//  View+Extension.swift
//  Utility
//
//  Created by Solomon Alexandru on 28.01.2025.
//

import SwiftUI

extension View {
  public func tabBarHidden() -> some View {
    toolbar(.hidden, for: .tabBar)
  }
}
