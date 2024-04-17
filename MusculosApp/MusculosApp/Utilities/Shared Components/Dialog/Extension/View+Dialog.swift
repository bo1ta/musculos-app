//
//  View+Dialog.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.04.2024.
//

import Foundation
import SwiftUI

enum DialogStyle {
  case `default`, select
}

extension View {
  func dialog(
    style: DialogStyle = .default,
    title: String,
    buttonTitle: String,
    isPresented: Binding<Bool>,
    onSelectedValue: ((Int) -> Void)? = nil
  ) -> some View {
    fullScreenCover(isPresented: isPresented) {
      if let onSelectedValue, style == .select {
        if #available(iOS 16.4, *) {
          DialogSelectView(title: title, buttonTitle: buttonTitle, isPresented: isPresented, onSelectedValue: onSelectedValue)
            .presentationBackground(.clear)
        } else {
          DialogSelectView(title: title, buttonTitle: buttonTitle, isPresented: isPresented, onSelectedValue: onSelectedValue)
        }
      } else {
        if #available(iOS 16.4, *) {
          DialogView(title: title, buttonTitle: buttonTitle, isPresented: isPresented)
            .presentationBackground(.clear)
        } else {
          DialogView(title: title, buttonTitle: buttonTitle, isPresented: isPresented)
        }
      }
    }
  }
}
