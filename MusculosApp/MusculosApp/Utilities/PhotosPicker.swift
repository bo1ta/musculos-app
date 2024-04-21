//
//  PhotosPicker.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.04.2024.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI

struct PhotosPicker: UIViewControllerRepresentable {
  @Binding var assets: [PickedPhoto]
  
  func makeUIViewController(context: Context) -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.filter = .images
    config.selectionLimit = 3
    
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
}

// MARK: - Coordinator

extension PhotosPicker {
  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    var parent: PhotosPicker
    
    init(_ parent: PhotosPicker) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)
      
      results
        .compactMap { $0.itemProvider }
        .filter { $0.canLoadObject(ofClass: UIImage.self) }
        .forEach { provider in
          provider.loadObject(ofClass: UIImage.self) { image, error in
            guard let image = image as? UIImage, error == nil else {
              MusculosLogger.logError(error ?? MusculosError.notFound, message: "Could not load picker photos.", category: .ui)
              return
            }
            
            self.parent.assets.append(PickedPhoto(image: image))
          }
        }
      MusculosLogger.logInfo(message: "Finished loading images", category: .ui)
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

// MARK: - Helpers

extension PhotosPicker {
  struct PickedPhoto: Identifiable {
    let id: UUID
    let image: UIImage
    
    init(id: UUID = UUID(), image: UIImage) {
      self.id = id
      self.image = image
    }
  }
}
