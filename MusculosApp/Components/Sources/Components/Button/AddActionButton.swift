//
//  AddActionButton.swift
//  Components
//
//  Created by Solomon Alexandru on 27.12.2024.
//

import SwiftUI
import Utility

public struct AddActionButton: View {
  let action: () -> Void

  public init(action: @escaping () -> Void) {
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      RoundedRectangle(cornerRadius: 8)
        .frame(width: 33, height: 33)
        .foregroundStyle(AppColor.navyBlue)
        .overlay {
          Image(systemName: "plus")
            .foregroundStyle(.white)
        }
        .shadow(radius: 4)
    }
  }
}
