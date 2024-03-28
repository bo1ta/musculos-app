//
//  SelectSizeView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import SwiftUI

struct SelectSizeView: View {
  @Binding var selectedWeight: Int?
  @Binding var selectedHeight: Int?
  
    var body: some View {
      VStack {
        SizePickerView(value: $selectedWeight, description: "Weight", unit: "KG", options: Array(30...250))
        SizePickerView(value: $selectedHeight, description: "Height", unit: "CM", options: Array(100...230))
      }
      .padding()
    }
}

#Preview {
  SelectSizeView(selectedWeight: .constant(120), selectedHeight: .constant(nil))
}
