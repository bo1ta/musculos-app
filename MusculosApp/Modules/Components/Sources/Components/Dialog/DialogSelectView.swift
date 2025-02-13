//
//  DialogSelectView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import SwiftUI

public struct DialogSelectView: View {
  let title: String
  let buttonTitle: String
  let onSelectedValue: (Int) -> Void

  @Binding var isPresented: Bool

  @State private var selectedValue: Float = 1

  public init(
    title: String,
    buttonTitle: String = "Continue",
    isPresented: Binding<Bool>,
    onSelectedValue: @escaping (Int) -> Void)
  {
    self.title = title
    self.buttonTitle = buttonTitle
    self.onSelectedValue = onSelectedValue
    _isPresented = isPresented
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 25.0)
      .foregroundStyle(Color.AppColor.blue100)
      .shadow(radius: 1.0)
      .frame(width: 300, height: 180)
      .overlay {
        VStack(spacing: 5) {
          Heading(title, fontSize: 15.0, fontColor: Color.AppColor.blue800)
            .padding(20)

          Slider(
            value: $selectedValue,
            in: 1 ... 15,
            step: 1)
            .tint(Color.AppColor.blue500)
            .padding(.horizontal, 15)

          Text(String(Int(selectedValue)))
            .font(.body(.bold, size: 15))
            .foregroundStyle(Color.AppColor.blue800)
            .padding(.bottom, 10)

          Button {
            isPresented = false
            onSelectedValue(Int(selectedValue))
          } label: {
            Text(buttonTitle)
              .font(.body(.regular))
              .foregroundStyle(.white)
              .frame(maxWidth: 200)
          }
          .buttonStyle(PrimaryButtonStyle())
          .padding(.bottom, 10)
        }
      }
  }
}

#Preview {
  DialogSelectView(title: "How many reps?", isPresented: .constant(true), onSelectedValue: {
    print($0)
  })
}
