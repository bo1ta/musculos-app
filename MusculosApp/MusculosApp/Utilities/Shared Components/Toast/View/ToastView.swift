//
//  ToastView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import SwiftUI

struct ToastView: View {
  var style: Toast.ToastStyle
  var message: String
  var width: CGFloat = .infinity
  
  var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .shadow(radius: 1)
      .padding(.horizontal, 16)
      .foregroundStyle(Color.AppColor.blue100)
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(style.themeColor)
          .opacity(0.3)
          .padding(.horizontal, 16)
      }
      .overlay {
        HStack(alignment: .center, spacing: 12) {
          Image(systemName: style.systemImageName)
            .foregroundColor(style.themeColor)
          Text(message)
            .font(.body(.medium))
            .foregroundStyle(.black)
        }
      }
  }
}

#Preview {
  ToastView(style: .success, message: "Toast is shown")
}
