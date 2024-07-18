//
//  AnatomyOverlayView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.09.2023.
//

import SwiftUI
import CoreData

struct AnatomyOverlayView: View {
  var musclesIds: [Int]
  var customSize: CGFloat
  var isFront: Bool

  init(musclesIds: [Int], isFront: Bool = true, customSize: CGFloat = 150) {
    self.musclesIds = musclesIds
    self.isFront = isFront
    self.customSize = customSize
  }

  var body: some View {
    ZStack {
      isFront ? Image("muscular_system_front")
        .resizable()
        : Image("muscular_system_back")
        .resizable()

      ForEach(0..<self.musclesIds.count, id: \.hashValue) { muscleId in
        self.muscleImage(with: self.musclesIds[muscleId])
          .resizable()
      }.id(musclesIds)

    }
    .frame(maxWidth: customSize, maxHeight: customSize * 2)
  }

  func muscleImage(with id: Int) -> Image {
    let assetName = "muscle-\(id)"
    return Image(assetName)
  }
}

#Preview {
  AnatomyOverlayView(musclesIds: [2, 4, 5])
}
