//
//  DetailCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.02.2024.
//

import SwiftUI

struct DetailCardView: View {
  var title: String
  var index: Int
  
  @State var textHeight: CGFloat = 0
  
  var body: some View {
    RoundedRectangle(cornerRadius: 5)
      .frame(maxWidth: .infinity)
      .frame(minHeight: textHeight)
      .padding([.leading, .trailing])
      .foregroundStyle(.white)
      .shadow(radius: 1)
      .overlay {
        HStack {
          Circle()
            .frame(width: 40, height: 40)
            .foregroundStyle(.white)
            .shadow(radius: 1)
            .overlay {
              Text("\(index)")
                .font(.custom(AppFont.regular, size: 15))
                .foregroundStyle(.gray)
                .opacity(0.8)
            }
          Text(title)
            .font(.custom(AppFont.light, size: 13))
            .padding(.trailing, 5)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(nil)
            .shadow(radius: 0.5)
            .overlay {
              GeometryReader { proxy in
                Color
                  .clear
                  .preference(key: ContentLengthPreferenceKey.self, value: proxy.size.height + 40)
              }
            }
            .padding()
          Spacer()
        }
        .padding(.leading, 35)
      }
      .onPreferenceChange(ContentLengthPreferenceKey.self, perform: { value in
        DispatchQueue.main.async {
          self.textHeight = value
        }
      })
  }
}

#Preview {
  DetailCardView(title: "Stand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feetStand with your feet", index: 1)
    .previewLayout(.sizeThatFits)
}
