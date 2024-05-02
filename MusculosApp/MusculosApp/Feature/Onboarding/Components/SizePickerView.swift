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
  var showCheckMark: Bool = true
  
  var body: some View {
    VStack {
      HStack {
        Text(description)
          .font(.body(.regular, size: 20))
        
        Picker("Picker", selection: $value) {
          ForEach(options, id: \.self) { option in
            Text("\(option)")
              .font(.body(.regular, size: 20))
              .tag(Int?.some(option))
          }
        }
        .pickerStyle(.wheel)
        Text(unit)
          .font(.body(.light, size: 20))
        
        if value != nil && showCheckMark {
          Circle()
            .frame(width: 30, height: 30)
            .foregroundStyle(Color.AppColor.blue500)
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
