//
//  UserStoreTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.12.2024.
//

import Testing
@testable import MusculosApp

@Suite(.serialized)
struct UserStoreTests {
  @Test func initialValues() async throws {
    let userStore = await UserStore()
    #expect(await userStore.isLoading == false)
    #expect(await userStore.currentUserProfile == nil)
  }
}
