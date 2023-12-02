//
//  SocialFeedViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.11.2023.
//

import Foundation
import SwiftUI
import Combine

final class SocialFeedViewModel: ObservableObject {
  @Published var searchQuery: String = ""
}
