//
//  UserHeader.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.09.2024.
//

import Components
import Models
import NetworkClient
import SwiftUI
import Utility

struct UserHeader: View {
  let profile: UserProfile?
  let onNotificationsTap: () -> Void

  var body: some View {
    HStack {
      UserAvatar(profile: profile)

      VStack(alignment: .leading, spacing: 2) {
        Text(greetingForCurrentTime)
          .font(AppFont.spartan(.medium, size: 14))
          .foregroundStyle(.orange)

        if let username = profile?.username {
          Heading(username, fontSize: 18)
        }
      }

      Spacer()

      Button(action: onNotificationsTap, label: {
        Image("notification-icon")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 25)
          .foregroundStyle(.black.opacity(0.9))
      })
      .padding(10)
    }
  }

  private var greetingForCurrentTime: String {
    let hour = Calendar.current.component(.hour, from: Date())
    switch hour {
    case 5 ..< 12:
      return "Good Morning"
    case 12 ..< 17:
      return "Good Afternoon"
    case 17 ..< 21:
      return "Good Evening"
    case 21 ..< 24, 0 ..< 5:
      return "Good Night"
    default:
      return "Hello"
    }
  }
}
