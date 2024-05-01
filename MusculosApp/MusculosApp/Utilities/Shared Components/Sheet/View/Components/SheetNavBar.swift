//
//  SheetNavBar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.04.2024.
//

import SwiftUI

struct SheetNavBar: View {
  let title: String
  let onBack: () -> Void
  let onDismiss: () -> Void
  
  var body: some View {
    HStack {
      Button(action: onBack, label: {
        Image(systemName: "chevron.left")
          .font(.system(size: 18))
          .foregroundStyle(.gray)
      })
      
      Spacer()
      
      Text(title)
        .font(.header(.bold, size: 20))
        .foregroundStyle(.black)
      
      Spacer()
      
      Button(action: onDismiss, label: {
        Image(systemName: "xmark")
          .font(.system(size: 18))
          .foregroundStyle(.gray)
      })
    }
  }
}

#Preview {
  SheetNavBar(title: "Create a new workout", onBack: {}, onDismiss: {})
}
