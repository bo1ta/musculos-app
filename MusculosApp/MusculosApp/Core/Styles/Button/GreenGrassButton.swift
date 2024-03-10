//
//  GreenGrassButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.10.2023.
//

import Foundation
import SwiftUI

struct GreenGrassButton: View {
  let action: () -> Void
  let text: String
  
  var body: some View {
    Button(action: action, label: {
      Rectangle()
        .frame(height: 50)
        .foregroundStyle(Color.AppColor.green600)
        .padding(5)
        .overlay {
          Text(text)
            .font(.body)
            .fontWeight(.heavy)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
        }
    })
  }
}
