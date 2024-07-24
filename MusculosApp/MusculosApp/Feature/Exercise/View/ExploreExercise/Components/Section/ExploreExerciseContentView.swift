//
//  CategorySectionView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.02.2024.
//

import SwiftUI
import Utility

struct ExploreCategorySectionView: View {
  var currentSection: ExploreCategorySection
  var onChangeSection: ((ExploreCategorySection) -> Void)?

  var body: some View {
    VStack {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 50) {
          ForEach(ExploreCategorySection.allCases, id: \.title) { section in
            Button(action: {
              onChangeSection?(section)
            }, label: {
              let isSelected = section == currentSection
              let widthOfString = section.title.widthOfString(usingFont: UIFont(name: AppFont.Body.medium.rawValue, size: 16) ?? .boldSystemFont(ofSize: 18))
              
              VStack(spacing: 2) {
                Text(section.title)
                  .font(isSelected ? .body(.medium, size: 16) : .body(.light, size: 15))
                  .foregroundStyle(.black)
                if isSelected {
                  Rectangle()
                    .frame(width: widthOfString, height: 2)
                    .foregroundStyle(Color.AppColor.blue300)
                }
              }
            })
          }
          .padding()
        }
      }
    }
  }
}

#Preview {
  ExploreCategorySectionView(currentSection: .discover, onChangeSection: { _ in })
}


