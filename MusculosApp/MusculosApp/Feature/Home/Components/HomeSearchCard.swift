//
//  HomeSearchCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.08.2024.
//

import SwiftUI
import Utility
import Components

struct HomeSearchCard: View {
  let displayName: String
  let searchQueryText: Binding<String>

  var body: some View {
    VStack(alignment: .center) {
      RoundedRectangle(cornerRadius: 30)
        .foregroundStyle(AppColor.navyBlue)
        .frame(height: 250)
        .overlay {
          VStack {
            HStack {
              Text("Get pumping, \(displayName)")
                .font(AppFont.poppins(.medium, size: 25))
                .foregroundStyle(.white)
                .shadow(radius: 1.0)
              Spacer()
            }
            .padding()

            FormField(text: searchQueryText, hint: "", imageIcon: Image("search-icon"))
              .padding(.horizontal, 30)
          }
        }
    }
  }
}

#Preview {
  HomeSearchCard(displayName: "user", searchQueryText: .constant(""))
}
