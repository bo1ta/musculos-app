//
//  TextPillsStack.swift
//  Components
//
//  Created by Solomon Alexandru on 01.10.2024.
//

import SwiftUI

public struct TextPillsStack: View {
  let options: [String]

  public init(options: [String]) {
    self.options = options
  }

  public var body: some View {
    HStack {
      ForEach(options, id: \.self) { option in
        TextPill(title: option)
      }
    }
  }
}
