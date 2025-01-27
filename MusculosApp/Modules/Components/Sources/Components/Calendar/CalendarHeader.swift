//
//  CalendarHeader.swift
//  Components
//
//  Created by Solomon Alexandru on 26.11.2024.
//

import SwiftUI
import Utility

struct CalendarHeader: View {
  let title: String
  let subtitle: String
  let onPreviousMonth: () -> Void
  let onNextMonth: () -> Void

  init(title: String, subtitle: String, onPreviousMonth: @escaping () -> Void, onNextMonth: @escaping () -> Void) {
    self.title = title
    self.subtitle = subtitle
    self.onPreviousMonth = onPreviousMonth
    self.onNextMonth = onNextMonth
  }

  var body: some View {
    HStack {
      BackRectButton(onBack: onPreviousMonth)

      Spacer()

      VStack {
        Text(title)
          .font(AppFont.spartan(.bold, size: 24))
          .foregroundStyle(.black)
        Text(subtitle)
          .font(AppFont.spartan(.regular, size: 18))
          .foregroundStyle(.gray)
      }

      Spacer()

      BackRectButton(onBack: onNextMonth)
    }
  }
}
