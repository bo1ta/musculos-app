//
//  UserAvatar.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.09.2024.
//

import SwiftUI
import Models
import NetworkClient
import Utility
import Shimmer

struct UserAvatar: View {
  let profile: UserProfile?

  var body: some View {
    AsyncCachedImage(url: profile?.avatarUrl) { imagePhase in
      switch imagePhase {
      case .empty:
        Circle()
          .frame(height: 40)
          .defaultShimmering()
      case .success(let image):
        image
          .resizable()
          .frame(width: 40, height: 40)
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
      case .failure(_):
        Circle()
          .frame(height: 40)
          .foregroundStyle(.green)
      @unknown default:
        EmptyView()
          .onAppear {
            Logger.logError(
              MusculosError.unknownError,
              message: "Unknown error while fetching avatar"
            )
          }
      }
    }
  }
}

#Preview {
  UserAvatar(profile: UserProfileFactory.createProfile())
}
