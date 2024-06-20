//
//  OnboardingOptionCardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.06.2024.
//

import Foundation
import SwiftUI
import Utilities

struct OnboardingOptionCardView: View {
  let onboardingOption: OnboardingOption
  let isSelected: Bool
  let didTap: () -> Void
  
  var color: Color {
    isSelected ? AppColor.blue500 : .black
  }
  
  var shouldDisplayContentInCenter: Bool {
    return onboardingOption.image == nil
  }
  
  var horizontalAlignment: HorizontalAlignment {
    shouldDisplayContentInCenter ? .center : .leading
  }
  
  
  var body: some View {
    Button(action: didTap, label: {
      RoundedRectangle(cornerRadius: 25)
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .foregroundStyle(.white)
        .shadow(color: isSelected ? AppColor.blue700 : .gray, radius: 3)
        .overlay {
          HStack {
            if shouldDisplayContentInCenter {
              Spacer()
            }
            
            VStack(alignment: horizontalAlignment, spacing: 5) {
              Text(onboardingOption.title)
                .font(AppFont.header(.medium, size: 16))
                .foregroundStyle(color)
              Text(onboardingOption.description)
                .font(AppFont.body(.regular, size: 13))
                .foregroundStyle(color)
            }
            
            Spacer()
            
            if isSelected {
              Circle()
                .frame(width: 35, height: 35)
                .foregroundStyle(AppColor.blue500)
                .overlay {
                  Image(systemName: "checkmark")
                    .foregroundStyle(.white)
                }
            } else if !isSelected, let image = onboardingOption.image {
              image
                .font(.system(size: 25))
                .foregroundStyle(color)
            }
          }
          .padding(.horizontal, 20)
        }
    })
    .scaleEffect(isSelected ? 0.98 : 1.0)
  }
}
