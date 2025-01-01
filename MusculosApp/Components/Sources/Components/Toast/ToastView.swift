//
//  ToastView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import SwiftUI
import Utility

public struct ToastView: View {
  var style: Toast.ToastStyle
  var message: String
  var width = CGFloat.infinity

  public var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .frame(maxWidth: .infinity)
      .frame(height: 40)
      .shadow(radius: 3)
      .padding(.horizontal, 16)
      .foregroundStyle(.black.opacity(0.9))
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(.white)
          .shadow(radius: 3)
          .opacity(0.8)
          .padding(.horizontal, 16)
      }
      .overlay {
        HStack(alignment: .center, spacing: 12) {
          Image(systemName: style.systemImageName)
            .renderingMode(.template)
            .foregroundStyle(.white)
          Text(message)
            .font(.body(.medium))
            .foregroundStyle(.white)
        }
      }
  }
}

#Preview {
  ToastView(style: .success, message: "Toast is shown")
}
