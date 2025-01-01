//
//  ToastViewModifier.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import SwiftUI
import Utility

public struct ToastViewModifier: ViewModifier {
  @Binding var toast: Toast?
  public func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(
        ZStack {
          if let toast {
            VStack {
              Spacer()
              ToastView(
                style: toast.style,
                message: toast.message,
                width: toast.width)
            }
            .padding(.bottom, 100)
            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .move(edge: .bottom)))
          }
        }
        .animation(.smooth(duration: UIConstant.mediumAnimationDuration), value: toast))
  }
}
