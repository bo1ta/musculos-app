//
//  OnboardingWizardViewModelTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation
import XCTest

@testable import MusculosApp

class OnboardingWizardViewModelTests: XCTestCase {
  func testInitialValues() {
    let viewModel = OnboardingWizardViewModel()
    
    XCTAssertNil(viewModel.selectedGender)
    XCTAssertNil(viewModel.selectedHeight)
    XCTAssertNil(viewModel.selectedGoal)
    XCTAssertNil(viewModel.selectedWeight)
    
    XCTAssertEqual(viewModel.wizardStep, .gender)
  }
  
  func testHandleNextSteps() {
    let viewModel = OnboardingWizardViewModel()
    XCTAssertEqual(viewModel.wizardStep, .gender)
    
    viewModel.handleNextStep()
    XCTAssertEqual(viewModel.wizardStep, .heightAndWeight)
    
    viewModel.handleNextStep()
    XCTAssertEqual(viewModel.wizardStep, .goal)
    
    viewModel.handleNextStep()
    XCTAssertEqual(viewModel.wizardStep, .permissions)
  }
  
  func testCanHandleNextStep() {
    let viewModel = OnboardingWizardViewModel()
    XCTAssertTrue(viewModel.canHandleNextStep)
    
    viewModel.wizardStep = .permissions
    XCTAssertFalse(viewModel.canHandleNextStep)
  }
}
