//
//  LoadingOverlayView.swift
//
//
//  Created by Solomon Alexandru on 17.08.2024.
//

import SwiftUI
import Utility

public struct LoadingOverlayView: View {
  @Binding var progress: Double
  let progressColor: Color
  let backgroundColor: Color

  public init(
    progress: Binding<Double> = .constant(0.4),
    progressColor: Color = Color.orange,
    backgroundColor: Color = AppColor.navyBlue
  ) {
    _progress = progress
    self.progressColor = progressColor
    self.backgroundColor = backgroundColor
  }

  public var body: some View {
    VStack(alignment: .center) {
      LoadingProgressCircle(progress: $progress)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(backgroundColor)
    .ignoresSafeArea()
  }
}

#Preview {
  LoadingOverlayView()
}
