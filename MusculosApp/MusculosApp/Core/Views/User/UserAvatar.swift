//
//  UserAvatar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import Models
import NetworkClient
import Shimmer
import Storage
import SwiftUI
import Utility

struct UserAvatar: View {
  let profile: UserProfile?

  var body: some View {
    AsyncCachedImage(url: profile?.avatarUrl) { imagePhase in
      switch imagePhase {
      case .empty:
        Circle()
          .frame(height: 40)
          .defaultShimmering()
      case let .success(image):
        image
          .resizable()
          .frame(width: 40, height: 40)
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
      case .failure:
        Circle()
          .frame(height: 40)
          .foregroundStyle(.green)
      @unknown default:
        EmptyView()
          .onAppear {
            Logger.error(
              MusculosError.unknownError,
              message: "Unknown error while fetching avatar"
            )
          }
      }
    }
  }
}

#Preview {
  UserAvatar(profile: UserProfileFactory.createUser())
}
