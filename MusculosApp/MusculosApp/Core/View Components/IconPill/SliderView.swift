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
    
    init(title: String, sliderValue: Binding<Double>) {
        self.title = title
        self._sliderValue = sliderValue
    }
    
    var body: some View {
        TransparentContainerView {
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            Slider(value: $sliderValue, in: 5...240)
        }
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView(title: "Pick time", sliderValue: Binding<Double>.constant(0))
    }
}
