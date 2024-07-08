//
//  SelectEquipmentView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.06.2024.
//

import Foundation
import SwiftUI
import Models

struct SelectEquipmentView: View {
  @Binding var selectedEquipment: OnboardingData.Equipment?
  
  var body: some View {
    VStack(spacing: 15) {
      ForEach(OnboardingData.Equipment.allCases, id: \.self) { equipment in
        OnboardingOptionCardView(
          onboardingOption: equipment,
          isSelected: selectedEquipment == equipment,
          didTap: { selectedEquipment = equipment }
        )
      }
    }
    .padding(20)
  }
}
