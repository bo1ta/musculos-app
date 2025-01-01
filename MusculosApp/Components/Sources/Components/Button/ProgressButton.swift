//
//  ProgressButton.swift
//  Components
//
//  Created by Solomon Alexandru on 22.12.2024.
//

import SwiftUI
import Utility

public struct ProgressButton: View {
  public var elapsedTime: Int
  public var onClick: () -> Void

  public init(elapsedTime: Int, onClick: @escaping () -> Void) {
    self.elapsedTime = elapsedTime
    self.onClick = onClick
  }

  public var body: some View {
    HStack {
      RoundedRectangle(cornerRadius: UIConstant.Size.small.cornerRadius)
        .foregroundStyle(.white)
        .shadow(color: Color.red, radius: 1.0)
        .frame(height: UIConstant.Size.small.cardHeight - 10)
        .frame(maxWidth: .infinity)
        .overlay {
          Text(DateHelper.formatTimeFromSeconds(Double(elapsedTime)))
            .font(AppFont.poppins(.semibold, size: 40))
            .foregroundStyle(.red)
        }
      ActionButton(
        actionType: .negative,
        buttonSize: .large,
        title: "Stop",
        systemImageName: "arrow.down.right",
        onClick: onClick)
    }
  }
}
