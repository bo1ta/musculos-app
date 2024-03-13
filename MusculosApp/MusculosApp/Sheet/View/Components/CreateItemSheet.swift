//
//  CreateItemSheet.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.03.2024.
//

import Foundation
import SwiftUI

struct CreateItemSheet: View {
  @Environment(\.dismiss) private var dismiss
  
  let onItemTapped: (ItemType) -> Void
  
  var body: some View {
    VStack {
      topBar
        .padding([.trailing, .leading], 20)
      
      HStack(spacing: 10) {
        sheetCardItem(.exercise)
          .opacity(0.8)
        sheetCardItem(.workout)
          .opacity(0.8)
      }
      .padding(.top, 15)
      .padding([.trailing, .leading], 15)
      
      HStack(spacing: 10) {
        sheetCardItem(.goal)
          .opacity(0.8)
        sheetCardItem(.challenge)
          .opacity(0.8)
      }
      .padding(.top, 5)
      .padding([.trailing, .leading], 15)
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

extension CreateItemSheet {
  enum ItemType: String {
    case workout, exercise, goal, challenge
    
    var title: String {
      return self.rawValue.capitalized
    }
    
    var systemImageName: String {
      switch self {
      case .workout:
        "list.dash.header.rectangle"
      case .exercise:
        "dumbbell.fill"
      case .goal:
        "star"
      case .challenge:
        "flag.checkered"
      }
    }
    
    var cardColor: Color {
      switch self {
      case .workout:
        Color.AppColor.blue200
      case .exercise:
        Color.AppColor.green500
      case .goal:
        Color.yellow
      case .challenge:
        Color.orange
      }
    }
    
    var imageColor: Color {
      switch self {
      case .workout:
        Color.AppColor.blue500
      case .exercise:
        Color.AppColor.green700
      case .goal:
        Color.black
      case .challenge:
        Color.black
      }
    }
  }
}

#Preview {
  CreateItemSheet { _ in }
}
