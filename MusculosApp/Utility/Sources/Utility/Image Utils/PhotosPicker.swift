//
//  PhotosPicker.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.04.2024.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

public struct PhotosPicker: UIViewControllerRepresentable {
  @Binding var assets: [PhotoModel]

  public init(assets: Binding<[PhotoModel]>) {
    _assets = assets
  }

  public func makeUIViewController(context: Context) -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.filter = .images
    config.selectionLimit = 3

    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }

  public func updateUIViewController(_: PHPickerViewController, context _: Context) {}
}

// MARK: - Coordinator

public extension PhotosPicker {
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

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
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

public struct PhotoModel: Identifiable {
  public let id: UUID
  public let image: UIImage

  public init(id: UUID = UUID(), image: UIImage) {
    self.id = id
    self.image = image
  }
}
