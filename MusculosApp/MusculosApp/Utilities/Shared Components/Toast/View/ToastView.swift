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
      .shadow(radius: 3)
      .padding(.horizontal, 16)
      .foregroundStyle(style.backgroundColor)
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(style.borderColor)
          .shadow(radius: 3)
          .opacity(0.3)
          .padding(.horizontal, 16)
      }
      .overlay {
        HStack(alignment: .center, spacing: 12) {
          Image(systemName: style.systemImageName)
            .foregroundColor(style.borderColor)
          Text(message)
            .font(.body(.medium))
            .foregroundStyle(.black)
        }
      }
  }
}

#Preview {
  ToastView(style: .info, message: "Toast is shown")
}
