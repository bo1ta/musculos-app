//
//  View+Toast.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI

extension View {
  func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastViewModifier(toast: toast))
  }
}
