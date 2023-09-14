//
//  WorkoutManagerTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import Foundation
import XCTest

class WorkoutManagerTests: XCTestCase {
    func testFetchEquipment() async throws {
        let context = MockPersistentContainer().persistentContainer.newBackgroundContext()
        DataController.setOverride(DataController(container: <#T##NSPersistentContainer#>))

    }
}
