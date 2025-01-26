//
//  LoadingProgressCircle.swift
//
//
//  Created by Solomon Alexandru on 17.08.2024.
//

import SwiftUI
import Utility

public struct LoadingProgressCircle: View {
  @Binding var progress: Double
  let progressColor: Color

  public init(progress: Binding<Double>, progressColor: Color = .orange) {
    _progress = progress
    self.progressColor = progressColor
  }

  public var body: some View {
    ZStack {
      Circle()
        .stroke(Color.white, lineWidth: 10)
        .frame(width: 100, height: 100)

      Circle()
        .trim(from: 0, to: CGFloat(progress))
        .stroke(progressColor, lineWidth: 10)
        .frame(width: 100, height: 100)
        .rotationEffect(Angle(degrees: -90))

      Text("\(Int(progress * 100))%")
        .font(AppFont.poppins(.bold, size: 17))
        .foregroundStyle(.white)
    }
  }
}

#Preview {
  @State var progress = 0.4

  VStack {
    LoadingProgressCircle(progress: $progress)
      .foregroundStyle(.red)
  }
  .ignoresSafeArea()
  .background(Color.black)
}
