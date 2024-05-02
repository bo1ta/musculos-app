//
//  AddActionSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.03.2024.
//

import Foundation
import SwiftUI

struct AddActionSheet: View {
  @Environment(\.dismiss) private var dismiss
  
  let onItemTapped: (ItemType) -> Void
  
  var body: some View {
    VStack {
      topBar
        .padding([.trailing, .leading], 20)
      
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, content: {
        ForEach(ItemType.allCases, id: \.self) { itemType in
          /// Since it's a single card, it should be centered.
          /// pass an offset
          if itemType == .goal {
            sheetCardItem(itemType)
              .opacity(0.8)
              .offset(x: 100)
          } else {
            sheetCardItem(itemType)
              .opacity(0.8)
          }
        }
      })
    }
  }
  
  private var topBar: some View {
    HStack {
      Text("Create new")
        .font(.header(.bold, size: 23))
        .foregroundStyle(.black)
      Spacer()
      Button(action: {
        dismiss()
      }, label: {
        Image(systemName: "xmark")
          .font(.system(size: 18))
          .foregroundStyle(.gray)
      })
    }
  }
  
  private func sheetCardItem(_ itemType: ItemType) -> some View {
    Button(action: {
      onItemTapped(itemType)
    }, label: {
      RoundedRectangle(cornerRadius: 24)
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .foregroundStyle(itemType.cardColor)
        .overlay {
          VStack(alignment: .center) {
            Image(systemName: itemType.systemImageName)
              .foregroundStyle(itemType.imageColor)
              .font(.system(size: 20))
            
            Text(itemType.title)
              .font(.body(.regular, size: 17))
              .foregroundStyle(.black)
              .padding(.top, 10)
          }
        }
    })
  }
}

extension AddActionSheet {
  enum ItemType: String, CaseIterable {
    case workout, exercise, goal
    
    var title: String { self.rawValue.capitalized }
    
    var systemImageName: String {
      switch self {
      case .workout: "list.dash.header.rectangle"
      case .exercise: "dumbbell.fill"
      case .goal: "star"
      }
    }
    
    var cardColor: Color {
      switch self {
      case .workout: Color.AppColor.blue200
      case .exercise: Color.AppColor.green500
      case .goal: Color.yellow
      }
    }
    
    var imageColor: Color {
      switch self {
      case .workout: Color.AppColor.blue500
      case .exercise: Color.AppColor.green700
      case .goal: Color.black
      }
    }
  }
}

#Preview {
  AddActionSheet { _ in }
}
