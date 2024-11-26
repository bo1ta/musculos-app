//
//  View+Dialog.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.04.2024.
//

import Foundation
import SwiftUI

public extension View {
  func defaultDialog(
    title: String,
    description: String? = nil,
    buttonTitle: String = "Continue",
    isPresented: Binding<Bool>
  ) -> some View {
    fullScreenCover(isPresented: isPresented) {
      DialogView(
        title: title,
        description: description,
        buttonTitle: buttonTitle,
        isPresented: isPresented
      )
      .presentationBackground(.clear)
    }
  }

  func sliderDialog(
    title: String,
    buttonTitle: String,
    isPresented: Binding<Bool>,
    onSelectedValue: @escaping (Int) -> Void
  ) -> some View {
    fullScreenCover(isPresented: isPresented) {
      DialogSelectView(
        title: title,
        buttonTitle: buttonTitle,
        isPresented: isPresented,
        onSelectedValue: onSelectedValue
      )
      .presentationBackground(.clear)
    }
  }

  func inputDialog(
    isPresented: Binding<Bool>,
    title: String,
    fieldLabel: String? = nil,
    fieldHint: String? = nil,
    fieldKeyboardType: UIKeyboardType = .default,
    buttonTitle: String = "Continue",
    onSubmit: @escaping (String) -> Void
  ) -> some View {
    fullScreenCover(isPresented: isPresented) {
      DialogFieldView(
        isPresented: isPresented,
        title: title,
        fieldLabel: fieldLabel,
        fieldHint: fieldHint,
        fieldKeyboardType: fieldKeyboardType,
        buttonTitle: buttonTitle,
        onSubmit: onSubmit
      )
      .presentationBackground(.clear)
    }
  }

  func ratingDialog(
    isPresented: Binding<Bool>,
    title: String,
    rating: Binding<Int>,
    onSave: @escaping (Int) -> Void
  ) -> some View {
    fullScreenCover(isPresented: isPresented) {
      DialogRateView(
        isPresented: isPresented,
        rating: rating,
        title: title,
        onSave: onSave
      )
      .presentationBackground(.clear)
    }
  }
}
