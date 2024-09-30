//
//  ContentSectionWithHeaderAndButton.swift
//  Components
//
//  Created by Solomon Alexandru on 30.09.2024.
//

import SwiftUI
import Utility

public struct ContentSectionWithHeaderAndButton<Content: View>: View {
  private let headerTitle: String
  private let buttonTitle: String
  private let onAction: () -> Void
  private let content: Content
  
  public init(headerTitle: String, buttonTitle: String, onAction: @escaping () -> Void, @ViewBuilder content: () -> Content) {
    self.headerTitle = headerTitle
    self.buttonTitle = buttonTitle
    self.onAction = onAction
    self.content = content()
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(headerTitle)
          .font(AppFont.spartan(.semiBold, size: 20))
        Spacer()
        
        Button(action: onAction, label: {
          Text(buttonTitle)
            .font(AppFont.spartan(.regular, size: 17))
            .foregroundStyle(.orange)
        })
      }
      
      content
    }
  }
}
