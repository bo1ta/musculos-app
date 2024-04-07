//
//  DialogSelectView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import SwiftUI

struct DialogSelectView: View {
  @Environment(\.dismiss) var dismiss
  
  let title: String
  let description: String?
  let buttonTitle: String
  let onButtonTap: ((Int) -> Void)
  
  @State private var selectedValue: Float = 1
  
  init(
    title: String,
    description: String? = nil,
    buttonTitle: String = "Continue",
    onButtonTap: @escaping (Int) -> Void
  ) {
    self.title = title
    self.description = description
    self.buttonTitle = buttonTitle
    self.onButtonTap = onButtonTap
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 25.0)
      .foregroundStyle(Color.AppColor.blue100)
      .shadow(radius: 1.0)
      .frame(width: 300, height: 180)
      .overlay {
        VStack(spacing: 5) {
          Text(title)
            .font(.header(.bold, size: 14))
            .foregroundStyle(Color.AppColor.blue800)
            .padding(.top, 20)
          
          if let description {
            Text(description)
              .font(.body(.regular, size: 10))
              .foregroundStyle(.black)
              .padding([.leading, .trailing], 60)
          }
          
          Slider(
            value: $selectedValue,
            in: 1...15,
            step: 1
          )
          .tint(Color.AppColor.blue500)
          .padding([.leading, .trailing], 15)
          
          Text(String(Int(selectedValue)))
            .font(.body(.bold, size: 15))
            .foregroundStyle(Color.AppColor.blue800)
            .padding(.bottom, 10)
          
          Button {
            onButtonTap(Int(selectedValue))
            dismiss()
          } label: {
            Text(buttonTitle)
              .font(.body(.regular))
              .foregroundStyle(.white)
              .frame(maxWidth: 200)
          }
          .buttonStyle(PrimaryButton())
          .padding(.bottom, 10)
        }
      }
  }
}

#Preview {
  DialogSelectView(title: "How many reps?", onButtonTap: {
      print($0)
  })
}
