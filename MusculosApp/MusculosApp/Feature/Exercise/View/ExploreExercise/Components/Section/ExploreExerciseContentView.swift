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
    HStack(spacing: 0) {
      ForEach(ExploreCategorySection.allCases, id: \.title) { section in
        Button(action: {
          onChangeSection?(section)
        }, label: {
          let isSelected = section == currentSection
          let widthOfString = section.title.widthOfString(usingFont: UIFont(name: AppFont.Body.medium.rawValue, size: 16) ?? .boldSystemFont(ofSize: 18))

          VStack(spacing: 0) {
            Text(section.title)
              .font(AppFont.poppins(section == currentSection ? .semibold : .regular, size: 16))
              .foregroundColor(section == currentSection ? .black : .gray)
              .padding(.horizontal, 16)
              .padding(.vertical, 8)

            if section == currentSection {
              Rectangle()
                .fill(Color.red)
                .frame(height: 2)
            } else {
              Color.gray
                .opacity(0.2)
                .frame(height: 2)
            }
          }
        })
      }
    }
  }
}

#Preview {
  ExploreCategorySectionView(currentSection: .discover, onChangeSection: { _ in })
}


