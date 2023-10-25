//
//  SliderView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 14.08.2023.
//

import SwiftUI

struct SliderView: View {
  let title: String
  @Binding var sliderValue: Double
  var sliderRange: ClosedRange<Double>

  init(title: String, sliderValue: Binding<Double>, sliderRange: ClosedRange<Double>) {
    self.title = title
    self._sliderValue = sliderValue
    self.sliderRange = sliderRange

    let thumbImage = UIImage(systemName: "circle.fill")
    UISlider.appearance().setThumbImage(thumbImage, for: .normal)
  }

  var body: some View {
    TransparentContainerView {
      Text(title)
        .font(.title2)
        .foregroundColor(.white)
        .padding(.bottom, 5)
      Slider(value: $sliderValue,
           in: sliderRange,
           step: 5)
        .tint(Color.appColor(with: .violetBlue))
      Text("\(Int(sliderValue))")
        .font(.body)
        .foregroundColor(.white)
    }
  }

}

struct SliderView_Previews: PreviewProvider {
  static var previews: some View {
    SliderView(title: "Workout duration", sliderValue: Binding<Double>.constant(5), sliderRange: 5...60)
  }
}

extension Slider {
  func thumbTintColor(_ color: Color) -> some View {
    return self.modifier(ThumbTintColorModifier(thumbColor: color))
  }
}

struct ThumbTintColorModifier: ViewModifier {
  let thumbColor: Color

  func body(content: Content) -> some View {
    content.overlay(
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(thumbColor)
        .frame(width: 20, height: 20)
    )
  }
}
