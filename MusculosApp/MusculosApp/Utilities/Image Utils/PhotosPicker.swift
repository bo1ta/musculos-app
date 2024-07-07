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
  @Binding var assets: [PhotoModel]
  
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
    
    var pickerTask: Task<Void, Never>?
    
    init(_ parent: PhotosPicker) {
      self.parent = parent
    }
    
    deinit {
      pickerTask?.cancel()
      pickerTask = nil
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      pickerTask = Task { @MainActor in
        let imageStream = imageStreamFrom(results: results)
        
        for await image in imageStream {
          self.parent.assets.append(PhotoModel(image: image))
        }
        
        picker.dismiss(animated: true)
      }
    }
    
    func imageStreamFrom(results: [PHPickerResult]) -> AsyncStream<UIImage> {
      return AsyncStream(UIImage.self) { continuation in
        let totalResults = results.count
        
        for (index, result) in results.enumerated() {
          let itemProvider = result.itemProvider
          
          if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
              if let image = image as? UIImage {
                continuation.yield(image)
              } else {
                if error != nil {
                  continuation.finish()
                  return
                }
              }
              
              if index == totalResults - 1 {
                continuation.finish()
              }
            }
          }
        }
      }
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

// MARK: - Helpers

struct PhotoModel: Identifiable {
  let id: UUID
  let image: UIImage
  
  init(id: UUID = UUID(), image: UIImage) {
    self.id = id
    self.image = image
  }
}
