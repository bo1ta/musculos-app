//
//  DashboardHeaderCard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.02.2024.
//

import SwiftUI

struct DashboardHeaderCard: View {
  @Environment(\.userStore) var userStore
  
  var body: some View {
    Rectangle()
      .frame(maxWidth: .infinity)
      .frame(height: 130)
      .foregroundStyle(.white)
      .shadow(radius: 10)
      .overlay {
        VStack {
          Spacer()
          HStack {
            Circle()
              .frame(width: 40, height: 40)
              .foregroundStyle(.red)
              .shadow(radius: 1)
            VStack(alignment: .leading) {
              Group {
                Text("Hello,")
                  .font(.header(.bold, size: 20))
                Text(userStore.displayName)
                  .font(.body(.regular, size: 15))
              }
              .foregroundStyle(.black)
            }
            Spacer()
            Button {
              print("notification tapped")
            } label: {
              Image(systemName: "bell.fill")
                .foregroundStyle(.black)
            }
          }
        }
        .padding()
        .padding(.top, 20)
      }
  }
}

#Preview {
  DashboardHeaderCard()
}
