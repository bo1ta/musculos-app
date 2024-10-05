//
//  ProgressButton.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 05.10.2024.
//

import SwiftUI
import Utility
import Components

struct ProgressButton: View {
  var elapsedTime: Int
  var onStop: () -> Void

  var body: some View {
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
      ActionButton(actionType: .negative, buttonSize: .large, title: "Stop", systemImageName: "arrow.down.right", onClick: onStop)
    }
  }
}

#Preview {
  ProgressButton(elapsedTime: 60, onStop: {})
}
