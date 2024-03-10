//
//  CategorySectionView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.02.2024.
//

import SwiftUI

enum CategorySection: String, CaseIterable {
  case discover, workout, myFavorites
  
  var title: String {
    switch self {
    case .discover:
      "Discover"
    case .workout:
      "Workout"
    case .myFavorites:
      "My Favorites"
    }
  }
}

struct CategorySectionView<Content: View>: View {
  @State private var selectedSection: CategorySection = .discover
  
  var content: (CategorySection) -> Content
  var hasChangedSection: (CategorySection) -> Void
  
  init(content: @escaping (CategorySection) -> Content, hasChangedSection: @escaping (CategorySection) -> Void) {
    self.content = content
    self.hasChangedSection = hasChangedSection
  }
  
  var body: some View {
    VStack {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 50) {
          ForEach(CategorySection.allCases, id: \.title) { categorySection in
              createSectionItem(category: categorySection)
          }
          .padding()
        }
      }
      content(selectedSection)
    }
  }
  
  private func createSectionItem(category: CategorySection) -> some View {
    Button(action: {
      selectedSection = category
      hasChangedSection(category)
    }, label: {
      let isSelected = category == selectedSection
      let widthOfString = category.title.widthOfString(usingFont: UIFont(name: AppFont.Body.medium.rawValue, size: 18) ?? .boldSystemFont(ofSize: 18))
      
      VStack(spacing: 2) {
        Text(category.title)
          .font(isSelected ? .body(.medium, size: 16) : .body(.light, size: 15))
          .foregroundStyle(.black)
        if isSelected {
          Rectangle()
            .frame(width: widthOfString, height: 2)
            .foregroundStyle(AppColor.customRed.color)
        }
      }
    })
  }
}

#Preview {
  CategorySectionView { categorySection in
    Text(categorySection.rawValue)
  } hasChangedSection: { section in
    print(section)
  }
}
