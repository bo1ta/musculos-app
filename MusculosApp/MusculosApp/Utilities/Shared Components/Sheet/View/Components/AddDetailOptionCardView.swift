//
//  AddDetailOptionCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.05.2024.
//

import Foundation
import SwiftUI

struct AddDetailOptionCardView: View {
  @Binding var options: [AddDetailOption]
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Instructions")
        .font(.body(.bold, size: 15))
        .foregroundStyle(.black)
      
      ForEach($options) { option in
        HStack {
          TextField("", text: option.text, axis: .vertical)
            .font(.body(.light, size: 13))
            .textFieldStyle(.roundedBorder)
            .autocorrectionDisabled()
            .lineLimit(3)
          
          if option.id == options.count - 1 {
            Button {
              options.append(AddDetailOption(id: options.count, text: ""))
            } label: {
             Image(systemName: "plus")
                .resizable()
                .foregroundStyle(Color.AppColor.blue500)
                .frame(width: 13, height: 13)
                .shadow(radius: 0.5)
            }
          } else {
            Button {
              options.remove(at: option.id)
            } label: {
                Image(systemName: "minus")
                .foregroundStyle(Color.AppColor.blue500)
                .shadow(radius: 0.5)
            }
          }
        }
        .padding(.bottom, 5)
      }
    }
  }
}

#Preview {
  AddDetailOptionCardView(options: .constant([
    AddDetailOption(id: 0, text: "")
  ]))
}

// MARK: - Option Model

struct AddDetailOption: Identifiable {
  let id: Int
  var text: String
}
