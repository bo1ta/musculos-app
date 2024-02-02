//
//  HorizontalPicker.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.07.2023.
//

import SwiftUI

struct HorizontalPicker: UIViewControllerRepresentable {
  @Binding var selectedOption: String

  func makeUIViewController(context: Context) -> HorizontalPickerViewController {
    let viewController = HorizontalPickerViewController()
    viewController.selectionDidChange = { selectedOption in
      self.selectedOption = selectedOption
    }
    return viewController
  }

  func updateUIViewController(_ uiViewController: HorizontalPickerViewController, context: Context) {
    // No need to update the selection here
  }
}
