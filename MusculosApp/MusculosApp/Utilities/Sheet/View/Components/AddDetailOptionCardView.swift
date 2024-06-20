//
//  AddDetailOptionCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.05.2024.
//

import Foundation
import SwiftUI
import Utilities

struct AddDetailOptionCardView: View {
  @Binding var options: [AddDetailOption]
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Instructions")
        .font(.body(.bold, size: 15))
        .foregroundStyle(.black)
      
      ForEach($options) { option in
        HStack {
          RoundedTextField(text: option.text, textHint: "Instruction")
            .padding(.top, 10)
          
          if option.id == options.count - 1 {
            Button {
              options.append(AddDetailOption(id: options.count, text: ""))
            } label: {
             Image(systemName: "plus")
                .resizable()
                .foregroundStyle(AppColor.blue500)
                .frame(width: 13, height: 13)
                .shadow(radius: 0.5)
            }
          } else {
            if options.count > 1 {
              Button {
                options.remove(at: option.id)
              } label: {
                Image(systemName: "minus")
                  .foregroundStyle(AppColor.blue500)
                  .shadow(radius: 0.5)
              }
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
