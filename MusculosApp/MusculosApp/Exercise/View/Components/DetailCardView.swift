//
//  DetailCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.02.2024.
//

import SwiftUI

struct DetailCardView: View {
  var title: String
  @Binding var isSelected: Bool
  
  var body: some View {
    RoundedRectangle(cornerRadius: 5)
      .frame(maxWidth: .infinity)
      .frame(minHeight: 80)
      .padding([.leading, .trailing])
      .foregroundStyle(.white)
      .shadow(radius: 1)
      .overlay {
        HStack {
          Button(action: {
            isSelected.toggle()
          }, label: {
            Circle()
              .frame(width: 40, height: 40)
              .foregroundStyle(.white)
              .shadow(radius: 1)
              .overlay {
                if isSelected {
                  Image(systemName: "checkmark")
                }
              }
          })
          Text(title)
            .font(.custom(isSelected ? AppFont.bold : AppFont.regular, size: 14))
          Spacer()
        }
        .padding(.leading, 35)
      }
  }
}

#Preview {
  DetailCardView(title: "Step 1: Stand with your feet", isSelected: .constant(true))
    .previewLayout(.sizeThatFits)
}
