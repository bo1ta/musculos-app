//
//  SheetNavBar.swift
//  Components
//
//  Created by Solomon Alexandru on 28.01.2025.
//

import SwiftUI

public struct SheetNavBar: View {
  let title: String
  let onBack: () -> Void
  let onDismiss: () -> Void

  public init(title: String, onBack: @escaping () -> Void, onDismiss: @escaping () -> Void) {
    self.title = title
    self.onBack = onBack
    self.onDismiss = onDismiss
  }

  public var body: some View {
    HStack {
      Button(action: onBack, label: {
        Image(systemName: "chevron.left")
          .font(.system(size: 18))
          .foregroundStyle(.gray)
      })

      Spacer()

      Text(title)
        .font(.header(.bold, size: 20))
        .foregroundStyle(.black)

      Spacer()

      Button(action: onDismiss, label: {
        Image(systemName: "xmark")
          .font(.system(size: 18))
          .foregroundStyle(.gray)
      })
    }
  }
}

#Preview {
  SheetNavBar(title: "Create a new workout", onBack: { }, onDismiss: { })
}
