//
//  SelectGenderView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import SwiftUI

enum Gender: String {
  case male, female
}

struct SelectGenderView: View {
  @Binding var selectedGender: Gender?
  
  var body: some View {
    VStack {
      genderCards
    }
    .padding(.top, 15)
  }
  
  private var genderCards: some View {
    HStack {
      createGenderCard(.male)
      createGenderCard(.female)
    }
    .padding([.leading, .trailing], 10)
  }

  func createGenderCard(_ gender: Gender) -> some View {
    let isSelected = selectedGender == gender
    let selectedColor = isSelected ? Color.AppColor.blue600 : .black
  
    return VStack(spacing: 20) {
      Button {
        selectedGender = gender
      } label: {
        RoundedRectangle(cornerRadius: 12)
          .foregroundStyle(.white)
          .frame(height: 180)
          .frame(maxWidth: .infinity)
          .shadow(color: selectedColor, radius: 4)
          .overlay {
            Text(gender == .male ? "♂" : "♀")
              .font(.system(size: 64))
              .foregroundStyle(selectedColor)
          }
      }
      .scaleEffect(isSelected ? 0.95 : 1.0)
      Text(gender.rawValue.capitalized)
        .font(.body(.regular, size: 20))
        .foregroundStyle(selectedColor)
    }
    .padding()
  }
}

#Preview {
  SelectGenderView(selectedGender: .constant(nil))
}
