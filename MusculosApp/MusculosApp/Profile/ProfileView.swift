//
//  ProfileView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.02.2024.
//

import SwiftUI

struct ProfileView: View {
  @EnvironmentObject private var userStore: UserStore
  @Environment(\.mainWindowSize) var mainWindowSize: CGSize
  
  private var userProfile: UserProfileProvider? {
    UserProfileFactory.build(isCurrentUser: true)
  }
  
  var body: some View {
    VStack {
      BlueBackgroundCard()
        .overlay {
          VStack {
            MeDataView(userProfile: userProfile)
              .padding(.top, 10)
          }
        }
      StatsCard()
        .padding(.top, -50)
      
      ScrollView {
        FavoriteSection()
          .padding([.top, .bottom], 30)
        MuscleChartSection()
        
        WhiteBackgroundCard()
        Spacer()
      }
    }
    .ignoresSafeArea()
  }
}

#Preview {
  ProfileView().environmentObject(UserProfile())
}
