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
    return VStack(spacing: 20) {
      Button {
        selectedGender = gender
      } label: {
        RoundedRectangle(cornerRadius: 12)
          .foregroundStyle(.white)
          .frame(height: 180)
          .frame(maxWidth: .infinity)
          .shadow(color: isSelected ? Color.appColor(with: .customRed) : .gray, radius: 4)
          .overlay {
            Text(gender == .male ? "♂" : "♀")
              .font(.custom("Roboto-Regular", size: 60))
              .foregroundStyle(isSelected ? Color.appColor(with: .customRed) : .black)
          }
      }
      .scaleEffect(isSelected ? 0.95 : 1.0)
      Text(gender.rawValue.capitalized)
        .font(.custom("Roboto-Bold", size: 20))
        .foregroundStyle(selectedGender == gender ? Color.appColor(with: .customRed) : .black)
    }
    .padding()
  }
}

#Preview {
  SelectGenderView(selectedGender: .constant(nil))
}
