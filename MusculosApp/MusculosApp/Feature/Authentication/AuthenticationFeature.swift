//
//  AuthenticationFeature.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.05.2024.
//

import Foundation
//import ComposableArchitecture
//
//@Reducer
//struct AuthenticationFeature {
//  
//  @ObservableState
//  struct State {
//    var isLoading = false
//    var showRegister = false
//    var email = ""
//    var username = ""
//    var password = ""
//    var fullName = ""
//  }
//  
//  enum Action {
//    case signInTapped
//    case registerTapped
//    case authResponse(Bool)
//  }
//  
//  var body: some ReducerOf<Self> {
//    Reduce { state, action in
//      switch action {
//      case .registerTapped:
//        state.isLoading = true
//        return .none
//      case .signInTapped:
//        state.isLoading = true
//        return .none
//      case .authResponse(let success):
//        return .none
//      }
//    }
//  }
//}
//
//extension DependencyValues {
//  var openSettings: @Sendable () async -> Void {
//    get { self[OpenSettingsKey.self] }
//    set { self[OpenSettingsKey.self] = newValue }
//  }
//
//  private enum OpenSettingsKey: DependencyKey {
//    typealias Value = @Sendable () async -> Void
//
//    static let liveValue: @Sendable () async -> Void = {
//      await MainActor.run {
//        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//      }
//    }
//  }
//}
