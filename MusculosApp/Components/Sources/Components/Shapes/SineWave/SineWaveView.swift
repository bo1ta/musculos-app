//
//  SineWaveView.swift
//
//
//  Created by Solomon Alexandru on 16.08.2024.
//

import SwiftUI

public struct SineWaveView: View {
  @State private var phase: CGFloat = 0

  let waveCount: Int
  let baseAmplitude: CGFloat
  let baseFrequency: CGFloat

  public init(waveCount: Int = 5, baseAmplitude: CGFloat = 0.05, baseFrequency: CGFloat = 3) {
    self.waveCount = waveCount
    self.baseAmplitude = baseAmplitude
    self.baseFrequency = baseFrequency
  }

  public var body: some View {
    ZStack {
      Color.blue

      ForEach(0..<waveCount, id: \.self) { index in
        SineWaveAnimatableShape(
          phase: phase,
          amplitude: randomizeAmplitude(baseAmplitude),
          frequency: randomizeFrequency(baseFrequency),
          offset: CGFloat(index) / CGFloat(waveCount - 1)
        )
        .fill(Color.white.opacity(Double(index + 1) / Double(waveCount)))
      }
    }
    .ignoresSafeArea()
    .onAppear {
      withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
        phase = .pi * 2
      }
    }
  }

  private func randomizeAmplitude(_ base: CGFloat) -> CGFloat {
    return base * CGFloat.random(in: 0.8...1.2)
  }

  private func randomizeFrequency(_ base: CGFloat) -> CGFloat {
    return base * CGFloat.random(in: 0.9...1.1)
  }
}

#Preview {
  SineWaveView()
}
