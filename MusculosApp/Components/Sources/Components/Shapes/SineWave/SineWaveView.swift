//
//  SineWaveView.swift
//
//
//  Created by Solomon Alexandru on 16.08.2024.
//

import SwiftUI

public struct SineWaveView: View {
  @State private var phase: CGFloat = 0
  @State private var amplitude: CGFloat = 0
  @State private var frequency: CGFloat = 0

  private let fluctuationAmount: CGFloat = 1.2
  private let bufferAmount: CGFloat = 0.05

  let waveCount: Int
  @Binding var waveSize: CGFloat
  let baseAmplitude: CGFloat
  let baseFrequency: CGFloat
  let backgroundColor: Color
  let wavePosition: SineWaveAnimatableShape.WavePosition
  let baseWaveColor: Color?
  let waveColors: [Color]?
  let isAnimated: Bool
  let animationDuration: Double

  public init(
    waveCount: Int = 2,
    waveSize: Binding<CGFloat> = .constant(0.15),
    baseAmplitude: CGFloat = 0.05,
    baseFrequency: CGFloat = 1.3,
    backgroundColor: Color = .blue,
    wavePosition: SineWaveAnimatableShape.WavePosition = .bottom,
    baseWaveColor: Color? = nil,
    waveColors: [Color]? = [.white],
    isAnimated: Bool = true,
    animationDuration: Double = 5.0
  ) {
    self.waveCount = waveCount
    self._waveSize = waveSize
    self.baseAmplitude = baseAmplitude
    self.baseFrequency = baseFrequency
    self.backgroundColor = backgroundColor
    self.wavePosition = wavePosition
    self.baseWaveColor = baseWaveColor
    self.waveColors = waveColors
    self.isAnimated = isAnimated
    self.animationDuration = animationDuration
    self._amplitude = State(initialValue: baseAmplitude)
  }

  public var body: some View {
    ZStack {
      backgroundColor.ignoresSafeArea()

      ForEach(0..<waveCount, id: \.self) { index in
        SineWaveAnimatableShape(
          waveSize: waveSize,
          phase: phase,
          amplitude: randomizeAmplitude(amplitude),
          frequency: baseFrequency,
          offset: getWaveOffset(for: index),
          wavePosition: wavePosition
        )
        .fill(getWaveColor(for: index))
        .drawingGroup()
      }
    }
    .transition(.slide)
    .onAppear {
      guard isAnimated else { return }

      withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: true)) {
        phase = .pi * 2
        amplitude = .pi * baseAmplitude / 1.5
      }
    }
    .onChange(of: waveSize, { _, _ in
      withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: true)) {
        phase = .pi * 2
        amplitude = .pi * baseAmplitude / 1.5
      }
    })
    .ignoresSafeArea()
  }

  private func randomizeAmplitude(_ base: CGFloat) -> CGFloat {
    return base * CGFloat.random(in: 0.8...1.2)
  }

  private func getWaveOffset(for index: Int) -> CGFloat {
    guard waveCount > 1 else {
      return 1.0
    }
    return CGFloat(index) / CGFloat(waveCount - 1)
  }

  private func getWaveColor(for index: Int) -> Color {
    if let baseWaveColor {
      if index == 0 {
        return baseWaveColor.opacity(0.3)
      } else {
        return baseWaveColor
      }
    }


    if let waveColors, let color = waveColors[safe: index] {
      return color
    } else {
      if index == waveCount - 1 {
        return waveColors?.last ?? backgroundColor
      }
      return Color.white.opacity(Double(index + 1) / Double(waveCount))
    }
  }
}

#Preview {
  SineWaveView()
}
