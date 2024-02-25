//
//  DashboardCategorySection.swift
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

struct DashboardCategorySection<Content: View>: View {
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
      let widthOfString = category.title.widthOfString(usingFont: UIFont(name: AppFont.medium, size: 18) ?? .boldSystemFont(ofSize: 18))
      
      VStack(spacing: 2) {
        Text(category.title)
          .font(.custom(isSelected ? AppFont.medium : AppFont.light, size: 18))
          .foregroundStyle(.black)
        if isSelected {
          Rectangle()
            .frame(width: widthOfString, height: 2)
            .foregroundStyle(Color.appColor(with: .customRed))
        }
      }
    })
  }
}

#Preview {
  DashboardCategorySection { categorySection in
    Text(categorySection.rawValue)
  } hasChangedSection: { section in
    print(section)
  }
}
