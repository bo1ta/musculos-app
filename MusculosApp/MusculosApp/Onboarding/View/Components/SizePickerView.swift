//
//  SizePickerView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import SwiftUI

struct SizePickerView: View {
  @Binding var value: Int?
  
  var description: String
  var unit: String
  var options: [Int]
  
  var body: some View {
    VStack {
      HStack {
        Text(description)
          .font(.custom("Roboto-Light", size: 20))
        
        Picker("Picker", selection: $value) {
          ForEach(options, id: \.self) { option in
            Text("\(option)")
              .font(.custom("Roboto-Light", size: 20))
              .tag(Int?.some(option))
          }
        }
        .pickerStyle(.wheel)
        Text(unit)
          .font(.custom("Roboto-Light", size: 20))
        
        if value != nil {
          Circle()
            .frame(width: 30, height: 30)
            .foregroundStyle(AppColor.customRed.color)
            .overlay {
              Image(systemName: "checkmark")
                .foregroundStyle(.white)
            }
            .padding(.leading, 30)
        }
      }
    }
  }
}

#Preview {
  SizePickerView(value: .constant(2), description: "Weight", unit: "kg", options: [2, 3, 4, 5])
}
