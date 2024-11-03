//
//  DetailCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.02.2024.
//

import SwiftUI
import Utility

struct DetailCardView: View {
  var title: String
  var index: Int
  
  @State private var textHeight: CGFloat = 0
  
  var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .frame(maxWidth: .infinity)
      .frame(minHeight: textHeight)
      .padding(.horizontal)
      .foregroundStyle(.white.opacity(0.99))
      .shadow(color: .black.opacity(0.5), radius: 0.8)
      .overlay {
        HStack {
          RoundedRectangle(cornerRadius: 18)
            .frame(width: 20, height: 40)
            .foregroundStyle(AppColor.navyBlue)
            .overlay {
              Text("\(index)")
                .font(AppFont.poppins(.regular, size: 15))
                .foregroundStyle(.white)
            }

          Text(title)
            .font(AppFont.poppins(.regular, size: 13))
            .padding(.trailing, 5)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(nil)
            .shadow(radius: 0.5)
            .overlay {
              GeometryReader { proxy in
                Color.clear
                  .preference(key: ContentLengthPreferenceKey.self, value: proxy.size.height + 40)
              }
            }
            .padding()
          Spacer()
        }
        .padding(.horizontal, 35)
      }
      .onPreferenceChange(ContentLengthPreferenceKey.self, perform: { value in
        DispatchQueue.main.async {
          self.textHeight = value
        }
      })
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  DetailCardView(title: "Given instruction for a selected exercise", index: 1)
}
