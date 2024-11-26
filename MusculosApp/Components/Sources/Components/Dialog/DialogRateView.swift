//
//  RatingDialogView.swift
//  Components
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import SwiftUI
import Utility

public struct DialogRateView: View {
  @Binding private var isPresented: Bool
  @Binding private var rating: Int

  let title: String
  let onSave: (Int) -> Void

  public init(isPresented: Binding<Bool>, rating: Binding<Int>, title: String, onSave: @escaping (Int) -> Void) {
    self._isPresented = isPresented
    self._rating = rating
    self.title = title
    self.onSave = onSave
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 10.0)
      .foregroundStyle(AppColor.navyBlue.opacity(0.88))
      .shadow(radius: 1.0)
      .frame(width: 350, height: 200)
      .overlay {
        VStack {
          Text(title)
            .foregroundStyle(.white)
            .font(AppFont.poppins(.bold, size: 19))

          HStack {
            ForEach(1...5, id: \.self) { index in
              let imageName = rating >= index ? "star-icon" : "star-icon-empty"

              Button(action: {
                rating = index
              }, label: {
                Image(imageName)
                  .resizable()
                  .renderingMode(.template)
                  .aspectRatio(contentMode: .fit)
                  .foregroundStyle(.white)
                  .frame(height: 35)
              })
            }
          }

          Spacer()
          
          PrimaryButton(title: "Save rating", action: {
            onSave(rating)
          })
          .padding()
        }
        .padding()
      }
      .dismissingGesture(direction: .down, action: {
        isPresented = false
      })
  }
}
