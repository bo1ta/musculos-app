//
//  TextResizablePillsStack.swift
//  Components
//
//  Created by Solomon Alexandru on 04.10.2024.
//

import SwiftUI

public struct TextResizablePillsStack: View {
  let options: [String]

  public init(options: [String]) {
    self.options = options
  }

  public var body: some View {
    HStack {
      ForEach(options, id: \.self) { option in
        TextResizablePill(title: option)
      }
    }
  }
}
