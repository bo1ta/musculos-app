//
//  GreetingHeader.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.09.2024.
//

import SwiftUI
import Models
import Utility
import NetworkClient
import Components

struct GreetingHeader: View {
  let profile: UserProfile?
  let onSearchTap: () -> Void
  let onNotificationsTap: () -> Void

  var body: some View {
    HStack {
      AsyncCachedImage(url: profile?.avatarUrl) { imagePhase in
        switch imagePhase {
        case .success(let image):
          image
            .resizable()
            .frame(width: 40, height: 40)
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
        case .empty, .failure(_):
          Circle()
            .frame(height: 40)
            .foregroundStyle(.green)
        @unknown default:
          EmptyView()
            .onAppear {
              MusculosLogger.logError(
                MusculosError.unknownError,
                message: "Unknown error while fetching avatar",
                category: .networking
              )
            }
        }
      }

      VStack(alignment: .leading, spacing: 2) {
        Text(greetingForCurrentTime)
          .font(AppFont.poppins(.medium, size: 14))
          .foregroundStyle(AppColor.brightOrange)

        if let username = profile?.username {
          Heading(username, fontSize: 18)
        }
      }

      Spacer()

      Group {
        Button(action: onSearchTap, label: {
          Image(systemName: "magnifyingglass")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 25)
            .foregroundStyle(.gray)
        })
        Button(action: onNotificationsTap, label: {
          Image(systemName: "bell")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 25)
            .foregroundStyle(.gray)
        })
      }
      .padding(10)
    }
  }

  private var greetingForCurrentTime: String {
    let hour = Calendar.current.component(.hour, from: Date())
    switch hour {
    case 5..<12:
      return "Good Morning"
    case 12..<17:
      return "Good Afternoon"
    case 17..<21:
      return "Good Evening"
    case 21..<24, 0..<5:
      return "Good Night"
    default:
      return "Hello"
    }
  }
}
